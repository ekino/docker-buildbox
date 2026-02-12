import os
import pprint
import time
from functools import wraps

from python_on_whales import docker
from python_on_whales.exceptions import DockerException

import src.config as config

# Load retry configuration from base_config.yml
_retry_config = None

def get_retry_config():
    global _retry_config
    if _retry_config is None:
        _retry_config = config.load_retry_config()
    return _retry_config


def retry_with_backoff(max_retries=None,
                       initial_delay=None,
                       max_delay=None,
                       backoff_factor=None,
                       exceptions=(DockerException,)):
    """
    Decorator that retries a function with exponential backoff.

    Args:
        max_retries: Maximum number of retry attempts (None = use config default)
        initial_delay: Initial delay between retries in seconds (None = use config default)
        max_delay: Maximum delay between retries in seconds (None = use config default)
        backoff_factor: Multiplier for delay after each retry (None = use config default)
        exceptions: Tuple of exceptions to catch and retry
    """
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # Load config defaults if not specified
            retry_cfg = get_retry_config()
            _max_retries = max_retries if max_retries is not None else retry_cfg["max_retries"]
            _initial_delay = initial_delay if initial_delay is not None else retry_cfg["initial_delay"]
            _max_delay = max_delay if max_delay is not None else retry_cfg["max_delay"]
            _backoff_factor = backoff_factor if backoff_factor is not None else retry_cfg["backoff_factor"]

            delay = _initial_delay
            last_exception = None

            for attempt in range(_max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    last_exception = e
                    if attempt < _max_retries:
                        print(f"> [Warning] Attempt {attempt + 1}/{_max_retries + 1} failed: {str(e)}")
                        print(f"> [Info] Retrying in {delay} seconds...")
                        time.sleep(delay)
                        delay = min(delay * _backoff_factor, _max_delay)
                    else:
                        print(f"> [Error] All {_max_retries + 1} attempts failed")
                        raise last_exception

            return None
        return wrapper
    return decorator


@retry_with_backoff()  # Uses config defaults
def build_image(image_conf, image_tag, dockerfile_directory, dockerfile_path, debug):
    print("> [Info] Building: " + image_tag[0])
    try:
        if debug:
            pp = pprint.PrettyPrinter(indent=1)
            print(">> Building configuration: ")
            pp.pprint(image_conf)
            print("\n")
            print(">> Dockerfile directory: ")
            print(dockerfile_directory)
            print("\n")
            print(">> Dockerfile relative path: ")
            print(dockerfile_path)
            print("\n")

        # Create a buildx builder instance
        builder = docker.buildx.create(
            use=True, driver_options=dict(network="host"))

        # Build and push to local registry
        docker.buildx.build(
            builder=builder,
            file=os.path.join(dockerfile_directory, dockerfile_path),
            context_path=dockerfile_directory,
            tags=image_tag,
            cache=False,
            push=True,
            build_args=image_conf["build_args"] if "build_args" in image_conf else {
            }, platforms=image_conf["platforms"]
        )

    except DockerException as docker_exception:
        print("> [Error] Build error - " + str(docker_exception))
        exit(1)
    finally:
        builder.remove()

    print("Build successful")


@retry_with_backoff(max_retries=2)  # Fewer retries for tests, other values from config
def run_image(image_name, image_conf, debug):
    volume = []

    print("> [Info] Testing " + image_name)

    try:
        if "test_config" in image_conf:
            test_config = image_conf["test_config"]
            if "volume" in test_config:
                # Split path:directory string and build volume dict
                splitted_volume = test_config["volume"].split(":")
                volume = [(f"{os.getcwd()}/{splitted_volume[0]}",
                          splitted_volume[1],
                          "ro")]
            for cmd in test_config["cmd"]:
                cmd_list = cmd.split(" ")
                if debug:
                    print(">> Running test: " + str(cmd_list))
                for platform in image_conf["platforms"]:
                    container_output = docker.container.run(
                        image=image_name,
                        platform=platform,
                        command=cmd_list,
                        volumes=volume
                    )
                    if debug:
                        print(container_output)
        print("Tests successful")
    except DockerException as e:
        print("> [Error] Command test failed - " + str(e))
        exit(1)
    finally:
        docker.container.prune()


def tag_image(image, tag):
    docker.image.tag(image, tag)


def start_local_registry():
    return docker.run("registry:2", detach=True, publish=[(5000, 5000)], restart='always', name='registry')


@retry_with_backoff()  # Uses config defaults
def login_to_registries(env_conf):
    print("> [Info] Login to registries")
    try:
        docker.login(
            username=env_conf["docker_reg_username"], password=env_conf["docker_reg_password"]
        )
        print("Login to docker hub successful")
    except DockerException as docker_exception:
        print("> [Error] Login failed - " + str(docker_exception))
        raise
    try:
        docker.login(
            server="ghcr.io", username="ci", password=env_conf["github_token"]
        )
        print("Login to GHCR successful")
    except DockerException as docker_exception:
        print("> [Error] Login failed - " + str(docker_exception))
        raise
