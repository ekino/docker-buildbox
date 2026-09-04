[![Build Status](https://github.com/ekino/docker-buildbox/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/ekino/docker-buildbox/actions?query=branch%3Amaster)

# BuildBox

The repository provides a complete set of build tools for web developers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

## Versions

Please review the [CHANGELOG.md](CHANGELOG.md) file for versions per tag.

## Release Process

The project follows a monthly release schedule with releases happening on the last day of each month. All changes are documented in the [CHANGELOG.md](CHANGELOG.md) file.

### CHANGELOG.md Format

The changelog follows a chronological format organized by release date:

```markdown
## YYYY-MM-DD

- ImageName: description of changes
- AnotherImage: description of changes
```

**Guidelines for updating CHANGELOG.md:**

- **Date Format**: Use `YYYY-MM-DD` format for release dates (always the last day of the month)
- **Entry Format**: `* ImageName: description of change`
- **Order**: Most recent entries at the top
- **Sorting**: Within each date section, sort entries alphabetically by image name
- **Scope**: Include all significant changes (version updates, new tools, deprecations)
- **Clarity**: Be specific about what changed (e.g., "updating kubectl from 1.25 to 1.27")

**Important Notes:**
- CHANGELOG.md is in the excluded files list - changes to it don't trigger CI builds
- Update the changelog when making changes to any image
- Use past tense for descriptions ("updated", "added", "removed")
- Group related changes under the same release date
- Include deprecation notices for images being removed

## Testing

Each box is tested and built using GitHub Actions.

CI workflow:
 - PR: only images with modified files are built.
 - Merge to master: only images with modified files are built and pushed to the docker registry with the tag `latest-IMAGE`
 - TAG: all images are built and pushed to the docker registry
 - Nightly: all images are built and pushed to the docker registry with the tag `nightly-IMAGE`

### Local testing

To contribute you will need docker, docker-buildx and [uv](https://docs.astral.sh/uv/)
(installed by `curl -LsSf https://astral.sh/uv/install.sh | sh`). uv provisions
Python itself, so no system Python is required.

- Clone the repo
- Create the environment from the lockfile
  > uv sync
- Run the script
  > uv run python image_builder.py build --image image --version version

``` bash
$ uv run python image_builder.py build --help
Usage: image_builder.py build [OPTIONS]

Options:
  -i, --image TEXT     image to build
  -v, --version TEXT   image version
  -p, --platform TEXT  single platform to build, e.g. linux/arm64 (default:
                       this machine's)
  -d, --debug          debug
  --help               Show this message and exit.
```

``` bash
$ uv run python image_builder.py build --image java --version 21
> Building linux/arm64: ekino/ci-java-arm64:21-latest
Build successful
> Testing ekino/ci-java-arm64:21-latest
Tests successful
```

A local build resolves its tool versions from the GitHub API as it goes. CI
instead resolves them once for the whole run and passes `--versions-file`, so
every architecture of an image gets identical versions.

One invocation builds one architecture. `--platform` defaults to your own
machine's, so a local build is native; pass it explicitly to build another
architecture, which needs QEMU (`docker run --privileged --rm
tonistiigi/binfmt --install all`) and is considerably slower.

In CI each architecture is built on a runner of that architecture and pushed as
a per-arch staging tag (`ekino/ci-java-amd64:21-latest`), which the `merge`
command then assembles into the multi-arch tag users pull. `merge` only does
anything on a publishing run, so you will rarely need it locally.

``` bash
$ uv run python image_builder.py merge --image java --version 21 --markers-dir markers
> Creating ekino/ci-java:21-latest from ekino/ci-java-amd64:21-latest, ekino/ci-java-arm64:21-latest
```

`--markers-dir` must contain one file per configured architecture, named after
it (`amd64`, `arm64`). CI populates it from artifacts that each build job
uploads only after its tests pass, so an architecture that failed has no marker
and the merge refuses rather than publishing a tag that lost it.

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
- https://hub.docker.com/r/ekino/ci-aws/tags
- https://github.com/orgs/ekino/packages/container/package/ci-aws

Contains AWS Cli, Terraform, Kubectl, Helm, Python & misc tools

### Azure
- https://hub.docker.com/r/ekino/ci-azure/tags
- https://github.com/orgs/ekino/packages/container/package/ci-azure

Contains Azure Cli, Terraform, Kubectl, Helm, Python & misc tools

### Chrome
- https://hub.docker.com/r/ekino/ci-chrome/tags
- https://github.com/orgs/ekino/packages/container/package/ci-chrome

Contains Chromium browser and the latest Node LTS.

### ReviewTools
- https://hub.docker.com/r/ekino/ci-reviewtools/tags
- https://github.com/orgs/ekino/packages/container/package/ci-reviewtools

Contains Node.js 24 on Alpine Linux with AI code review tools: Claude Code, OpenAI Codex, and Google Gemini CLI. Runs under a dedicated `reviewtools:reviewtools` user for security.

### GCP
- https://hub.docker.com/r/ekino/ci-gcp/tags
- https://github.com/orgs/ekino/packages/container/package/ci-gcp

Contains GCloud Cli, Terraform, Kubectl, Helm, Kustomize, Terragrunt, Infracost, Python & misc tools

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

Based upon official Golang image, contains AWS Cli, Gitleaks, GolangCI-Lint, go-mod-upgrade, go-swagger, go-mock, goimports, migrate, rsync and testfixtures.

### Java
- https://hub.docker.com/r/ekino/ci-java/tags
- https://github.com/orgs/ekino/packages/container/package/ci-java

Contains AWS Cli, Maven, Graphviz, jq, psql and Java.

### Node
- https://hub.docker.com/r/ekino/ci-node/tags
- https://github.com/orgs/ekino/packages/container/package/ci-node

Contains node (installed in the NODE_VERSION env var value) and AWS Cli.

### PHP
- https://hub.docker.com/r/ekino/ci-php/tags
- https://github.com/orgs/ekino/packages/container/package/ci-php

Contains PHP (installed from official alpine in the PHP_VERSION env var value) within Blackfire, Composer, PHP CS Fixer, Security Checker and AWS Cli.

About Blackfire, please read the official documentation to install the agent https://blackfire.io/docs/integrations/docker, then you should be able to profile a PHP script like this:

```bash
docker exec -it -e BLACKFIRE_CLIENT_ID -e BLACKFIRE_CLIENT_TOKEN my-php-container blackfire run bin/console app:foo:bar
```

### Python
- https://hub.docker.com/r/ekino/ci-python/tags
- https://github.com/orgs/ekino/packages/container/package/ci-python

Contains Python with PIP, PIPENV, UV and Poetry.

### Scaleway
- https://hub.docker.com/r/ekino/ci-scaleway/tags
- https://github.com/orgs/ekino/packages/container/package/ci-scaleway

Contains SCW Cli, Terraform, Kubectl, Helm, Python & misc tools


### SonarQube Scanner
- https://hub.docker.com/r/ekino/ci-sonar/tags
- https://github.com/orgs/ekino/packages/container/package/ci-sonar

Contains SonarQube Scanner.

### Upsun
- https://hub.docker.com/r/ekino/ci-upsun/tags
- https://github.com/orgs/ekino/packages/container/package/ci-upsun

Based on a Python image, contains both Upsun CLI and Platform.sh CLI, git, pipenv and uv.
