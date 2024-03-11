FROM golang:1.22.1 as base
LABEL maintainer="opensource@ekino.com"
ARG GITLEAKS_VERSION
ARG GOLANGCILINT_VERSION
ARG GOMODUPGRADE_VERSION
ARG GOSWAGGER_VERSION
ARG MIGRATE_VERSION
ARG MOCKGEN_VERSION
ARG MODD_VERSION

FROM base as base-amd64
ARG AWSCLI_ARCH="linux-x86_64"
ARG GITLEAKS_ARCH="linux_x64"
ARG GOLANGCILINT_ARCH="linux-amd64"
ARG GOMODUPGRADE_ARCH="Linux_x86_64"
ARG GOSWAGGER_ARCH="linux_amd64"
ARG GOMIGRATE_ARCH="linux-amd64"
ARG MOCKGEN_ARCH="linux_amd64"
ARG MODD_ARCH="linux64"

FROM base as base-arm64
ARG AWSCLI_ARCH="linux-aarch64"
ARG GITLEAKS_ARCH="linux_arm64"
ARG GOLANGCILINT_ARCH="linux-arm64"
ARG GOMODUPGRADE_ARCH="Linux_arm64"
ARG GOSWAGGER_ARCH="linux_arm64"
ARG GOMIGRATE_ARCH="linux-arm64"
ARG MOCKGEN_ARCH="linux_arm64"
ARG MODD_ARCH="linuxARM"

FROM base-$TARGETARCH

# Install packages
RUN apt-get update -q && \
    apt-get -qq -y install rsync zip curl unzip wget && \
    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && \
    rm -rf aws && \
    # Add an up to date mime-types definition file
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    # Install gitleaks
    wget -q https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${GITLEAKS_ARCH}.tar.gz && \
    tar -xzf gitleaks_${GITLEAKS_VERSION}_${GITLEAKS_ARCH}.tar.gz && \
    mv gitleaks /usr/local/bin && \
    # Install golangci-lint
    wget -q https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}.tar.gz && \
    tar -xzf golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}.tar.gz && \
    mv golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}/golangci-lint /usr/local/bin && \
    rm -rf golangci-lint* && \
    # Install go-mod-upgrade
    wget -q https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_VERSION}_${GOMODUPGRADE_ARCH}.tar.gz && \
    tar -xzf go-mod-upgrade_${GOMODUPGRADE_VERSION}_${GOMODUPGRADE_ARCH}.tar.gz -C /usr/local/bin && rm go-mod-upgrade* && \
    # Install go-swagger
    wget -q https://github.com/go-swagger/go-swagger/releases/download/v${GOSWAGGER_VERSION}/swagger_${GOSWAGGER_ARCH} && \
    mv swagger_${GOSWAGGER_ARCH} /usr/local/bin/swagger && chmod +x /usr/local/bin/swagger && \
    # Install migrate
    wget -q https://github.com/golang-migrate/migrate/releases/download/v${MIGRATE_VERSION}/migrate.${GOMIGRATE_ARCH}.tar.gz && \
    tar -xzf migrate.${GOMIGRATE_ARCH}.tar.gz -C /usr/local/bin && \
    rm migrate.${GOMIGRATE_ARCH}.tar.gz && \
    # Install mockgen
    wget -q https://github.com/golang/mock/releases/download/v${MOCKGEN_VERSION}/mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}.tar.gz && \
    tar -xzf mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}.tar.gz && \
    mv mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}/mockgen /usr/local/bin && \
    rm -rf mock* && \
    # Install modd
    wget -q https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-${MODD_ARCH}.tgz && \
    tar -xzf modd-${MODD_VERSION}-${MODD_ARCH}.tgz && mv modd-${MODD_VERSION}-${MODD_ARCH}/modd /usr/local/bin && \
    rm -rf modd-${MODD_VERSION}-${MODD_ARCH}* && \
    # Install go tools
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install github.com/boumenot/gocover-cobertura@latest
