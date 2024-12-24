FROM python:3.13.1-slim-bullseye AS base
LABEL maintainer="opensource@ekino.com"

FROM base AS base-amd64
ARG PLATFORM_ARCH="linux_amd64"

FROM base AS base-arm64
ARG PLATFORM_ARCH="linux_arm64"

FROM base-$TARGETARCH
RUN apt-get update -qq && apt-get install -y curl python3-dev gcc ldap-utils libldap2-dev libsasl2-dev git \
    && pip install pipenv \
    && PLATFORM_VERSION=$(curl -s https://api.github.com/repos/platformsh/cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
    && curl -sSL https://github.com/platformsh/cli/releases/download/${PLATFORM_VERSION}/platformsh-cli_${PLATFORM_VERSION}_${PLATFORM_ARCH}.deb -o /tmp/platform.deb \
    && apt install -y /tmp/platform.deb \
    && rm /tmp/platform.deb
