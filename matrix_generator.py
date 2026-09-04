import json
from glob import glob
from os.path import exists

import yaml
from git import Repo

excluded_files = [  # Changes to those files shouldn't trigger a build
    '.gitignore',
    'CHANGELOG.md',
    'README.md',
    'handover.md',
    '.github/dependabot.yml',
    '.github/copilot-instructions.md',
]

# The runner label that builds each platform natively. arm64 used to be built
# under QEMU on an amd64 runner, where V8's JIT tripped emulation bugs: an
# `npm install` died of SIGILL, BuildKit never noticed its child had gone, and
# the job ran silent to GitHub's 6-hour ceiling. Building on the matching
# architecture removes the emulator, so `docker/setup-qemu-action` is gone from
# the workflow.
RUNNERS = {
    "linux/amd64": "ubuntu-24.04",
    "linux/arm64": "ubuntu-24.04-arm",
}


def get_diff_files_list():
    repo = Repo('.')
    modified_files = repo.commit("origin/master").diff(repo.commit())
    changedFiles = [item.a_path for item in modified_files]
    return changedFiles


def filter_excluded_files(changedFiles):
    filteredFiles = [
        file for file in changedFiles if file not in excluded_files
    ]
    return filteredFiles


def get_paths(changedFiles, unfilteredFiles):
    paths = []
    if changedFiles == []:
        if unfilteredFiles == []:
            # Master or tag job with no diff, builds everything
            return glob("*/")
        else:
            # All files were previously excluded, builds nothing
            return []
    for file in changedFiles:
        if "/" not in file or "/src" in file or ".github" in file:
            return glob("*/")
        else:
            split_path = file.split("/")
            paths.append(split_path[0])
    return set(paths)


def load_config(image):
    with open("base_config.yml") as base_config, open(f"{image}/config.yml") as config:
        return yaml.safe_load(f"{base_config.read()}\n{config.read()}")


def generate_matrix(paths):
    """Emit one build entry per (image, version, platform) and one merge entry
    per (image, version).

    The build entries fan out across architectures because each one is now a
    native, single-platform build. The merge entries reassemble the per-arch
    tags those jobs push into the multi-arch tag users pull, so there is exactly
    one of them per image the build jobs cover.
    """
    build = []
    merge = []

    for image_folder in sorted(paths):
        image = image_folder.replace("/", "")
        if not exists(f"{image}/config.yml"):
            continue

        image_config = load_config(image)
        default_platforms = image_config.get("base_platforms") or []

        for version, version_config in image_config["versions"].items():
            version = str(version)
            platforms = (version_config or {}).get("platforms") or default_platforms
            if not platforms:
                raise SystemExit(
                    f"> [Error] {image} {version}: no platforms configured and no base_platforms to fall back on"
                )

            merge.append({"image": image, "version": version})

            for platform in platforms:
                if platform not in RUNNERS:
                    raise SystemExit(
                        f"> [Error] {image} {version}: no runner label known for platform {platform!r}"
                        f" - known platforms are {', '.join(sorted(RUNNERS))}"
                    )
                build.append({
                    "image": image,
                    "version": version,
                    "platform": platform,
                    "arch": platform.split("/")[1],
                    "runner": RUNNERS[platform],
                })

    print(json.dumps({"build": {"include": build}, "merge": {"include": merge}}))


changedFiles = get_diff_files_list()
filteredFiles = filter_excluded_files(changedFiles)
paths = get_paths(filteredFiles, changedFiles)
generate_matrix(paths)
