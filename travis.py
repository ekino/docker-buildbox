import click
import jinja2

import src.config as config
import src.docker_image as docker


@click.command()
@click.option("--image", default="aws", help="image to build")
@click.option("--version", default="1", help="image version")
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

    # Build dockerfile path
    dockerfile_directory = (
        image_conf["dockerfile_dir"] if "dockerfile_dir" in image_conf else image
    )

    # Render dockerfile if templatized
    if "template_vars" in image_conf:
        template = jinja2.Environment(loader=jinja2.FileSystemLoader(image)).get_template(
            "Dockerfile.j2"
        )
        # Save in image/Dockerfile
        with open(image + "/Dockerfile", "w") as f:
            f.write(template.render(image_conf["template_vars"]))
            f.close()

    # Build image fullname (registry + repository + tag)
    image_fullname = config.get_image_fullname(image, version, image_conf, env_conf)

    # Build docker image
    docker.build_image(image_conf, image_fullname, dockerfile_directory, debug)

    # Run defined test command
    docker.run_image(image_fullname, image_conf, debug)

    # Push to registry in case of:
    # - tag
    # - push to master
    # - nightly build
    if (
        env_conf["tag"] == "true"
        or (env_conf["event_type"] != "pull_request" and env_conf["branch"] == "master")
        or env_conf["event_type"] == "cron"
    ):
        # Login to registry
        docker.login_to_registry(env_conf)
        docker.push_image(image_fullname)


@click.group()
def cli():
    pass


cli.add_command(build)


if __name__ == "__main__":
    cli()
