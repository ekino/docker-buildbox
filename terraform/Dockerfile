FROM python:3.10.5-slim-buster as base
LABEL maintainer="opensource@ekino.com"
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
ARG INFRACOST_VERSION
ARG TARGETARCH
COPY requirements.txt .

FROM base as base-amd64
ARG AWSCLI_ARCH="x86_64"
ARG INFRACOST_ARCH="linux-amd64"
ARG TERRAGRUNT_ARCH="linux_amd64"

FROM base as base-arm64
ARG AWSCLI_ARCH="aarch64"
ARG INFRACOST_ARCH="linux-arm64"
ARG TERRAGRUNT_ARCH="linux_arm64"

FROM base-${TARGETARCH}
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"
ARG INFRACOST_URL="https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-${INFRACOST_ARCH}.tar.gz"
ARG TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${TERRAGRUNT_ARCH}"
COPY run.sh .
RUN sh run.sh
