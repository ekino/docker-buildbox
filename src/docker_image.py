import os
import pprint
import subprocess

from python_on_whales import docker
from python_on_whales.exceptions import DockerException

from .config import parse_platform


def build_image(image_conf, image_tags, dockerfile_directory, dockerfile_path, debug):

    print("> [Info] Building: " + image_tags["fullname"])
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

        builder = docker.buildx.create(use=True)

        for platform in image_conf["platforms"]:
            print("> [Info] Building arch image: " + image_tags["platforms"][platform])
            docker.buildx.build(
                builder=builder,
                file=os.path.join(dockerfile_directory, dockerfile_path),
                context_path=dockerfile_directory,
                tags=image_tags["platforms"][platform],
                cache=False,
                push=False,
                build_args=image_conf["build_args"] if "build_args" in image_conf else {},
                platforms=[platform],
            )

        builder.remove()

    except DockerException as docker_exception:
        print("> [Error] Build error - " + str(docker_exception))
        exit(1)

    create_image_manifest(image_tags, debug)

    for platform in image_conf["platforms"]:
        annotate_image_manifest(platform, image_tags)

    print("Build successful")


def create_image_manifest(image_tags, debug):
    # TODO: Replace `subprocess.run` with python-on-whales interface when it supports manifest
    arch_tags = list(image_tags["platforms"].values())
    create_manifest_cmd = ["docker", "manifest", "create", image_tags["fullname"]] + arch_tags

    try:
        result = subprocess.run(create_manifest_cmd, check=True, capture_output=True, text=True)
        if debug:
            print(result.stdout)
    except subprocess.CalledProcessError as subprocess_exception:
        print("> [Error] Error creating manifest - " + str(subprocess_exception))
        exit(1)


def annotate_image_manifest(platform, image_tags, debug):
    _os, _arch, _variant = parse_platform(platform)
    annotate_manifest_cmd = ["docker", "manifest", "annotate", image_tags["fullname"], image_tags["platforms"][platform], "--arch", _arch]
    try:
        result = subprocess.run(annotate_manifest_cmd, check=True, capture_output=True, text=True)
        if debug:
            print(result.stdout)
    except subprocess.CalledProcessError as subprocess_exception:
        print("> [Error] Error annotating manifest - " + str(subprocess_exception))
        exit(1)


def run_image(image_fullname, image_conf, debug):
    volume = []

    print("> [Info] Testing " + image_fullname)

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
                container_output = docker.container.run(
                    image=image_fullname,
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


def login_to_registry(env_conf):
    print("> [Info] Login to registry")
    try:
        docker.login(
            username=env_conf["docker_reg_username"], password=env_conf["docker_reg_password"]
        )
        print("Login successful")
    except DockerException as docker_exception:
        print("> [Error] Login failed - " + str(docker_exception))
        exit(1)


def push_image(image_fullname):
    print("> [Info] Pushing " + image_fullname)
    try:
        docker.images.push(image_fullname)
        print("Push successful")
    except DockerException as docker_exception:
        print("> [Error] Push failed - " + str(docker_exception))
        exit(1)
        
