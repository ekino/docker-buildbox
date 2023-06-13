FROM python:3.11.4-slim-bullseye as base
LABEL maintainer="opensource@ekino.com"

ARG PLATFORM_VERSION

FROM base as base-amd64
ARG PLATFORM_URL="https://github.com/platformsh/cli/releases/download/${PLATFORM_VERSION}/platformsh-cli_${PLATFORM_VERSION}_linux_amd64.deb"

FROM base as base-arm64
ARG PLATFORM_URL="https://github.com/platformsh/cli/releases/download/${PLATFORM_VERSION}/platformsh-cli_${PLATFORM_VERSION}_linux_arm64.deb"

FROM base-$TARGETARCH
RUN apt-get update -qq && apt-get install -y curl \
    && curl -sSL $PLATFORM_URL -o /tmp/platform.deb \
    && apt install -y /tmp/platform.deb
