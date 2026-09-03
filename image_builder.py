from os.path import exists

import click
from python_on_whales import docker

import src.config as config
import src.docker_tools as docker_tools
import src.version_resolver as version_resolver


@click.command()
@click.option("--image", "-i", default="aws", help="image to build")
@click.option("--version", "-v", default="1", help="image version")
@click.option("--debug", "-d", is_flag=True, help="debug")
def build(image, version, debug):

    # Get env variables
    env_conf = config.load_ci_env(debug)

    # Get image configuration
    try:
        image_conf = config.load_image_config(image, version)
    except KeyError as e:
        print(e)
        exit(1)

    # Build dockerfile directory and path
    dockerfile_directory = image
    prefixed_dockerfile_path = f"{version}/Dockerfile"
    # Set the subdirectory in path because we want dockerfile_directory (aka the build context) to be the parent image directory
    dockerfile_path = prefixed_dockerfile_path if exists(
        f"{dockerfile_directory}/{prefixed_dockerfile_path}") else "Dockerfile"

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

    # Build image tags list (base tag + archs)
    image_tags = config.get_image_tags(image, version, image_conf, env_conf)

    with docker_tools.start_local_registry(), docker_tools.build_builder() as builder:

        # Build, tag and push docker image to local registry
        docker_tools.build_image(image_conf, image_tags["localname"], dockerfile_directory, dockerfile_path, debug,
                                 builder)

        # Run defined test command
        docker_tools.run_image(image_tags["localname"], image_conf, debug)

        # Push to registry in case of:
        # - tag
        # - push to master
        # - nightly build
        if (
            env_conf["tag"] != ""
            or (env_conf["event_type"] != "pull_request" and env_conf["branch"] == "master")
            or env_conf["event_type"] == "schedule"
        ):
            # Login to registry and push
            try:
                docker_tools.login_to_registries(env_conf)
            except Exception as e:
                print(f"> [Error] Failed to login to registries after retries: {e}")
                exit(1)

            # Push to the remote registries (Docker Hub and GHCR). Reusing the
            # builder above means every layer is a cache hit, so this publishes
            # the layers the tests just ran against instead of building the
            # image a second time.
            docker_tools.build_image(image_conf,
                                     [
                                         image_tags["docker_fullname"],
                                         image_tags["gh_fullname"]
                                     ],
                                     dockerfile_directory,
                                     dockerfile_path,
                                     debug,
                                     builder,
                                     cache=True)


@click.group()
def cli():
    pass


cli.add_command(build)


if __name__ == "__main__":
    cli()
