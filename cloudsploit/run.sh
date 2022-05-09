#!/bin/sh

set -ex

apt-get update -qq && apt-get install -y wget zip curl &&
    pip install -U pip &&
    pip install pipenv boto3 &&
    apt install -y npm git

curl "https://awscli.amazonaws.com/awscli-exe-linux-${TARGETARCH}.zip" -o "awscliv2.zip" &&
    unzip awscliv2.zip &&
    ./aws/install

npm install &&
    ln -s /node_modules/cloudsploit/index.js /usr/local/bin/cloudsploit
