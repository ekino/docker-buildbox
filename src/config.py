import copy
import os
import pprint

import yaml
from yaml import Loader

# Keys of load_ci_env's result that must never be printed.
SECRET_KEYS = ("docker_reg_password", "github_token")


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
        "github_token": os.environ.get("GITHUB_TOKEN", ""),
        # Set by a workflow_dispatch run to exercise the publish and merge path
        # without touching a real tag. See is_publishing and get_image_tags.
        "publish_tag": os.environ.get("PUBLISH_TAG", "").strip(),
    }
    if debug:
        # The workflow passes -d, so this lands in a public log. Actions masks
        # registered secrets, but printing credentials by design is one masking
        # gap away from a leak - redact them here instead of relying on that.
        redacted = {
            key: ("<set>" if value else "<unset>") if key in SECRET_KEYS else value
            for key, value in build_info.items()
        }
        pp = pprint.PrettyPrinter(indent=1)
        print(">> CI environment configuration: ")
        pp.pprint(redacted)
        print("\n")
    return build_info


def is_publishing(env_conf):
    """Whether this run publishes, as opposed to only building and testing.

    Publishing runs push per-arch staging tags and then merge them into the tag
    users pull; every other run builds locally, tests, and pushes nothing - so it
    needs no registry credentials at all, which is what lets fork pull requests
    build.

    publish_tag is the escape hatch for exercising this path from a branch. A
    pull request run touches neither the publish nor the merge code, and a
    workflow_dispatch run is not on master, so without it the only way to find
    out whether publishing works is to merge and see - the blind spot that let
    the double-build ship. Setting it publishes under a throwaway tag instead.
    """
    return (
        env_conf["publish_tag"] != ""
        or env_conf["tag"] != ""
        or (env_conf["event_type"] != "pull_request" and env_conf["branch"] == "master")
        or env_conf["event_type"] == "schedule"
    )


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

    # Add version as a build arg automatically
    if "build_args" not in image_config:
        image_config["build_args"] = {}
    image_config["build_args"]["VERSION"] = version

    # Make sure all args are used as strings for Docker API
    if "build_args" in image_config:
        for arg, value in image_config["build_args"].items():
            image_config["build_args"][arg] = str(value)

    image_config["namespace"] = config["namespace"]

    # platforms is documented as an optional override of the base platforms.
    if not image_config.get("platforms"):
        image_config["platforms"] = config.get("base_platforms") or []
    if not image_config["platforms"]:
        raise KeyError(
            f"No platforms configured for {image_type} {version}, and base_config.yml sets no base_platforms"
        )

    return image_config


def get_image_tags(image_name, version, image_conf, env_conf):
    image_repo_name_base = f"{image_conf['namespace']}/ci-{image_name}"
    version_tag = f'{version}-' if version != "1" else ""

    if env_conf["publish_tag"]:
        version_tag += env_conf["publish_tag"]
    elif env_conf["tag"]:
        version_tag += env_conf["tag"]
    elif env_conf["event_type"] == "schedule":
        version_tag += "nightly"
    elif env_conf["branch"] in ["master"]:
        version_tag += "latest"
    else:
        version_tag += "latest"

    tags = {
        "docker_fullname": f"{image_repo_name_base}:{version_tag}",
        "gh_fullname": f"ghcr.io/{image_repo_name_base}:{version_tag}",
        "platforms": {},
    }
    # One staging tag per architecture per registry. Each build job pushes its
    # own, and the merge job assembles the *_fullname tag above from them, so
    # the multi-arch tag users pull only ever references manifests a job tested.
    for platform in image_conf["platforms"]:
        _os, _arch, _variant = parse_platform(platform)
        tags["platforms"][platform] = {
            "docker": f"{image_repo_name_base}-{_arch}:{version_tag}",
            "gh": f"ghcr.io/{image_repo_name_base}-{_arch}:{version_tag}",
        }

    return tags

def parse_platform(platform):
    parts = platform.split("/")
    parts.extend([None])

    return parts[0:3]


def load_retry_config():
    """Load retry configuration from base_config.yml"""
    base_config = load_base_config()
    return base_config.get("retry_config", {
        "max_retries": 3,
        "initial_delay": 2,
        "max_delay": 60,
        "backoff_factor": 2
    })
