# BuildBox

The repository provides a complete set of build tools for web developpers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

## Available images

### AWS

Contains AWS Cli + CI Helper

### DIND - AWS

Adds AWS Cli & CI Helper to GitLab's dind image (to run docker in a GitLab runner).

Use case:
```yaml
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

Contains AWS Cli, CI Helper, and Java.
**Please note that for Java 6, the image doesn't contain CI Helper, Modd and AWS Cli.**

### Node

Contains node (installed in the NODE_VERSION env var value), CI Helper and AWS Cli.

### PHP

Contains PHP (installed from official alpine in the PHP_VERSION env var value) within Blackfire, Composer, PHP CS Fixer, Security Checker, AWS Cli and CI Helper.

About Blackfire, please read the official documentation to install the agent https://blackfire.io/docs/integrations/docker, then you should be able to profile a PHP script like this:

```bash
docker exec -it -e BLACKFIRE_CLIENT_ID -e BLACKFIRE_CLIENT_TOKEN my-php-container blackfire run bin/console app:foo:bar
```

### Ruby

Contains Ruby (installed from official alpine) and CI Helper.

### Ansible

Contains Ansible, CI Helper and Python 2.7

### SonarQube Scanner

Contains Node, SonarQube Scanner and CI Helper

### React Native Android

Contains Java 8, Gradle, Android SDK, Node 7.10 and React Native Cli

## Versions

Please review the [CHANGELOG.md](CHANGELOG.md) file for versions per tag.

## Testing

Each box is tested and built using TravisCI.

The `travis.py` script try to be clever:
 - PR: only images with modified files are built.
 - Merge to master: only images with modified files are built and pushed to the docker registry with the tag `latest-IMAGE`
 - TAG: all images are built and pushed to the docker registry
 - Nightly: all images are built and pushed to the docker registry with the tag `nightly-IMAGE`

[![Build Status](https://travis-ci.org/ekino/docker-buildbox.svg?branch=master)](https://travis-ci.org/ekino/docker-buildbox)

It is possible to build local image for testing with the following command:

    CI_HELPER_VERSION=0.0.5 MODD_VERSION=0.5 JAVA_VERSION=10.0.1-jdk-slim VERSION=10 python travis.py --language java --pull-request=true
