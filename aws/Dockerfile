FROM python:3.10.5-slim-buster as base
LABEL maintainer="Frank Pavageau <fpavageau@ekino.com>"
ARG TASKFILE_VERSION

FROM base as base-amd64
ARG AWSCLI_ARCH="x86_64"

FROM base as base-arm64
ARG AWSCLI_ARCH="aarch64"

FROM base-$TARGETARCH
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"
COPY run.sh .
RUN sh run.sh

