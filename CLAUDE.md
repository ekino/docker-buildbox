# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker BuildBox is a collection of Docker images designed for CI/CD pipelines (primarily GitLab CI). These images provide standardized build environments for various programming languages and cloud tools. **CRITICAL: These images are NOT for production use.**

## Common Commands

### Local Development Setup
```bash
# Setup Python environment (requires Python 3.11)
pipenv install
pipenv shell
```

### Building and Testing Images
```bash
# Build a specific image/version (must use pipenv shell or pipenv run)
# One invocation builds ONE architecture. --platform defaults to the host's.
pipenv run python image_builder.py build --image IMAGE_NAME --version VERSION

# Examples
pipenv run python image_builder.py build --image java --version 17
pipenv run python image_builder.py build --image php --version 8.3
pipenv run python image_builder.py build --image aws --version 1 --debug
pipenv run python image_builder.py build --image aws --version 1 --platform linux/amd64

# Assemble the per-arch staging tags into the multi-arch tag (publishing runs only).
# --markers-dir must hold one file per configured arch, named after it (amd64, arm64);
# CI populates it from the build jobs' artifacts.
pipenv run python image_builder.py merge --image aws --version 1 --markers-dir markers

# Generate build matrix (used by CI)
pipenv run python matrix_generator.py

# Alternative: activate pipenv environment first
pipenv shell
python image_builder.py build --image IMAGE_NAME --version VERSION
```

### Testing Commands
Tests are defined in each image's `config.yml` under `test_config.cmd` and run automatically during the build process. Each test verifies tool installations and basic functionality.

## Architecture Overview

### Core Build System
- **`image_builder.py`**: Main build script using Click CLI framework
- **`matrix_generator.py`**: Generates CI build matrix by analyzing Git diffs
- **`src/config.py`**: Configuration management and YAML loading
- **`src/docker_tools.py`**: Docker operations (build, test, push) using python-on-whales
- **`base_config.yml`**: Shared configuration (namespace, platforms, Docker settings)

### Image Structure
Each image lives in its own directory with:
- **Single-version images**: `image/Dockerfile` + `image/config.yml`
- **Multi-version images**: `image/VERSION/Dockerfile` + `image/config.yml`

Build context is always the parent image directory, even for subdirectory Dockerfiles.

### Configuration Schema
```yaml
# image/config.yml
platforms: &platforms  # Optional: override base platforms
  - linux/amd64
  - linux/arm64
test_config: &test_config
  volume: "localdir:/container/path"  # Optional: mount for tests
  cmd:  # Test commands to verify installation
    - "tool --version"
build_args: &build_args  # Optional: Docker build arguments
  TOOL_VERSION: "1.2.3"
github_versions: &github_versions  # Optional: versions resolved from the GitHub API
  TOOL_VERSION: owner/repo  # latest release, without its leading v
  OTHER_VERSION:
    repo: owner/repo
    rule: latest  # or latest_tag, kustomize, latest_v3, highest_with_prefix
versions:
  "version_name":
    platforms: *platforms
    build_args: *build_args
    github_versions: *github_versions
    test_config: *test_config
```

### Resolving tool versions
Every `github_versions` entry is resolved before building and passed as a build
arg, so the Dockerfiles never call the GitHub API themselves. Each entry needs a
matching `ARG NAME` in the Dockerfile. Resolution rules live in
`src/version_resolver.py`:

| rule | picks |
| --- | --- |
| `latest` (default) | the latest release, minus a leading `v` |
| `latest_tag` | the latest release tag verbatim |
| `kustomize` | the latest `kustomize/vX.Y.Z` tag |
| `latest_v3` | the newest stable `v3.x.y` release |
| `highest_with_prefix` | the highest release tagged `<image version>.*` |

**In CI, resolution happens once per run, in `generate_matrix`**, which writes
`versions.json` and uploads it as the `resolved-versions` artifact; each build
job downloads it and passes `--versions-file`, making no API calls of its own.
Do not move this back into the build jobs. Two reasons:

- **Volume.** One request per tool per job was 45 for a full matrix, and the
  per-architecture split doubled it to 90. Most requests are authenticated and
  bounded by 5000/hour, but some repositories (`aquasecurity`, for one) run an
  IP allow list that refuses authenticated requests from runners, and
  `version_resolver` then falls back to the anonymous 60/hour. That is what
  started failing builds. Central resolution plus the response cache in
  `version_resolver` makes a full matrix **19** requests.
- **Consistency.** Two jobs resolving the same tool minutes apart can get
  different answers if a release lands between them, and `imagetools create`
  would assemble those two halves into one multi-arch tag without complaint.
  Resolving once means both architectures are handed identical versions by
  construction.

`generate_matrix` is consequently the only job that holds the API token. Set
`GH_AUTH_HEADER` (CI does, from a scoped GitHub App token) to get the
authenticated rate limit; without it resolution still works, anonymously - a
local `image_builder.py build` with no `--versions-file` resolves live.
Because the versions arrive as build args, a bare `docker build` fails with
`NAME: must be passed as a build arg` - build through `image_builder.py`.

