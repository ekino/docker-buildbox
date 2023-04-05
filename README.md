[![Build Status](https://github.com/ekino/docker-buildbox/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/ekino/docker-buildbox/actions?query=branch%3Amaster)

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

To contribute you will need docker, docker-buildx, python3.6 and pipenv (installed by `pip install pipenv`).

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

## Available images

### AWS
https://hub.docker.com/r/ekino/ci-aws/tags

Contains AWS Cli, Terraform, Kubectl, Helm, Python & misc tools

### AWSLinux systemd
https://hub.docker.com/r/ekino/ci-awslnx-systemd/tags

Amazon Linux based image containing Systemd for service management in docker container.

### Azure
https://hub.docker.com/r/ekino/ci-azure/tags

Contains Azure Cli, Terraform, Kubectl, Helm, Python & misc tools

### Bitcoind
https://hub.docker.com/r/ekino/ci-bitcoind/tags

Contains Bitcoin core (bitcoind & bitcoin-cli).

### Chrome
https://hub.docker.com/r/ekino/ci-chrome/tags

Contains Chromium browser and the latest Node LTS.

### Cloudsploit
https://hub.docker.com/r/ekino/ci-cloudsploit/tags

Contains Aquasecurity's Cloudsploit Scanner.

### DIND
https://hub.docker.com/r/ekino/ci-dind/tags

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
https://hub.docker.com/r/ekino/ci-golang/tags

Based upon official Golang image, contains AWS Cli, Gitleaks, GolangCI-Lint, go-mod-upgrade, go-swagger, go-mock, goimports, migrate, modd, rsync and testfixtures.

### Java
https://hub.docker.com/r/ekino/ci-java/tags

Contains AWS Cli, Maven, Graphviz, jq, psql and Java.

### Node
https://hub.docker.com/r/ekino/ci-node/tags

Contains node (installed in the NODE_VERSION env var value) and AWS Cli.

### Percy
https://hub.docker.com/r/ekino/ci-percy/tags

Contains [Percy CLI](https://docs.percy.io/docs/cli-overview), used to manage https://percy.io/

### PHP
https://hub.docker.com/r/ekino/ci-php/tags

Contains PHP (installed from official alpine in the PHP_VERSION env var value) within Blackfire, Composer, PHP CS Fixer, Security Checker and AWS Cli.

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

Based on Python image, contains Nodejs 14. Used for serverless and CDK use cases, with tools installed in a
`package-lock.json` file.

### SonarQube Scanner
https://hub.docker.com/r/ekino/ci-sonar/tags

Contains SonarQube Scanner.

### TezosQA
https://hub.docker.com/r/ekino/ci-tezosqa/tags

Contains ligo, SmartPy, and Pytezos.
