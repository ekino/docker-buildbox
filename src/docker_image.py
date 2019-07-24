import pprint

from docker import DockerClient
from docker.errors import APIError, BuildError

docker_client = DockerClient(base_url="unix://var/run/docker.sock")


def build_image(image_conf, image_fullname, dockerfile, debug):
    print("> [Info] Building: " + image_fullname)
    try:
        if debug:
            pp = pprint.PrettyPrinter(indent=1)
            print(">> Building configuration: ")
            pp.pprint(image_conf)
            print('\n')

        docker_client.images.build(
            path=dockerfile,
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
            if 'stream' in line:
                print(line['stream'].strip())
        exit(1)
    except APIError as api_error:
        print("> [Error] API error - " + str(api_error))
        exit(1)


def run_image(image_fullname, image_conf, debug):
    print("> [Info] Testing " + image_fullname)
    try:
        if "cmd_test" in image_conf:
            for cmd in image_conf["cmd_test"]:
                if debug:
                    print(">> Running test: " + cmd)
                docker_client.containers.run(image=image_fullname, command=cmd, auto_remove=True)
        print("Tests successful")
    except APIError as api_error:
        print("> [Error] Command test failed - " + str(api_error))
        exit(1)


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
        docker_client.images.push(image_fullname)
        print("Push successful")
    except APIError as api_error:
        print("> [Error] Push failed - " + str(api_error))
        exit(1)
