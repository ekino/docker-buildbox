import os
import pprint

import yaml
from yaml import Loader


def load_ci_env(debug):
    print("> [Info] Gathering env variables")
    build_info = {
        "commit_range": os.environ.get("TRAVIS_COMMIT_RANGE", "HEAD...HEAD"),
        "branch": os.environ.get("TRAVIS_BRANCH", ""),
        "tag": os.environ.get("TRAVIS_TAG", ""),
        "pull_request": os.environ.get("TRAVIS_PULL_REQUEST", "false"),
        "travis": os.environ.get("TRAVIS", "false"),
        "event_type": os.environ.get("TRAVIS_EVENT_TYPE", ""),
        "docker_reg_username": os.environ.get("DOCKER_USERNAME", ""),
        "docker_reg_password": os.environ.get("DOCKER_PASSWORD", ""),
    }
    if debug:
        pp = pprint.PrettyPrinter(indent=1)
        info_debug = build_info
        info_debug["docker_reg_password"] = "XXX"
        print(">> CI environment configuration: ")
        pp.pprint(info_debug)
        print('\n')
    return build_info


def load_image_config(image_type, version):
    config_path = "config.yml"
    config = yaml.load(open(config_path), Loader=Loader)

    # Raise exceptions if a key is not found
    if image_type not in config:
        raise KeyError("No configuration is set for this image - Image: " + image_type)
    if version not in config[image_type]:
        existing_versions = [v for v,_ in config[image_type].items()]
        raise KeyError("This version is not defined for " + image_type + " image - Defined versions: " + ', '.join(existing_versions))

    image_config = config[image_type][version] or dict()

    # Make sure all args are used as strings for Docker API
    if "build_args" in image_config:
        for arg, value in image_config["build_args"].items():
            image_config["build_args"][arg] = str(value)

    image_config["docker_hub_namespace"] = config["docker_hub_namespace"]

    return image_config


def get_image_fullname(image_name, version, image_conf, env_conf):
    if env_conf["tag"] != '':
        fullname = (
            image_conf["docker_hub_namespace"] + ":" + image_name + version + "-" + env_conf["tag"]
        )
    elif env_conf["event_type"] == "cron":
        fullname = image_conf["docker_hub_namespace"] + ":nightly-" + image_name + version
    elif env_conf["branch"] in ["master"]:
        fullname = image_conf["docker_hub_namespace"] + ":latest-" + image_name + version
    else:
        fullname = image_conf["docker_hub_namespace"] + ":latest-" + image_name + version

    return fullname
