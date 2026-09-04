# Base image used for all architectures.
# We start from the official Python slim image, then add metadata for the project.
FROM python:3.12.13-slim-trixie AS base
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
RUN apt-get update -qq && apt-get install -qq -y --no-install-recommends \
        curl unzip ca-certificates git \
        build-essential pkg-config libzstd-dev zlib1g-dev \
    && pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir -r requirements.txt \
    && curl "${AWSCLI_URL}" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -f awscliv2.zip && rm -rf aws \
    && apt-get purge -y --auto-remove build-essential pkg-config libzstd-dev zlib1g-dev \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old

