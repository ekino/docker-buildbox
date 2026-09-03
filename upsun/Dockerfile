FROM python:3.14.7-slim-trixie AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG VERSION

FROM base AS base-amd64
ARG CLI_ARCH="amd64"

FROM base AS base-arm64
ARG CLI_ARCH="arm64"

FROM base-$TARGETARCH
# Tool versions, resolved from the GitHub API by image_builder.py
ARG CLI_VERSION
RUN apt-get update -qq && apt-get install -y curl git jq \
    && pip install pipenv \
    && : "${CLI_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && echo "Using CLI version: ${CLI_VERSION}" \
    && curl -fsSL --retry 3 --retry-delay 2 "https://github.com/platformsh/cli/releases/download/${CLI_VERSION}/upsun-cli_${CLI_VERSION}_linux_${CLI_ARCH}.deb" -o /tmp/upsun.deb \
    && curl -fsSL --retry 3 --retry-delay 2 "https://github.com/platformsh/cli/releases/download/${CLI_VERSION}/platformsh-cli_${CLI_VERSION}_linux_${CLI_ARCH}.deb" -o /tmp/platform.deb \
    && apt install -y /tmp/upsun.deb /tmp/platform.deb \
    && rm -f /tmp/upsun.deb /tmp/platform.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
