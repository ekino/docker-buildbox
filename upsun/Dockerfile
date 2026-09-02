FROM python:3.14.7-slim-trixie AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG VERSION

FROM base AS base-amd64
ARG CLI_ARCH="amd64"

FROM base AS base-arm64
ARG CLI_ARCH="arm64"

FROM base-$TARGETARCH
RUN apt-get update -qq && apt-get install -y curl git jq \
    && pip install pipenv \
    && echo "Fetching latest version of Platform.sh and Upsun CLIs..." \
    && CLI_VERSION=$(curl -fsS --retry 3 --retry-delay 2 --retry-all-errors https://api.github.com/repos/platformsh/cli/releases/latest | jq -r '.tag_name // empty') \
    && : "${CLI_VERSION:?could not be resolved from the GitHub API}" \
    && echo "Using CLI version: ${CLI_VERSION}" \
    && curl -fsSL --retry 3 --retry-delay 2 "https://github.com/platformsh/cli/releases/download/${CLI_VERSION}/upsun-cli_${CLI_VERSION}_linux_${CLI_ARCH}.deb" -o /tmp/upsun.deb \
    && curl -fsSL --retry 3 --retry-delay 2 "https://github.com/platformsh/cli/releases/download/${CLI_VERSION}/platformsh-cli_${CLI_VERSION}_linux_${CLI_ARCH}.deb" -o /tmp/platform.deb \
    && apt install -y /tmp/upsun.deb /tmp/platform.deb \
    && rm -f /tmp/upsun.deb /tmp/platform.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
