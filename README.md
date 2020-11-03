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

## Contribution

### Commit message
Please follow the following pattern in your commit message `<type>(<optional scope>): <description>`.
`<type>` can be either `chore` (for a routine/maintenance task), `fix` (for a bugfix) or `feat` (for a new feature).

### Adding your image to the build box

Create a directory named after your image and corresponding Dockerfile in it. Then add an entry in `config.yml` according to this schema:

```yaml
image_name:
  version:
    test_config:
      volume: ... # docker volume if needed, format: localdir:/path/to/mount
      cmd: [...]  # shell commands run to be sure tools are well installed
    build_args: [...]  # If ARG are defined in Dockerfile
    template_vars:  # If templated Dockerfile
      BASE_IMAGE_VERSION:
    dockerfile_dir: /path/to/dockerfile  # If Dockerfile's path is not ./<image_name>/Dockerfile
```
Make sure the `image_name` in the config file entry matches your directory.

Do not forget to add an entry in `.github/workflows/build.yml` too following other image scheme.

**Volume mounting** for test configuration only need the directory name as full local path is build by the script.

**Templating** is used **ONLY** for based image version. For any other variables used in a Dockerfile, prefer build args. Base image version(s) should be defined in a variable named `BASE_IMAGE_VERSION`.

## Available images

### Ansible
https://hub.docker.com/r/ekino/ci-ansible/tags

Contains Ansible, CI Helper and Python 2.7

### AWS
https://hub.docker.com/r/ekino/ci-aws/tags

Contains AWS Cli, AWS EB Cli, CI Helper and jq.

### AWSLinux systemd
https://hub.docker.com/r/ekino/ci-awslnx-systemd/tags

Amazon Linux based image containing Systemd for service management in docker container.

### Azure
https://hub.docker.com/r/ekino/ci-azure/tags

Contains Azure Cli and Terraform.

### Bitcoind
https://hub.docker.com/r/ekino/ci-bitcoind/tags

Contains Bitcoin core (bitcoind & bitcoin-cli).

### Chrome
https://hub.docker.com/r/ekino/ci-chrome/tags

Contains Chromium browser and the latest Node LTS.

### DIND
https://hub.docker.com/r/ekino/ci-dind/tags

Adds AWS Cli, IBMCloud Cli, Azure Cli & CI Helper to GitLab's dind image (to run docker in a GitLab runner).

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
https://hub.docker.com/r/ekino/ci-golang/tags

Based upon official Golang image, contains AWS Cli, CI Helper, Gitleaks, GolangCI-Lint, go-mod-upgrade, go-swagger, go-mock, goimports, migrate, modd, rsync and testfixtures.

### IBM
https://hub.docker.com/r/ekino/ci-ibm/tags

Based upon Golang image, contains Terraform, IBM and Null Terraform provider located in `/terraform.d/plugins` and ibmcloud cli.
Contains kubectl and Helm.

To init Terraform with IBM provider, use:
```bash
$ terraform init -provider-path=/terraform.d/plugins
```

### Java
https://hub.docker.com/r/ekino/ci-java/tags

Contains AWS Cli, CI Helper, Maven, Graphviz, jq, psql and Java.

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

### Pynode
https://hub.docker.com/r/ekino/ci-pynode/tags

Based on Python image, contains Nodejs 12. Used for serverless and CDK use cases, with tools installed in a
`package-lock.json` file.

### React Native Android
https://hub.docker.com/r/ekino/ci-react-native/tags

Contains Java 8, Gradle, Android SDK, Node 12.13.0 and React Native Cli

### Ruby
https://hub.docker.com/r/ekino/ci-ruby/tags

Contains Ruby (installed from official alpine) and CI Helper.

### Scoutsuite
https://hub.docker.com/r/ekino/ci-scoutsuite/tags

Contains ScoutSuite cloud scanner.

### SonarQube Scanner
https://hub.docker.com/r/ekino/ci-sonar/tags

Contains SonarQube Scanner and CI Helper.

### Terraform
https://hub.docker.com/r/ekino/ci-terraform/tags

Contains Terraform and AWS Cli.

### TezosQA
https://hub.docker.com/r/ekino/ci-tezosqa/tags

Contains ligo, SmartPy, and Pytezos.
