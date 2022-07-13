#!/bin/sh

set -ex

echo "Starting...\n"

echo "Installing AWS CLI..." &&
    apt-get update -qq && apt-get install -qq -y curl groff-base python3-pip python3-venv rsync zip &&
    curl $AWSCLI_URL -o "awscliv2.zip" &&
    unzip -q awscliv2.zip &&
    aws/install &&
    echo "Successfully installed AWS CLI\n"

echo "Adding an up to date mime-types definition file" &&
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.typesecho "Installing gitleaks..." &&
    wget -q https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks-${GITLEAKS_ARCH} &&
    mv gitleaks-${GITLEAKS_ARCH} /usr/local/bin/gitleaks && chmod +x /usr/local/bin/gitleaks &&
    echo "Successfully installed gitleaks\n"echo "Installing golangci-lint..." &&
    wget -q https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-linux-${TARGETARCH}.tar.gz &&
    tar -xzf golangci-lint-${GOLANGCILINT_VERSION}-linux-${TARGETARCH}.tar.gz &&
    mv golangci-lint-${GOLANGCILINT_VERSION}-linux-${TARGETARCH}/golangci-lint /usr/local/bin &&
    rm -rf golangci-lint* &&
    echo "Successfully installed golangci-lint\n"echo "Installing go-mod-upgrade..." &&
    wget -q https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_VERSION}_${GOMODUPGRADE_ARCH}.tar.gz &&
    tar -xzf go-mod-upgrade_${GOMODUPGRADE_VERSION}_${GOMODUPGRADE_ARCH}.tar.gz -C /usr/local/bin && rm go-mod-upgrade* &&
    echo "Successfully installed go-mod-upgrade\n"echo "Installing go-swagger..." &&
    wget -q https://github.com/go-swagger/go-swagger/releases/download/v${GOSWAGGER_VERSION}/swagger_linux_${TARGETARCH} &&
    mv swagger_linux_${TARGETARCH} /usr/local/bin/swagger && chmod +x /usr/local/bin/swagger &&
    echo "Successfully installed go-swagger\n"echo "Installing migrate..." &&
    wget -q https://github.com/golang-migrate/migrate/releases/download/v${MIGRATE_VERSION}/migrate.linux-${TARGETARCH}.tar.gz &&
    tar -xzf migrate.linux-${TARGETARCH}.tar.gz -C /usr/local/bin && mv /usr/local/bin/migrate.linux-${TARGETARCH} /usr/local/bin/migrate &&
    rm migrate.linux-${TARGETARCH}.tar.gz &&
    echo "Successfully installed migrate\n"echo "Installing mockgen..." &&
    wget -q https://github.com/golang/mock/releases/download/v${MOCKGEN_VERSION}/mock_${MOCKGEN_VERSION}_linux_${TARGETARCH}.tar.gz &&
    tar -xzf mock_${MOCKGEN_VERSION}_linux_${TARGETARCH}.tar.gz &&
    mv mock_${MOCKGEN_VERSION}_linux_${TARGETARCH}/mockgen /usr/local/bin &&
    rm -rf mock* &&
    echo "Successfully installed mockgen\n"echo "Installing modd..." &&
    wget -q $MODD_URL &&
    tar -xzf modd-${MODD_VERSION}-${MOOD_ARCH}.tgz && mv modd-${MODD_VERSION}-linuxARM/modd /usr/local/bin &&
    rm -rf modd-${MODD_VERSION}-${MOOD_ARCH}* &&
    echo "Successfully installed modd\n"echo "Installing testfixtures..." &&
    wget -q $TESTFIXTURES_URL &&
    tar -xzf testfixtures_${TESTFIXTURES_ARCH}.tar.gz -C /usr/local/bin &&
    rm testfixtures_${TESTFIXTURES_ARCH}.tar.gz &&
    echo "Successfully installed testfixtures\n"go get golang.org/x/tools/cmd/goimports github.com/shuLhan/go-bindata/... github.com/boumenot/gocover-cobertura

echo "Done!"
