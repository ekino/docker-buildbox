from os.path import exists

import click

import src.config as config
import src.docker_tools as docker_tools


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
    dockerfile_path = prefixed_dockerfile_path if exists(f"{dockerfile_directory}/{prefixed_dockerfile_path}") else "Dockerfile"

    # Build image tags list (base tag + archs)
    image_tags = config.get_image_tags(image, version, image_conf, env_conf)

    with docker_tools.start_local_registry() as local_registry:

        # Build docker image
        docker_tools.build_image(image_conf, image_tags, dockerfile_directory, dockerfile_path, debug)

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
            # Re-tag image with DockerHub registry name
            docker_tools.tag_image(image_tags["localname"], image_tags["fullname"])

            # Login to registry and push
            docker_tools.login_to_registry(env_conf)
            docker_tools.push_image(image_tags["fullname"])


@click.group()
def cli():
    pass


cli.add_command(build)


if __name__ == "__main__":
    cli()
