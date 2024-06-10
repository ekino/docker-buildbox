FROM python:3.12.4-slim-bullseye AS base

ARG TARGETARCH
ARG POETRY_VERSION
ARG POETRY_HOME

FROM base AS base-amd64
ARG ARCH="x86_64"

FROM base AS base-arm64
ARG ARCH="aarch64"

FROM base-$TARGETARCH

# Install system dependencies for python and pip
RUN apt-get update -y && \
    apt-get install curl unzip groff less -y  && \
    pip install -U pip  && \

    # Installing AWS CLIv2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-{$ARCH}.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf aws && \
    rm -f awscliv2.zip && \

    # Install basics Python tools
    pip install pipenv boto3 && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \

    # Install Poetry
    curl -sSL https://install.python-poetry.org | python3 - --version $POETRY_VERSION
