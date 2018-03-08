# BuildBox

The repository provides a complete set of build tools for web developpers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

## Available images

### AWS

Contains AWS Cli + CI Helper

### DIND - AWS

Adds AWS Cli & CI Helper to GitLab's dind image (to run docker in a GitLab runner).

Use case:
```
# .gitlab-ci.yml
test:
  image: ekino/docker-buildbox:latest-dind-aws
  services:
    - ekino/docker-buildbox:latest-dind-aws
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_HOST:   "tcp://ekino__docker-buildbox:2375"
  script:
    - docker ...
```

### Golang

Based upon official Golang image, contains glide, gin, AWS Cli and CI Helper.

### Java

Contains AWS Cli, CI Helper, and Java 8.

### Node

Contains node (installed in the NODE_VERSION env var value), CI Helper and AWS Cli.

### PHP

Contains PHP (installed from official alpine in the PHP_VERSION env var value) within composer, php-cs-fixer, security-checker, AWS Cli and CI Helper.

### Ruby

Contains Ruby (installed from official alpine) and CI Helper.

### Ansible

Contains Ansible, CI Helper and Python 2.7

### SonarQube Scanner

Contains SonarQube Scanner and CI Helper

## Versions

Please review the [CHANGELOG.md](CHANGELOG.md) file for versions per tag.

## Testing

Each box is tested and built using TravisCI.

The ``travis.py`` script try to be clever:
 - PR: only images with modified files are built.
 - Merge to master: only images with modified files are built and pushed to the docker registry with the tag ``latest-IMAGE``
 - TAG: all images are built and pushed to the docker registry
 - Nightly: all images are built and pushed to the docker registry with the tag ``nightly-IMAGE``

[![Build Status](https://travis-ci.org/ekino/docker-buildbox.svg?branch=master)](https://travis-ci.org/ekino/docker-buildbox)

It is possible to build local image for testing with the following command:

    SONARSCANNER_VERSION=3.0.3.778 VERSION=3.0 python travis.py --language sonar --pull-request=true