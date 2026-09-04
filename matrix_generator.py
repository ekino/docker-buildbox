import argparse
import json
import sys
from glob import glob
from os.path import exists

import yaml
from git import Repo

import src.version_resolver as version_resolver

excluded_files = [  # Changes to those files shouldn't trigger a build
    '.gitignore',
    'CHANGELOG.md',
    'CLAUDE.md',
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

    return {"build": {"include": build}, "merge": {"include": merge}}


def resolve_versions(merge_entries):
    """Resolve every tool version the selected images need, once for the run.

    This used to happen inside each build job. That was one request per tool per
    job, and splitting the matrix by architecture doubled the job count - 45
    requests became 90. Most are authenticated and so bounded by a 5000/hour
    limit, but some repositories (aquasecurity, for one) run an IP allow list
    that refuses authenticated requests from CI runners, and the fallback is the
    anonymous 60/hour. That is what started failing.

    Resolving here spends one request per distinct tool for the whole run - 33
    for a full matrix, fewer than before the split - and, more importantly,
    means both architectures of an image are handed the *same* answers. Two jobs
    resolving independently minutes apart could otherwise pick up different
    versions if a release landed between them, and imagetools would assemble
    those two halves into one multi-arch tag without complaint.
    """
    resolved = {}
    for entry in merge_entries:
        image, version = entry["image"], entry["version"]
        image_config = load_config(image)
        version_config = image_config["versions"][
            next(v for v in image_config["versions"] if str(v) == version)
        ] or {}
        github_versions = version_config.get("github_versions") or {}
        # An entry is written even when empty, so a missing key in the build job
        # is unambiguously a mismatch rather than "this image needs nothing".
        print(f"> [Info] Resolving {len(github_versions)} version(s) for {image} {version}",
              file=sys.stderr)
        resolved[f"{image}:{version}"] = version_resolver.resolve(github_versions, version)
    return resolved


parser = argparse.ArgumentParser()
parser.add_argument(
    "--versions-file",
    help="write the resolved tool versions here, for the build jobs to consume",
)
args = parser.parse_args()

changedFiles = get_diff_files_list()
filteredFiles = filter_excluded_files(changedFiles)
paths = get_paths(filteredFiles, changedFiles)
matrix = generate_matrix(paths)

if args.versions_file:
    # version_resolver logs to stdout, which is the matrix channel, so send the
    # resolution chatter to stderr and keep stdout pure JSON.
    stdout, sys.stdout = sys.stdout, sys.stderr
    try:
        versions = resolve_versions(matrix["merge"]["include"])
    except version_resolver.VersionResolutionError as e:
        print(f"> [Error] {e}", file=sys.stderr)
        raise SystemExit(1)
    finally:
        sys.stdout = stdout
    with open(args.versions_file, "w") as versions_file:
        json.dump(versions, versions_file, indent=2, sort_keys=True)

print(json.dumps(matrix))
