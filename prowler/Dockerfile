# check=skip=InvalidDefaultArgInFrom
# UV_VERSION is resolved from the GitHub API by image_builder.py. It has to be a
# global ARG, declared before the first FROM: FROM can expand one, but
# `COPY --from` cannot expand variables at all, so uv arrives through a named
# stage below. It deliberately has no default, so that a bare `docker build`
# fails instead of silently pulling an unpinned uv - which is the lint the
# check directive above skips.
ARG UV_VERSION

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

# Base image used for all architectures.
# We start from the official Python slim image, then add metadata for the project.
FROM python:3.13.15-slim-trixie AS base
LABEL maintainer="Axel Pavageau <axel.pavageau@ekino.com>"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

# Architecture-specific stages: AWS CLI download URL differs between amd64 and arm64.
FROM base AS base-amd64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FROM base AS base-arm64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"

# Select the correct architecture stage dynamically using Docker buildx TARGETARCH.
FROM base-$TARGETARCH

ADD requirements.txt .
# uv installs the Python packages below, and stays in the image as a tool. The
# distroless binaries are statically linked, so they are portable.
COPY --from=uv /uv /uvx /usr/local/bin/

RUN apt-get update -qq && apt-get install -qq -y --no-install-recommends \
        curl unzip ca-certificates git \
        build-essential \
    && uv pip install --system --no-cache -r requirements.txt \
    && curl -f --retry 3 --retry-delay 2 "${AWSCLI_URL}" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -f awscliv2.zip && rm -rf aws \
    && apt-get purge -y --auto-remove build-essential \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old

