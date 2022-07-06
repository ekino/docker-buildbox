#!/bin/sh

set -ex

echo "Starting...\n"

echo "Installing packages..."
apt-get update -q
apt-get -qq -y install rsync zip
echo "Successfully installed packages\n"

echo "Installing AWS CLI..."
apt-get -qq -y install groff-base python3-pip  && \
python3 -m ensurepip && \
pip3 install --no-cache --upgrade pip setuptools wheel && \
pip install -q -U awscli && \
echo "Successfully installed AWS CLI\n"

echo "Adding an up to date mime-types definition file"
curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

echo "Installing gitleaks..."
if [ "${TARGETARCH}" = "arm64" ]; then
    wget -q https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks-linux-arm
    mv gitleaks-linux-arm /usr/local/bin/gitleaks && chmod +x /usr/local/bin/gitleaks
else
    wget -q https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks-linux-amd64
    mv gitleaks-linux-amd64 /usr/local/bin/gitleaks && chmod +x /usr/local/bin/gitleaks
fi
echo "Successfully installed gitleaks\n"

echo "Installing golangci-lint..."
wget -q https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-linux-${TARGETARCH}.tar.gz
tar -xzf golangci-lint-${GOLANGCILINT_VERSION}-linux-${TARGETARCH}.tar.gz
mv golangci-lint-${GOLANGCILINT_VERSION}-linux-${TARGETARCH}/golangci-lint /usr/local/bin
rm -rf golangci-lint*
echo "Successfully installed golangci-lint\n"

echo "Installing go-mod-upgrade..."
if [ "${TARGETARCH}" = "arm64" ]; then
    wget -q https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_VERSION}_Linux_arm64.tar.gz
    tar -xzf go-mod-upgrade_${GOMODUPGRADE_VERSION}_Linux_arm64.tar.gz -C /usr/local/bin && rm go-mod-upgrade*
else
    wget -q https://github.com/oligot/go-mod-upgrade/releases/download/v${GOMODUPGRADE_VERSION}/go-mod-upgrade_${GOMODUPGRADE_VERSION}_Linux_x86_64.tar.gz
    tar -xzf go-mod-upgrade_${GOMODUPGRADE_VERSION}_Linux_x86_64.tar.gz -C /usr/local/bin && rm go-mod-upgrade*
fi
echo "Successfully installed go-mod-upgrade\n"

echo "Installing go-swagger..."
wget -q https://github.com/go-swagger/go-swagger/releases/download/v${GOSWAGGER_VERSION}/swagger_linux_${TARGETARCH}
mv swagger_linux_${TARGETARCH} /usr/local/bin/swagger && chmod +x /usr/local/bin/swagger
echo "Successfully installed go-swagger\n"

echo "Installing migrate..."
wget -q https://github.com/golang-migrate/migrate/releases/download/v${MIGRATE_VERSION}/migrate.linux-${TARGETARCH}.tar.gz
tar -xzf migrate.linux-${TARGETARCH}.tar.gz -C /usr/local/bin && mv /usr/local/bin/migrate.linux-${TARGETARCH} /usr/local/bin/migrate
rm migrate.linux-${TARGETARCH}.tar.gz
echo "Successfully installed migrate\n"

echo "Installing mockgen..."
wget -q https://github.com/golang/mock/releases/download/v${MOCKGEN_VERSION}/mock_${MOCKGEN_VERSION}_linux_${TARGETARCH}.tar.gz
tar -xzf mock_${MOCKGEN_VERSION}_linux_${TARGETARCH}.tar.gz
mv mock_${MOCKGEN_VERSION}_linux_${TARGETARCH}/mockgen /usr/local/bin
rm -rf mock*
echo "Successfully installed mockgen\n"

echo "Installing modd..."
if [ "${TARGETARCH}" = "arm64" ]; then
    wget -q https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linuxARM.tgz
    tar -xzf modd-${MODD_VERSION}-linuxARM.tgz && mv modd-${MODD_VERSION}-linuxARM/modd /usr/local/bin
    rm -rf modd-${MODD_VERSION}-linuxARM*
else
    wget -q https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz
    tar -xzf modd-${MODD_VERSION}-linux64.tgz && mv modd-${MODD_VERSION}-linux64/modd /usr/local/bin
    rm -rf modd-${MODD_VERSION}-linux64*
fi
echo "Successfully installed modd\n"

echo "Installing testfixtures..."
wget -q https://github.com/go-testfixtures/testfixtures/releases/download/v${TESTFIXTURES_VERSION}/testfixtures_linux_amd64.tar.gz
tar -xzf testfixtures_linux_amd64.tar.gz -C /usr/local/bin
rm testfixtures_linux_amd64.tar.gz
echo "Successfully installed testfixtures\n"

go get golang.org/x/tools/cmd/goimports github.com/shuLhan/go-bindata/... github.com/boumenot/gocover-cobertura

echo "Done!";
