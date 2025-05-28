import json
from glob import glob
from os.path import exists

import yaml
from git import Repo

matrix = {"include": []}
excluded_files = [  # Changes to those files shouldn't trigger a build
    '.gitignore',
    'CHANGELOG.md',
    'README.md',
    '.github/dependabot.yml',
    '.github/copilot-instructions.md',
]


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


def generate_matrix(paths):
    for image_folder in paths:
        with open("base_config.yml", 'r') as base_config:
            if exists("{}/config.yml".format(image_folder)):
                with open("{}/config.yml".format(image_folder), 'r') as config:
                    full_config = base_config.read() + config.read()

                    image_config = yaml.safe_load(full_config)

                    for version in image_config["versions"]:
                        matrix["include"].append(
                            {
                                "image": image_folder.replace("/", ""),
                                "version": str(version)
                            }
                        )
    print(json.dumps(matrix))


changedFiles = get_diff_files_list()
filteredFiles = filter_excluded_files(changedFiles)
paths = get_paths(filteredFiles, changedFiles)
generate_matrix(paths)
