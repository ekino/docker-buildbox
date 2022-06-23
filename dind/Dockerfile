FROM docker:20.10.17-dind as base
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

ARG GLIBC_VERSION
ARG PIP_VERSION
ARG TASKFILE_VERSION
ARG TRIVY_VERSION
ENV PYTHON_PIP_VERSION ${PIP_VERSION}

FROM base as base-amd64
ARG TRIVY_ARCH "Linux-64bit"
ARG AWSCLI_ARCH "x86_64"

FROM base as base-arm64
ARG TRIVY_ARCH "Linux-ARM64"
ARG AWSCLI_ARCH "aarch64"

FROM base-$TARGETARCH
ARG AWSCLI_URL "https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"
ADD requirements.txt .
ADD run.sh .
RUN  sh run.sh

