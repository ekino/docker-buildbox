[![Build Status](https://github.com/ekino/docker-buildbox/workflows/Build%20and%20test%20images/badge.svg)](https://github.com/ekino/docker-buildbox/actions?query=branch%3Amaster+event%3Apush)

# BuildBox

The repository provides a complete set of build tools for web developers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

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

To contribute you will need python3.6 and pipenv (installed by `pip install pipenv`).

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
$ python image_builder.py build --image java --version 11
> Building: ekino/ci-java:11-latest
Build succesfull
> Testing ekino/ci-java:11-latest
Tests successful
```

## Adding your image to the build box

Create a directory named after your image and corresponding Dockerfile in it. Then add an entry in `config.yml` according to this schema:

```yaml
image_name:
  version:
    test_config:
      volume: ... # docker volume if needed, format: localdir:/path/to/mount
      cmd: [...]  # shell commands run to be sure tools are well installed
    build_args: [...]  # If ARG are defined in Dockerfile
    template_vars: [...]  # If templated Dockerfile
    dockerfile_dir: /path/to/dockerfile  # If Dockerfile's path is not ./<image_name>/Dockerfile
```
Make sure the `image_name` in the config file entry matches your directory.

Do not forget to add an entry in `.github/workflows/build.yml` too following other image scheme.

**Volume mounting** for test configuration only need the directory name as full local path is build by the script.

## Available images

### Ansible
https://hub.docker.com/r/ekino/ci-ansible/tags

Contains Ansible, CI Helper and Python 2.7

### Arachni
https://hub.docker.com/r/ekino/ci-arachni/tags

Contains Arachni + CI Helper

To run the web UI:

```bash
docker run -d -p 9292:9292 ekino/ci-arachni:1.5-latest arachni_web -o 0.0.0.0
```

Then go to http://localhost:9292

### AWS
https://hub.docker.com/r/ekino/ci-aws/tags

Contains AWS Cli, AWS EB Cli, CI Helper and jq.

### AWSLinux systemd
https://hub.docker.com/r/ekino/ci-awslnx-systemd/tags

Amazon Linux based image containing Systemd for service management in docker container.

### Azure
https://hub.docker.com/r/ekino/ci-azure/tags

Contains Azure Cli and Terraform.

### Chrome
https://hub.docker.com/r/ekino/ci-chrome/tags

Contains Chromium browser and the latest Node LTS.

### DIND - AWS
https://hub.docker.com/r/ekino/ci-dind-aws/tags

Adds AWS Cli & CI Helper to GitLab's dind image (to run docker in a GitLab runner).

Use case:
```yaml
# .gitlab-ci.yml
test:
  image: ekino/ci-dind-aws:latest
  services:
    - ekino/ci-dind-aws:latest
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_HOST:   "tcp://ekino__ci-dind-aws:2375"
  script:
    - docker ...
```

### Golang
https://hub.docker.com/r/ekino/ci-golang/tags

Based upon official Golang image, contains glide, gin, AWS Cli and CI Helper.

### Java
https://hub.docker.com/r/ekino/ci-java/tags

Contains AWS Cli, CI Helper, Maven, Graphviz, jq and Java.

### Kubectl
https://hub.docker.com/r/ekino/ci-kubectl/tags

Contains kubectl, kubens, kubectx, kube-score, eksctl.

### Node
https://hub.docker.com/r/ekino/ci-node/tags

Contains node (installed in the NODE_VERSION env var value), CI Helper and AWS Cli.

### PHP
https://hub.docker.com/r/ekino/ci-php/tags

Contains PHP (installed from official alpine in the PHP_VERSION env var value) within Blackfire, Composer, PHP CS Fixer, Security Checker, AWS Cli and CI Helper.

About Blackfire, please read the official documentation to install the agent https://blackfire.io/docs/integrations/docker, then you should be able to profile a PHP script like this:

```bash
docker exec -it -e BLACKFIRE_CLIENT_ID -e BLACKFIRE_CLIENT_TOKEN my-php-container blackfire run bin/console app:foo:bar
```

### Platform.sh CLI
https://hub.docker.com/r/ekino/ci-platformsh/tags

Based on python 3.6 alpine image, contains php7 and platform.sh CLI.

### Python
https://hub.docker.com/r/ekino/ci-python/tags

Contains Python with PIP and PIPENV.

### React Native Android
https://hub.docker.com/r/ekino/ci-react-native/tags

Contains Java 8, Gradle, Android SDK, Node 12.13.0 and React Native Cli

### Ruby
https://hub.docker.com/r/ekino/ci-ruby/tags

Contains Ruby (installed from official alpine) and CI Helper.

### Scoutsuite
https://hub.docker.com/r/ekino/ci-scoutsuite/tags

Contains ScoutSuite cloud scanner.

### Serverless
https://hub.docker.com/r/ekino/ci-serverless/tags

Contains node Serverless module with python3.

### SonarQube Scanner
https://hub.docker.com/r/ekino/ci-sonar/tags

Contains SonarQube Scanner and CI Helper.

### Terraform
https://hub.docker.com/r/ekino/ci-terraform/tags

Contains Terraform and AWS Cli.
