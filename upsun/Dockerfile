# check=skip=InvalidDefaultArgInFrom
# UV_VERSION is resolved from the GitHub API by image_builder.py. It has to be a
# global ARG, declared before the first FROM: FROM can expand one, but
# `COPY --from` cannot expand variables at all, so uv arrives through a named
# stage below. It deliberately has no default, so that a bare `docker build`
# fails instead of silently pulling an unpinned uv - which is the lint the
# check directive above skips.
ARG UV_VERSION

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

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
# uv installs the Python packages below, and stays in the image as a tool. The
# distroless binaries are statically linked, so they are portable.
COPY --from=uv /uv /uvx /usr/local/bin/

RUN apt-get update -qq && apt-get install -y curl git jq \
    && uv pip install --system --no-cache pipenv \
    && : "${CLI_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && echo "Using CLI version: ${CLI_VERSION}" \
    && curl -fsSL --retry 3 --retry-delay 2 "https://github.com/platformsh/cli/releases/download/${CLI_VERSION}/upsun-cli_${CLI_VERSION}_linux_${CLI_ARCH}.deb" -o /tmp/upsun.deb \
    && curl -fsSL --retry 3 --retry-delay 2 "https://github.com/platformsh/cli/releases/download/${CLI_VERSION}/platformsh-cli_${CLI_VERSION}_linux_${CLI_ARCH}.deb" -o /tmp/platform.deb \
    && apt install -y /tmp/upsun.deb /tmp/platform.deb \
    && rm -f /tmp/upsun.deb /tmp/platform.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
