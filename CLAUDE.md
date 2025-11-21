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
pipenv run python image_builder.py build --image IMAGE_NAME --version VERSION

# Examples
pipenv run python image_builder.py build --image java --version 17
pipenv run python image_builder.py build --image php --version 8.3
pipenv run python image_builder.py build --image aws --version 1 --debug

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
versions:
  "version_name":
    platforms: *platforms
    build_args: *build_args
    test_config: *test_config
```

### CI/CD Matrix Logic
The build system intelligently determines which images to build:
- **PR**: Only builds images with modified files
- **Master merge**: Builds modified images → pushes as `latest-IMAGE` tags
- **Tag release**: Builds ALL images → pushes with version tags
- **Nightly**: Builds ALL images → pushes as `nightly-IMAGE` tags

Files in `excluded_files` list don't trigger builds: `.gitignore`, `CHANGELOG.md`, `README.md`, `.github/dependabot.yml`, `.github/copilot-instructions.md`

### Available Images
- **aws**: AWS CLI, Terraform, Kubectl, Helm, Python
- **azure**: Azure CLI, Terraform, Kubectl, Helm, Python
- **chrome**: Chromium + Node.js LTS
- **cloudsploit**: Aquasecurity's Cloudsploit Scanner
- **dind**: Docker-in-Docker + AWS/Azure CLI
- **golang**: Go + AWS CLI, Gitleaks, GolangCI-Lint, tools
- **java**: Java 17/21 + AWS CLI, Maven, tools
- **node**: Node.js + AWS CLI
- **php**: PHP 8.1/8.2/8.3/8.4 + Composer, Blackfire, AWS CLI
- **platformsh**: Platform.sh CLI
- **python**: Python 3.10-3.13 + pip, pipenv
- **scaleway**: Scaleway CLI + Terraform, Kubectl, Helm
- **sonar**: SonarQube Scanner

### Multi-Architecture Support
- Default: `linux/amd64`
- Many images support: `linux/amd64` + `linux/arm64`
- Uses Docker Buildx with multi-platform builds

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
