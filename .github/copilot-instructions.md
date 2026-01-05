# Docker BuildBox Project - Copilot Instructions

## Project Overview

This is the **Docker BuildBox** project by Ekino - a comprehensive collection of Docker images designed for CI/CD pipelines, particularly GitLab CI. The project provides standardized build environments for various programming languages and cloud tools.

**CRITICAL**: These images are **NOT for production use** - they are specifically designed for CI/CD environments.

## Project Structure

### Core Files

- `image_builder.py` - Main build script for individual images
- `matrix_generator.py` - Generates build matrix for CI/CD (determines which images to build based on file changes)
- `base_config.yml` - Base configuration shared across all images
- `Pipfile` / `Pipfile.lock` - Python dependencies (pipenv-based)
- `src/` - Core Python modules:
  - `config.py` - Configuration loading and management
  - `docker_tools.py` - Docker build/test/push utilities

### Image Structure

Each image has its own directory with:

- `config.yml` - Image-specific configuration
- `Dockerfile` - Single-version images OR
- `{version}/Dockerfile` - Multi-version images (e.g., `java/17/Dockerfile`, `java/21/Dockerfile`)

### Available Images

1. **AWS** (`aws/`) - AWS CLI, Terraform, Kubectl, Helm, Python
2. **Azure** (`azure/`) - Azure CLI, Terraform, Kubectl, Helm, Python
3. **Chrome** (`chrome/`) - Chromium browser + Node.js LTS
4. **Cloudsploit** (`cloudsploit/`) - Aquasecurity's Cloudsploit Scanner
5. **DIND** (`dind/`) - Docker-in-Docker with AWS/Azure CLI
6. **Golang** (`golang/`) - Go + AWS CLI, Gitleaks, GolangCI-Lint, etc.
7. **Java** (`java/`) - Java 17/21 + AWS CLI, Maven, tools
8. **Node** (`node/`) - Node.js + AWS CLI
9. **PHP** (`php/`) - PHP 8.2/8.3/8.4 + Composer, Blackfire, AWS CLI
10. **Platform.sh** (`platformsh/`) - Platform.sh CLI
11. **Python** (`python/`) - Python 3.10-3.14 + pip, pipenv
12. **Scaleway** (`scaleway/`) - Scaleway CLI + Terraform, Kubectl, Helm
13. **SonarQube** (`sonar/`) - SonarQube Scanner

## Configuration Schema

### base_config.yml

```yaml
namespace: ekino # Docker registry namespace
DOCKER_SOCK_PATH: unix://var/run/docker.sock
DOCKER_TIMEOUT: 600
base_platforms: &base_platforms
  - linux/amd64 # Multi-arch support
```

### Image config.yml

```yaml
versions:
  "version_name":
    platforms: # Optional: override base platforms
      - linux/amd64
      - linux/arm64
    test_config:
      volume: "localdir:/container/path" # Optional: mount for tests
      cmd: # Test commands to verify installation
        - "command --version"
        - "another-tool --help"
    build_args: # Optional: Docker build arguments
      - "ARG_NAME=value"
```

## Build and Test System

### Local Development

```bash
# Setup environment
pipenv install
pipenv shell

# Build specific image/version
python image_builder.py build --image IMAGE_NAME --version VERSION [--debug]

# Examples
python image_builder.py build --image java --version 17
python image_builder.py build --image aws --version 1 --debug
```

### CI/CD Workflow (GitHub Actions)

1. **PR**: Only builds images with modified files
2. **Merge to master**: Builds modified images → pushes as `latest-IMAGE` tags
3. **Tag release**: Builds ALL images → pushes with version tags
4. **Nightly**: Builds ALL images → pushes as `nightly-IMAGE` tags

The `matrix_generator.py` determines which images to build by:

- Analyzing git diff against origin/master
- Filtering excluded files (README.md, CHANGELOG.md, etc.)
- Building affected image directories only

### Multi-Architecture Support

- Default: `linux/amd64`
- Many images support: `linux/amd64` + `linux/arm64`
- Dockerfiles use multi-stage builds with architecture-specific stages

## Development Guidelines

### Adding New Images

1. Create directory: `my-image/`
2. Create `my-image/config.yml` with version configuration
3. Create `my-image/Dockerfile` OR `my-image/VERSION/Dockerfile`
4. Add dependabot entry in `.github/dependabot.yml`
5. Test locally: `python image_builder.py build --image my-image --version VERSION`

### Multi-Version Images

- Use subdirectories: `image/1.0/Dockerfile`, `image/2.0/Dockerfile`
- Build context remains the main image directory
- Use `COPY/ADD` paths relative to image root directory

### Commit Message Format

Pattern: `<type>(<optional scope>): <description>`

- `feat`: New feature
- `fix`: Bug fix
- `chore`: Maintenance/routine task

### Managing CHANGELOG.md

The `CHANGELOG.md` file tracks all changes to the Docker images across releases. It follows a chronological format organized by date.

**Format Structure**:

```markdown
## YYYY-MM-DD

- ImageName: description of changes
- AnotherImage: description of changes
```

**Guidelines**:

- **Date Format**: Use `YYYY-MM-DD` format for release dates with dashes underneath
- **Entry Format**: `* ImageName: description of change`
- **Order**: Most recent entries at the top
- **Sorting**: Within each date section, sort entries alphabetically by image name (AWS, Azure, Chrome, etc.)
- **Scope**: Include all significant changes (version updates, new tools, deprecations)
- **Clarity**: Be specific about what changed (e.g., "updating kubectl from 1.25 to 1.27")

**Important Notes**:

- CHANGELOG.md is in the excluded files list - changes to it don't trigger CI builds
- Update the changelog when making changes to any image
- Use past tense for descriptions ("updated", "added", "removed")
- Group related changes under the same date
- Include deprecation notices for images being removed

**Example Entry**:

```markdown
## 2025-05-31

- AWS: updating kubectl from 1.27 to 1.28
- Java: deprecating version 11, adding version 22
- Node: removing node 18, now EoL
```

## Docker Registry

Images are published to:

- **Docker Hub**: `https://hub.docker.com/r/ekino/ci-{IMAGE}/tags`
- **GitHub Packages**: `https://github.com/orgs/ekino/packages/container/package/ci-{IMAGE}`

## Dependencies

- **Python 3.11** (pipenv environment)
- **Key packages**:
  - `python-on-whales` - Docker Python API
  - `click` - CLI framework
  - `pyyaml` - YAML parsing
  - `gitpython` - Git operations
  - `pydantic` - Data validation

## Testing

Each image runs tests defined in `config.yml` → `test_config.cmd` to verify:

- Tool installations
- Version checks
- Basic functionality

Tests run in built containers with optional volume mounts for test data.

## Important Notes

- **Build context** for subdirectory Dockerfiles is always the parent image directory
- **Excluded files** don't trigger builds: .gitignore, CHANGELOG.md, README.md, .github/dependabot.yml
- **Volume mounting** in tests only needs directory name (full path built by script)
- **Multi-arch** builds use architecture-specific build arguments and stages
