import json
from glob import glob
from os.path import exists

import yaml
from git import Repo

matrix = {"include": []}


def get_diff_files_list():
    repo = Repo('.')
    repo.git.branch('master')
    modified_files = repo.commit("master").diff(repo.commit())
    changedFiles = [item.a_path for item in modified_files]
    return changedFiles


def get_paths(changedFiles):
    paths = []
    if changedFiles == []:
        return glob("*/")
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
paths = get_paths(changedFiles)
generate_matrix(paths)
