import os
import pprint

from docker import DockerClient
from docker.errors import APIError, BuildError, ContainerError
from src.config import load_base_config

base_config = load_base_config()
docker_sock_path = base_config["DOCKER_SOCK_PATH"]
if('DOCKER_HOST' in os.environ):
    docker_sock_path = os.environ['DOCKER_HOST']


docker_client = DockerClient(base_url=docker_sock_path, timeout=base_config["DOCKER_TIMEOUT"])


def build_image(image_conf, image_fullname, dockerfile_directory, dockerfile_path, debug):
    print("> [Info] Building: " + image_fullname)
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

        docker_client.images.build(
            path=dockerfile_directory,
            dockerfile=dockerfile_path,
            tag=image_fullname,
            quiet=True,
            nocache=True,
            buildargs=image_conf["build_args"] if "build_args" in image_conf else {},
            forcerm=True,
        )
        print("Build successful")
    except BuildError as build_error:
        print("> [Error] Build failed\n")
        for line in build_error.build_log:
            if "stream" in line:
                print(line["stream"].strip())
        exit(1)
    except APIError as api_error:
        print("> [Error] API error - " + str(api_error))
        exit(1)


def run_image(image_fullname, image_conf, debug):
    volume = {}

    print("> [Info] Testing " + image_fullname)

    try:
        if "test_config" in image_conf:
            test_config = image_conf["test_config"]
            if "volume" in test_config:
                # Split path:directory string and build volume dict
                splitted_volume = test_config["volume"].split(":")
                volume[f"{os.getcwd()}/{splitted_volume[0]}"] = {
                    "bind": splitted_volume[1],
                    "mode": "ro",
                }
            for cmd in test_config["cmd"]:
                if debug:
                    print(">> Running test: " + cmd)
                container = docker_client.containers.run(
                    image=image_fullname,
                    command=cmd,
                    volumes=volume,
                    stdout=True,
                    stderr=True
                )
                if debug:
                    for line in container.decode('utf-8').split('\n'):
                        print(line)
        print("Tests successful")
    except ContainerError as container_error:
        print(f"'{container_error.command}' command failed")
        for line in container_error.stderr.decode('utf-8').split('\n'):
            print(line)
        exit(1)
    except APIError as api_error:
        print("> [Error] Command test failed - " + str(api_error))
        exit(1)
    finally:
        docker_client.containers.prune()


def login_to_registry(env_conf):
    print("> [Info] Login to registry")
    try:
        docker_client.login(
            username=env_conf["docker_reg_username"], password=env_conf["docker_reg_password"]
        )
        print("Login successful")
    except APIError as api_error:
        print("> [Error] Login failed - " + str(api_error))
        exit(1)


def push_image(image_fullname):
    print("> [Info] Pushing " + image_fullname)
    try:
        for line in docker_client.images.push(image_fullname, stream=True, decode=True):
            # Keep 1st and last line of push cmd
            if "status" in line and "progressDetail" not in line:
                print(f"{line['status']}")
            if "error" in line:
                print(line["error"])
                exit(1)
        print("Push successful")
    except APIError as api_error:
        print("> [Error] Push failed - " + str(api_error))
        exit(1)
        
