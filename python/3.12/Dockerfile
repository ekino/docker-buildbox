# check=skip=InvalidDefaultArgInFrom
# UV_VERSION is resolved from the GitHub API by image_builder.py. It has to be a
# global ARG, declared before the first FROM: FROM can expand one, but
# `COPY --from` cannot expand variables at all, so uv arrives through a named
# stage below. It deliberately has no default, so that a bare `docker build`
# fails instead of silently pulling an unpinned uv - which is the lint the
# check directive above skips.
ARG UV_VERSION

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM python:3.12.14-slim-trixie AS base
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG TARGETARCH
ARG POETRY_HOME

FROM base AS base-amd64
ARG ARCH="x86_64"

FROM base AS base-arm64
ARG ARCH="aarch64"

FROM base-$TARGETARCH

# Install system dependencies for python and pip
# uv installs the Python packages below, and stays in the image as a tool. The
# distroless binaries are statically linked, so they are portable.
COPY --from=uv /uv /uvx /usr/local/bin/

RUN apt-get update -y && \
    apt-get install curl unzip groff less -y  && \
    # Installing AWS CLIv2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-{$ARCH}.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf aws && \
    rm -f awscliv2.zip && \
    # Install basics Python tools
    uv pip install --system --no-cache pipenv boto3 && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    # Install Poetry
    curl -sSL https://install.python-poetry.org | python3 -
