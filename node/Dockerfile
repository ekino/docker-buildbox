FROM debian:11.4-slim as base
LABEL maintainer="opensource@ekino.com"
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    NVM_DIR=/root/.nvm \
    PATH=/root/.nvm/versions/node/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ARG NODE_VERSION
ARG NPM_VERSION
ARG NVM_VERSION
ARG MODD_VERSION
ARG TASKFILE_VERSION
ARG TARGETARCH

FROM base as base-amd64
ARG AWSCLI_ARCH="x86_64"

FROM base as base-arm64
ARG AWSCLI_ARCH="aarch64"

FROM base-${TARGETARCH}
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"
COPY run.sh .
RUN ./run.sh
