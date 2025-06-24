[![Build Status](https://github.com/ekino/docker-buildbox/acti```yaml
versions: # List all the available versions
  "1.0": # The version of your image. This must not change often, so try using major version if possible, or else minor.
    platforms: # Optional: override base platforms, supports linux/amd64 and linux/arm64
      - linux/amd64
      - linux/arm64
    test_config:
      volume: ... # docker volume if needed, format: localdir:/path/to/mount
      cmd: [...]  # shell commands run to be sure tools are well installed
    build_args: [...]  # If ARG are defined in Dockerfile
```flows/build.yml/badge.svg?branch=master)](https://github.com/ekino/docker-buildbox/actions?query=branch%3Amaster)

# BuildBox

The repository provides a complete set of build tools for web developers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

## Requirements

- Docker with buildx support
- Python 3.11
- pipenv (install with `pip install pipenv`)

## Versions

Please review the [CHANGELOG.md](CHANGELOG.md) file for versions per tag.

## Testing

Each box is tested and built using GitHub Actions.

CI workflow:
 - PR: only images with modified files are built.
 - Merge to master: only images with modified files are built and pushed to the docker registry with the tag `latest-IMAGE`
 - TAG: all images are built and pushed to the docker registry
 - Nightly: all images are built and pushed to the docker registry with the tag `nightly-IMAGE`

### Local testing

To contribute you will need docker, docker-buildx, python3.11 and pipenv (installed by `pip install pipenv`).

- Clone the repo
- Create your pipenv environnement
  > pipenv install
- Load your pipenv
  > pipenv shell
- Run the script
  > python image_builder.py build --image image --version version

``` bash
$ python image_builder.py build --help
Usage: image_builder.py build [OPTIONS]

Options:
  --image TEXT    image to build
  --version TEXT  image version
  -d, --debug     debug
  --help          Show this message and exit.
```

``` bash
$ python image_builder.py build --image java --version 17
> Building: ekino/ci-java:17-latest
Build succesfull
> Testing ekino/ci-java:17-latest
Tests successful
```

## Contribution

### Commit message
Please follow the following pattern in your commit message `<type>(<optional scope>): <description>`.
`<type>` can be either `chore` (for a routine/maintenance task), `fix` (for a bugfix) or `feat` (for a new feature).

### Adding your image to the build box

Create a directory named after your image and corresponding Dockerfile in it. Then create a `config.yml` in the same directory according to this schema:

```yaml
versions: # List all the available versions
  "1.0": # The version of your image. This must not change often, so try using major version if possible, or else minor.
    test_config:
      volume: ... # docker volume if needed, format: localdir:/path/to/mount
      cmd: [...]  # shell commands run to be sure tools are well installed
    build_args: [...]  # If ARG are defined in Dockerfile
```

Do not forget to add an entry in `.github/dependabot.yml` too if you want it to update your image.

**If you want multiple Dockerfiles for one image**, you need to use subdirectories named after the version + create one dependabot rule / subdirectory for dependabot to update your base docker images correctly.

**When using subdirectories**, keep in mind that the build context still is the main image folder, so COPY/ADD your files from here.

**Volume mounting** for test configuration only need the directory name as full local path is build by the script.

## Multi-Architecture Support

Most images support multi-architecture builds for both `linux/amd64` and `linux/arm64` platforms. This is configured per image version in the `config.yml` file:

```yaml
platforms:
  - linux/amd64
  - linux/arm64
```

Base platforms are defined in `base_config.yml` and can be overridden per image version.

## Docker Registry

Images are published to both:
- **Docker Hub**: `https://hub.docker.com/r/ekino/ci-{IMAGE}/tags`
- **GitHub Container Registry**: `https://github.com/orgs/ekino/packages/container/package/ci-{IMAGE}`

## Project Structure

The project is organized as follows:

- `image_builder.py` - Main build script for individual images
- `matrix_generator.py` - Generates build matrix for CI/CD (determines which images to build based on file changes)
- `base_config.yml` - Base configuration shared across all images
- `Pipfile` / `Pipfile.lock` - Python dependencies (pipenv-based)
- `src/` - Core Python modules for configuration and Docker utilities
- Each image has its own directory with:
  - `config.yml` - Image-specific configuration
  - `Dockerfile` - Single-version images OR
  - `{version}/Dockerfile` - Multi-version images (e.g., `java/17/Dockerfile`, `java/21/Dockerfile`)

## Available images

**Note**: All images are available on both Docker Hub and GitHub Container Registry. Most images support multi-architecture builds (linux/amd64 and linux/arm64).

### AWS
- https://hub.docker.com/r/ekino/ci-aws/tags
- https://github.com/orgs/ekino/packages/container/package/ci-aws

Contains AWS CLI, Terraform, Terragrunt, Kubectl, Helm, Kustomize, Python, Pipenv, Trivy, Infracost, tfenv, git, zip & misc tools

### Azure
- https://hub.docker.com/r/ekino/ci-azure/tags
- https://github.com/orgs/ekino/packages/container/package/ci-azure

Contains Azure CLI, Terraform, Terragrunt, Kubectl, Helm, Kustomize, Python, Pipenv, Trivy, Infracost, tfenv, git, zip & misc tools

### Chrome
- https://hub.docker.com/r/ekino/ci-chrome/tags
- https://github.com/orgs/ekino/packages/container/package/ci-chrome

Contains Chromium browser and the latest Node LTS.

### Cloudsploit
- https://hub.docker.com/r/ekino/ci-cloudsploit/tags
- https://github.com/orgs/ekino/packages/container/package/ci-cloudsploit

Contains Aquasecurity's Cloudsploit Scanner.

### DIND
- https://hub.docker.com/r/ekino/ci-dind/tags
- https://github.com/orgs/ekino/packages/container/package/ci-dind

Adds AWS Cli & Azure Cli to GitLab's dind image (to run docker in a GitLab runner).

Use case:
```yaml
# .gitlab-ci.yml
test:
  image: ekino/ci-dind:latest
  services:
    - ekino/ci-dind:latest
  variables:
    DOCKER_TLS_CERTDIR: ""
    DOCKER_DRIVER: overlay2
    DOCKER_HOST: "tcp://ekino__ci-dind:2375"
  script:
    - docker ...
```

### Golang
- https://hub.docker.com/r/ekino/ci-golang/tags
- https://github.com/orgs/ekino/packages/container/package/ci-golang

Available versions: 1.23, 1.24

Based upon official Golang image, contains AWS Cli, Gitleaks, GolangCI-Lint, go-mod-upgrade, go-swagger, go-mock, goimports, migrate, rsync, jq and testfixtures.

### Java
- https://hub.docker.com/r/ekino/ci-java/tags
- https://github.com/orgs/ekino/packages/container/package/ci-java

Available versions: 17, 21

Contains AWS Cli, Maven, Graphviz, jq, psql and Java.

### Node
- https://hub.docker.com/r/ekino/ci-node/tags
- https://github.com/orgs/ekino/packages/container/package/ci-node

Available versions: 20, 22

Contains Node.js (installed in the NODE_VERSION env var value), npm, yarn, sass, task and AWS Cli.

### PHP
- https://hub.docker.com/r/ekino/ci-php/tags
- https://github.com/orgs/ekino/packages/container/package/ci-php

Available versions: 8.1, 8.2, 8.3

Contains PHP (installed from official alpine in the PHP_VERSION env var value) within Blackfire, Composer, PHP CS Fixer, Security Checker and AWS Cli.

About Blackfire, please read the official documentation to install the agent https://blackfire.io/docs/integrations/docker, then you should be able to profile a PHP script like this:

```bash
docker exec -it -e BLACKFIRE_CLIENT_ID -e BLACKFIRE_CLIENT_TOKEN my-php-container blackfire run bin/console app:foo:bar
```

### Platform.sh CLI
- https://hub.docker.com/r/ekino/ci-platformsh/tags
- https://github.com/orgs/ekino/packages/container/package/ci-platformsh

Based on a python alpine image, contains platform.sh CLI.

### Python
- https://hub.docker.com/r/ekino/ci-python/tags
- https://github.com/orgs/ekino/packages/container/package/ci-python

Available versions: 3.9, 3.10, 3.11, 3.12, 3.13

Contains Python with PIP, PIPENV, Poetry and AWS CLI.

### Scaleway
- https://hub.docker.com/r/ekino/ci-scaleway/tags
- https://github.com/orgs/ekino/packages/container/package/ci-scaleway

Contains Scaleway CLI, Terraform, Terragrunt, Kubectl, Helm, Kustomize, Python, Pipenv, Trivy, tfenv, git, zip & misc tools


### SonarQube Scanner
- https://hub.docker.com/r/ekino/ci-sonar/tags
- https://github.com/orgs/ekino/packages/container/package/ci-sonar

Contains SonarQube Scanner.
