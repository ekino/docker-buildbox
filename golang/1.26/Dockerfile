FROM golang:1.26.7 AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG GITLEAKS_VERSION
ARG GOLANGCILINT_VERSION
ARG GOMODUPGRADE_VERSION
ARG GOSWAGGER_VERSION
ARG MIGRATE_VERSION
ARG MOCKGEN_VERSION

FROM base AS base-amd64
ARG AWSCLI_ARCH="linux-x86_64"
ARG GITLEAKS_ARCH="linux_x64"
ARG GOLANGCILINT_ARCH="linux-amd64"
ARG GOMODUPGRADE_ARCH="linux_amd64"
ARG GOSWAGGER_ARCH="linux_amd64"
ARG GOMIGRATE_ARCH="linux-amd64"
ARG MOCKGEN_ARCH="linux_amd64"

FROM base AS base-arm64
ARG AWSCLI_ARCH="linux-aarch64"
ARG GITLEAKS_ARCH="linux_arm64"
ARG GOLANGCILINT_ARCH="linux-arm64"
ARG GOMODUPGRADE_ARCH="linux_arm64"
ARG GOSWAGGER_ARCH="linux_arm64"
ARG GOMIGRATE_ARCH="linux-arm64"
ARG MOCKGEN_ARCH="linux_arm64"

FROM base-$TARGETARCH

# Install packages
# Tool versions, resolved from the GitHub API by image_builder.py
ARG GITLEAKS_VERSION
ARG GOLANGCILINT_VERSION
ARG GOMODUPGRADE_VERSION
ARG GOSWAGGER_VERSION
ARG MIGRATE_VERSION
ARG MOCKGEN_VERSION
RUN apt-get update -q && \
    apt-get -qq -y install rsync zip curl unzip wget jq && \
    # Install AWS CLI
    curl -f --retry 3 --retry-delay 2 "https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && \
    rm -rf aws && \
    # Add an up to date mime-types definition file
    curl -fsSL --retry 3 --retry-delay 2 https://salsa.debian.org/debian/media-types/raw/master/mime.types -o /etc/mime.types && \
    # Install gitleaks
    : "${GITLEAKS_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    wget -q https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${GITLEAKS_ARCH}.tar.gz && \
    tar -xzf gitleaks_${GITLEAKS_VERSION}_${GITLEAKS_ARCH}.tar.gz && \
    mv gitleaks /usr/local/bin && \
    # Install golangci-lint
    : "${GOLANGCILINT_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    wget -q https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}.tar.gz && \
    tar -xzf golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}.tar.gz && \
    mv golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}/golangci-lint /usr/local/bin && \
    rm -rf golangci-lint* && \
    # Install go-mod-upgrade
    : "${GOMODUPGRADE_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    wget -q https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_ARCH}.tar.gz && \
    tar -xzf go-mod-upgrade_${GOMODUPGRADE_ARCH}.tar.gz -C /usr/local/bin && rm go-mod-upgrade* && \
    # Install go-swagger
    : "${GOSWAGGER_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    wget -q https://github.com/go-swagger/go-swagger/releases/download/v${GOSWAGGER_VERSION}/swagger_${GOSWAGGER_ARCH} && \
    mv swagger_${GOSWAGGER_ARCH} /usr/local/bin/swagger && chmod +x /usr/local/bin/swagger && \
    # Install migrate
    : "${MIGRATE_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    wget -q https://github.com/golang-migrate/migrate/releases/download/v${MIGRATE_VERSION}/migrate.${GOMIGRATE_ARCH}.tar.gz && \
    tar -xzf migrate.${GOMIGRATE_ARCH}.tar.gz -C /usr/local/bin && \
    rm migrate.${GOMIGRATE_ARCH}.tar.gz && \
    # Install mockgen
    : "${MOCKGEN_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    wget -q https://github.com/golang/mock/releases/download/v${MOCKGEN_VERSION}/mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}.tar.gz && \
    tar -xzf mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}.tar.gz && \
    mv mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}/mockgen /usr/local/bin && \
    rm -rf mock* && \
    # Install go tools
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install github.com/boumenot/gocover-cobertura@latest
