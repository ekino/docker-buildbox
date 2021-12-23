FROM debian:11.4-slim
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

COPY run.sh .
RUN ./run.sh
