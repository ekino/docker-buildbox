#!/bin/sh

set -ex

echo "Installing awscli..." && apt update && apt install -y curl zip &&
    pip install -U pip pipenv boto3 &&
    pip install -r requirements.txt &&
    rm -rf /var/cache/apk/* &&
    curl "${AWSCLI_URL}" -o "awscliv2.zip" &&
    unzip awscliv2.zip &&
    ./aws/install
