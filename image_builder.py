import platform as host_platform_module
from os.path import exists

import click

import src.config as config
import src.docker_tools as docker_tools
import src.version_resolver as version_resolver

# Machine names as Python reports them, mapped to the OCI architecture.
HOST_ARCHITECTURES = {
    "x86_64": "amd64",
    "amd64": "amd64",
    "aarch64": "arm64",
    "arm64": "arm64",
}


def host_platform():
    """The platform this machine builds natively.

    CI always passes --platform explicitly, one job per architecture. Locally
    this keeps `build` a native build by default, because a single-platform
    build is loaded into the daemon to be tested and an emulated one would be
    both slow and, for Node on Alpine, prone to dying of SIGILL.
    """
    machine = host_platform_module.machine().lower()
    if machine not in HOST_ARCHITECTURES:
        raise click.ClickException(
            f"Cannot guess the platform to build on {machine!r} - pass --platform explicitly"
        )
    return f"linux/{HOST_ARCHITECTURES[machine]}"


def resolve_dockerfile(image, version):
    """The build context and the Dockerfile path relative to it.

    The context is always the parent image directory, even when the Dockerfile
    lives in a per-version subdirectory.
    """
    prefixed_dockerfile_path = f"{version}/Dockerfile"
    dockerfile_path = prefixed_dockerfile_path if exists(
        f"{image}/{prefixed_dockerfile_path}") else "Dockerfile"
    return image, dockerfile_path


def load_config(image, version, debug):
    env_conf = config.load_ci_env(debug)
    try:
        image_conf = config.load_image_config(image, version)
    except KeyError as e:
        print(e)
        exit(1)
    return env_conf, image_conf


@click.command()
@click.option("--image", "-i", default="aws", help="image to build")
@click.option("--version", "-v", default="1", help="image version")
@click.option("--platform", "-p", default=None,
              help="single platform to build, e.g. linux/arm64 (default: this machine's)")
@click.option("--debug", "-d", is_flag=True, help="debug")
def build(image, version, platform, debug):
    """Build, test and - on a publishing run - push one architecture of one image.

    One invocation handles one platform, on a runner of that architecture. That
    is what removed QEMU from the pipeline: emulated arm64 builds intermittently
    wedged for hours when V8's JIT hit an instruction the emulator mishandled.
    """
    env_conf, image_conf = load_config(image, version, debug)

    platform = platform or host_platform()
    if platform not in image_conf["platforms"]:
        print(
            f"> [Error] {image} {version} is not configured for {platform}"
            f" - configured platforms are {', '.join(image_conf['platforms'])}"
        )
        exit(1)

    dockerfile_directory, dockerfile_path = resolve_dockerfile(image, version)

    # Resolve the tool versions the Dockerfile expects as build args. Doing it
    # here rather than inside the build means one request per tool instead of one
    # per architecture, and pins the tested image and the pushed one to the same
    # versions.
    try:
        image_conf["build_args"].update(
            version_resolver.resolve(image_conf.get("github_versions") or {}, version)
        )
    except version_resolver.VersionResolutionError as e:
        print(f"> [Error] {e}")
        exit(1)

    image_tags = config.get_image_tags(image, version, image_conf, env_conf)
    arch_tags = image_tags["platforms"][platform]

    # Publish for a release tag, a non-pull-request build of master, or a nightly.
    if config.is_publishing(env_conf):
        try:
            docker_tools.login_to_registries(env_conf)
        except Exception as e:
            print(f"> [Error] Failed to login to registries after retries: {e}")
            exit(1)

        # Push the staging tag rather than loading it: provenance attestations
        # are produced by the BuildKit exporter, so a load followed by a push
        # would drop them. The tag pushed here is then the tag tested below, and
        # the merge job only assembles tags that passed.
        docker_tools.build_image(image_conf, [arch_tags["docker"], arch_tags["gh"]],
                                 dockerfile_directory, dockerfile_path, debug, platform,
                                 push=True)
        docker_tools.run_image(arch_tags["docker"], image_conf, debug)
    else:
        # Nothing is pushed, so no credentials are needed - which is what lets a
        # fork pull request build.
        docker_tools.build_image(image_conf, arch_tags["docker"],
                                 dockerfile_directory, dockerfile_path, debug, platform,
                                 load=True)
        docker_tools.run_image(arch_tags["docker"], image_conf, debug)


@click.command()
@click.option("--image", "-i", default="aws", help="image to merge")
@click.option("--version", "-v", default="1", help="image version")
@click.option("--debug", "-d", is_flag=True, help="debug")
def merge(image, version, debug):
    """Assemble the per-arch staging tags into the multi-arch tag users pull.

    The build jobs run on different machines, so the registry is what they hand
    off through. This reads the staging tags they pushed and writes an OCI index
    over them - a metadata operation, no blobs move. Every source is checked
    first, so an image whose arm64 build failed fails its own merge instead of
    publishing a tag that silently lost an architecture.
    """
    env_conf, image_conf = load_config(image, version, debug)

    if not config.is_publishing(env_conf):
        print("> [Info] Not a publishing run - nothing to merge")
        return

    image_tags = config.get_image_tags(image, version, image_conf, env_conf)

    try:
        docker_tools.login_to_registries(env_conf)
    except Exception as e:
        print(f"> [Error] Failed to login to registries after retries: {e}")
        exit(1)

    for registry, target in (("docker", image_tags["docker_fullname"]),
                             ("gh", image_tags["gh_fullname"])):
        sources = [
            image_tags["platforms"][p][registry] for p in image_conf["platforms"]
        ]
        missing = [source for source in sources if not docker_tools.manifest_exists(source)]
        if missing:
            print(
                f"> [Error] Refusing to publish {target}: missing staging tags"
                f" {', '.join(missing)} - the build job for those architectures failed"
            )
            exit(1)
        docker_tools.create_manifest(sources, target)


@click.group()
def cli():
    pass


cli.add_command(build)
cli.add_command(merge)


if __name__ == "__main__":
    cli()
