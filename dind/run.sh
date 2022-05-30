#!/bin/sh

set -ex

if [ "${TARGETARCH}" = "arm64" ]; then
    TRIVY_ARCH="Linux-ARM64"
else
    TRIVY_ARCH="Linux-64bit"
fi

echo "Install AWS & Azure CLIs..." &&
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff &&
    python3 -m ensurepip &&
    pip3 install --no-cache --upgrade pip setuptools wheel &&
    pip -q install awscli boto3 PyYAML &&
    pip install -r requirements.txt &&
    echo "Done installing AWS & Azure CLIs"

echo "Install Taskfile..." &&
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} &&
    echo "Done Install Taskfile"

echo "Install Docker Compose..." &&
    apk del libc6-compat &&
    curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub &&
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O &&
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O &&
    apk add --update -q glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk &&
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk &&
    curl -sSL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose &&
    chmod +x /usr/local/bin/docker-compose &&
    docker-compose --version &&
    echo "Done install Docker Compose"

echo "Install Trivy..." &&
    curl -sSL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz -o trivy_${TRIVY_ARCH}.tar.gz &&
    tar -zxf trivy_${TRIVY_ARCH}.tar.gz -C /usr/bin/ &&
    echo "Done install Trivy"

echo "Adding an up to date mime-types definition file..." &&
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

echo "Cleaning files..." &&
    rm -rf /tmp/* /var/cache/apk/*

echo "Done!"