### CI/CD Matrix Logic
The build system intelligently determines which images to build:
- **PR**: Only builds images with modified files
- **Master merge**: Builds modified images → pushes as `latest-IMAGE` tags
- **Tag release**: Builds ALL images → pushes with version tags
- **Nightly**: Builds ALL images → pushes as `nightly-IMAGE` tags

Files in `excluded_files` list don't trigger builds: `.gitignore`, `CHANGELOG.md`, `README.md`, `handover.md`, `.github/dependabot.yml`, `.github/copilot-instructions.md`

`matrix_generator.py` emits two matrices in one JSON object:
- `build`: one entry per `(image, version, platform)`, carrying the `runner`
  label for that platform (`RUNNERS` maps `linux/amd64` → `ubuntu-24.04`,
  `linux/arm64` → `ubuntu-24.04-arm`)
- `merge`: one entry per `(image, version)`

The `merge` job depends on `build` with `if: !cancelled()` rather than the
default `success()`: `fail-fast` is off, so one image failing must not skip the
other 26 merges. Isolation comes from **per-arch markers** instead: each build
job writes `markers/<arch>` and uploads it as a `tested-<image>-<version>-<arch>`
artifact, and that step only runs if the build-and-test step succeeded. `merge`
downloads the markers matching its own image and refuses to publish unless every
configured platform has one, so a broken image fails only its own merge.

Do **not** gate the merge on staging-tag existence instead. A tag existing says
nothing about which run put it there or whether its tests passed: the publishing
path pushes *before* it tests, so the tag can hold an image whose tests then
failed, and a tag left by last night's run outlives a build job that fails
before pushing anything. Reading the digest back with `imagetools inspect` is
not a fix either - Docker Hub's CDN served a stale digest for a tag during
development of this.

Whether a run publishes is decided once, by the `publishing` output of
`generate_matrix`, which mirrors `config.is_publishing`. The build marker steps
and the whole `merge` job key off it.

### Available Images
- **aws**: AWS CLI, Terraform, Kubectl, Helm, Python
- **azure**: Azure CLI, Terraform, Kubectl, Helm, Python
- **chrome**: Chromium + Node.js LTS
- **cloudsploit**: Aquasecurity's Cloudsploit Scanner
- **dind**: Docker-in-Docker + AWS/Azure CLI
- **golang**: Go + AWS CLI, Gitleaks, GolangCI-Lint, tools
- **java**: Java 17/21 + AWS CLI, Maven, tools
- **node**: Node.js + AWS CLI
- **php**: PHP 8.2/8.3/8.4 + Composer, Blackfire, AWS CLI
- **platformsh**: Platform.sh CLI
- **python**: Python 3.10-3.14 + pip, pipenv
- **scaleway**: Scaleway CLI + Terraform, Kubectl, Helm
- **sonar**: SonarQube Scanner

### Multi-Architecture Support
- Default: `linux/amd64` (from `base_platforms` in `base_config.yml`, when a
  version sets no `platforms` of its own)
- Most images support: `linux/amd64` + `linux/arm64`
- **Each architecture is built natively on a runner of that architecture, one
  job per platform - there is no QEMU in the pipeline.** Emulated arm64 builds
  intermittently died of SIGILL inside `npm install`; BuildKit never noticed its
  child had gone, so the job ran silent to GitHub's 6-hour ceiling.
- A single-platform build can be `--load`ed into the local daemon, so:
  - **pull request run**: `--load`, test, push nothing (no credentials needed,
    so fork pull requests build)
  - **publishing run**: `--push` the per-arch staging tag, test *that tag*, then
    `merge`. Pushing rather than loading preserves the provenance attestation,
    which is a BuildKit export artifact and would be lost by a `load` + `push`.
- The `merge` command runs `docker buildx imagetools create` over the per-arch
  staging tags, gated on the markers described above. This writes an OCI index
  referencing manifests already in the registry, so no blobs move; it is
  idempotent and rerunnable.
- There is no local `registry:2` container any more, and no `localname` tag.

## Dependencies
- **Python 3.11** with pipenv
- **Key packages**: python-on-whales (Docker API), click (CLI), pyyaml, gitpython, pydantic

## Registry Publishing
Images published to:
- **Docker Hub**: `ekino/ci-{IMAGE}:{TAG}`
- **GitHub Packages**: `ghcr.io/ekino/ci-{IMAGE}:{TAG}`

## Important Development Notes
- Build context for subdirectory Dockerfiles is always the parent image directory
- Volume mounting in tests only needs directory name (full path built by script)
- CHANGELOG.md follows chronological format with `YYYY-MM-DD` dates
- Commit messages use pattern: `<type>(<optional scope>): <description>`
- When adding images, update `.github/dependabot.yml` for automatic base image updates
- when testing a docker image we must start rancher-desktop manually. Before running a command using docker, make sure it's running using "docker ps"
