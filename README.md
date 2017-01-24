# BuildBox

The repository provides a complete set of build tools for web developpers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

## Available images

### AWS

Contains AWS Cli + CI Helper

### DIND - AWS

Adds AWS Cli & CI Helper to gitlab's dind image (to run docker in a gitlab runner).

### Java

Contains AWS Cli, CI Helper, and Java 8.

### Node

Contains node (installed in the NODE_VERSION env var value), CI Helper and AWS Cli.

### PHP

Contains PHP (installed in the PHP_VERSION env var value) within a phpenv, composer, php-cs-fixer, AWS Cli and CI Helper.

### Golang

Based upon official Golang image, contains glide, gin, AWS Cli and CI Helper.

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
