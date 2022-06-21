#!/bin/sh

set -ex

echo "Defining parameters..." &&
    if [ "${TARGETARCH}" = "arm64" ]; then
        AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
    else
        AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    fi

echo "Installing awscli..." && apt update && apt install -y curl zip &&
    pip install -U pip pipenv boto3 &&
    pip install -r requirements.txt &&
    rm -rf /var/cache/apk/* &&
    curl "${AWSCLI_URL}" -o "awscliv2.zip" &&
    unzip awscliv2.zip &&
    ./aws/install
