#!/bin/bash

echo "Starting...\n"

echo "Installing packages..."
apt-get update -q
apt-get -qq -y install rsync zip
echo "Successfully installed packages\n"

echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -f awscliv2.zip
rm -rf aws
echo "Successfully installed AWS CLI\n"

echo "Adding an up to date mime-types definition file"
curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

echo "Installing gitleaks..." &&
    wget -q https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${GITLEAKS_ARCH}.tar.gz &&
    tar -xzf gitleaks_${GITLEAKS_VERSION}_${GITLEAKS_ARCH}.tar.gz &&
    mv gitleaks /usr/local/bin &&
    echo "Successfully installed gitleaks\n"

echo "Installing golangci-lint..."
wget -q https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}.tar.gz
tar -xzf golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}.tar.gz
mv golangci-lint-${GOLANGCILINT_VERSION}-${GOLANGCILINT_ARCH}/golangci-lint /usr/local/bin
rm -rf golangci-lint*
echo "Successfully installed golangci-lint\n"

echo "Installing go-mod-upgrade..."
wget -q https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_VERSION}_${GOMODUPGRADE_ARCH}.tar.gz
tar -xzf go-mod-upgrade_${GOMODUPGRADE_VERSION}_${GOMODUPGRADE_ARCH}.tar.gz -C /usr/local/bin && rm go-mod-upgrade*
echo "Successfully installed go-mod-upgrade\n"

echo "Installing go-swagger..."
wget -q https://github.com/go-swagger/go-swagger/releases/download/v${GOSWAGGER_VERSION}/swagger_${GOSWAGGER_ARCH}
mv swagger_${GOSWAGGER_ARCH} /usr/local/bin/swagger && chmod +x /usr/local/bin/swagger
echo "Successfully installed go-swagger\n"

echo "Installing migrate..."
wget -q https://github.com/golang-migrate/migrate/releases/download/v${MIGRATE_VERSION}/migrate.${GOMIGRATE_ARCH}.tar.gz
tar -xzf migrate.${GOMIGRATE_ARCH}.tar.gz -C /usr/local/bin && mv /usr/local/bin/migrate.${GOMIGRATE_ARCH} /usr/local/bin/migrate
rm migrate.${GOMIGRATE_ARCH}.tar.gz
echo "Successfully installed migrate\n"

echo "Installing mockgen..."
wget -q https://github.com/golang/mock/releases/download/v${MOCKGEN_VERSION}/mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}.tar.gz
tar -xzf mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}.tar.gz
mv mock_${MOCKGEN_VERSION}_${MOCKGEN_ARCH}/mockgen /usr/local/bin
rm -rf mock*
echo "Successfully installed mockgen\n"

echo "Installing modd..."
wget -q https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-${MODD_ARCH}.tgz
tar -xzf modd-${MODD_VERSION}-${MODD_ARCH}.tgz && mv modd-${MODD_VERSION}-${MODD_ARCH}/modd /usr/local/bin
rm -rf modd-${MODD_VERSION}-${MODD_ARCH}*
echo "Successfully installed modd\n"

go get golang.org/x/tools/cmd/goimports github.com/shuLhan/go-bindata/... github.com/boumenot/gocover-cobertura

echo "Done!"
