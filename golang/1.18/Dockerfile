FROM golang:1.18.3 as base
LABEL maintainer="opensource@ekino.com"
ARG GITLEAKS_VERSION
ARG GOLANGCILINT_VERSION
ARG GOMODUPGRADE_VERSION
ARG GOSWAGGER_VERSION
ARG MIGRATE_VERSION
ARG MOCKGEN_VERSION
ARG MODD_VERSION
ARG TESTFIXTURES_VERSION
ARG TARGETARCH

FROM base as base-amd64
ARG GITLEAKS_ARCH "linux-amd64 "
ARG GOMODUPGRADE_ARCH "Linux_x86_64" 
ARG MODD_ARCH "linux64"
ARG TESTFIXTURES_ARCH "linux_amd64"
ARG AWSCLI_ARCH="x86_64"

FROM base as base-arm64
ARG GITLEAKS_ARCH "linux-arm"
ARG GOMODUPGRADE_ARCH "Linux_arm64"
ARG MODD_ARCH "linuxARM"
ARG TESTFIXTURES_ARCH "linux_amd64"
ARG AWSCLI_ARCH="aarch64"

FROM base-$TARGETARCH
ARG GITLEAKS_URL "https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks-${GITLEAKS_ARCH}"
ARG GOMODUPGRADE_URL "https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_VERSION}_Linux_x86_64.tar.gz"
ARG MODD_URL "https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-${MODD_ARCH}.tgz"
ARG TESTFIXTURES_URL "https://github.com/go-testfixtures/testfixtures/releases/download/v${TESTFIXTURES_VERSION}/testfixtures_${TESTFIXTURES_ARCH}.tar.gz" 
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"
ADD run.sh .
RUN sh run.sh

