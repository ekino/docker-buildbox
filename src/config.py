import copy
import os
import pprint

import yaml
from yaml import Loader


def load_ci_env(debug):
    print("> [Info] Gathering env variables")
    event = os.environ.get("GITHUB_EVENT_NAME", "")
    ref = os.environ.get("GITHUB_REF", "").replace("refs/heads/", "").replace("refs/tags/", "")
    build_info = {
        "branch": ref,
        "tag": ref if event == "release" else "",
        "event_type": event,
        "docker_reg_username": os.environ.get("DOCKER_USERNAME", ""),
        "docker_reg_password": os.environ.get("DOCKER_PASSWORD", ""),
    }
    if debug:
        pp = pprint.PrettyPrinter(indent=1)
        print(">> CI environment configuration: ")
        pp.pprint(build_info)
        print("\n")
    return build_info


def load_base_config():
    with open(f"base_config.yml") as base_config_file:
        base_config = base_config_file.read()
    return yaml.load(base_config, Loader=Loader)


def load_image_config(image_type, version):
    config_path = "config.yml"
    base_config_path = f"base_{config_path}"
    image_config_path = f"{image_type}/{config_path}"
    full_config = ""
    with open(base_config_path) as base_config:
        full_config = base_config.read()
    with open(image_config_path) as image_config:
        full_config = f"{full_config}\n{image_config.read()}"
    config = yaml.load(full_config, Loader=Loader)

    # Raise exceptions if a key is not found
    if "versions" not in config:
        raise KeyError("No configuration is set for this image - Image: " + image_type)
    if version not in config["versions"]:
        existing_versions = [v for v, _ in config["versions"].items()]
        raise KeyError(
            f"This version is not defined for {image_type} image - Defined versions: {', '.join(existing_versions)}"
        )

    image_config = config["versions"][version] or dict()

    # Make sure all args are used as strings for Docker API
    if "build_args" in image_config:
        for arg, value in image_config["build_args"].items():
            image_config["build_args"][arg] = str(value)

    image_config["docker_hub_namespace"] = config["docker_hub_namespace"]

    return image_config


def get_image_fullname(image_name, version, image_conf, env_conf):
    image_repo_name_base = f"{image_conf['docker_hub_namespace']}/ci-{image_name}"
    image_tag = f'{version}-' if version != "1" else  ""

    if env_conf["tag"]:
        image_tag += env_conf["tag"]
    elif env_conf["event_type"] == "schedule":
        image_tag += "nightly"
    elif env_conf["branch"] in ["master"]:
        image_tag += "latest"
    else:
        image_tag += "latest"

    return f"{image_repo_name_base}:{image_tag}"


def get_image_tags(image_name, version, image_conf, env_conf):
    image_repo_name_base = f"{image_conf['docker_hub_namespace']}/ci-{image_name}"
    local_repo_name_base = f"localhost:5000/ci-{image_name}"
    version_tag = f'{version}-' if version != "1" else ""

    if env_conf["tag"]:
        version_tag += env_conf["tag"]
    elif env_conf["event_type"] == "schedule":
        version_tag += "nightly"
    elif env_conf["branch"] in ["master"]:
        version_tag += "latest"
    else:
        version_tag += "latest"

    tags = {
        "fullname": f"{image_repo_name_base}:{version_tag}",
        "localname": f"{local_repo_name_base}:{version_tag}",
        "platforms": {},
    }
    for platform in image_conf["platforms"]:
        _os, _arch, _variant = parse_platform(platform)
        tags["platforms"][platform] = f"{image_repo_name_base}-{_arch}:{version_tag}"

    return tags

def parse_platform(platform):
    parts = platform.split("/")
    parts.extend([None])

    return parts[0:3]

