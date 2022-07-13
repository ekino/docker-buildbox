#!/bin/sh

set -ex

echo "Install AWS & Azure CLIs..." &&
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff &&
    pip3 install --no-cache --upgrade pip setuptools wheel &&
    pip -q install awscliv2 awscli boto3 PyYAML &&
    pip install -r requirements.txt &&
    echo "Done installing AWS & Azure CLIs"

echo "Install Taskfile..." &&
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} &&
    echo "Done Install Taskfile"

echo "Install Trivy..." &&
    curl -sSL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz -o trivy_${TRIVY_ARCH}.tar.gz &&
    tar -zxf trivy_${TRIVY_ARCH}.tar.gz &&
    mv trivy /usr/bin/trivy &&
    echo "Done install Trivy"

echo "Install Docker Compose..." &&
    apk add --update docker-compose &&
    docker-compose --version &&
    echo "Done install Docker Compose"

echo "Adding an up to date mime-types definition file..." &&
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

echo "Cleaning files..." &&
    rm -rf /tmp/* /var/cache/apk/*

echo "Done!"
