#!/bin/sh

set -ex

echo "Starting ..."
apt-get update -qq
apt-get install -qq -y curl unzip groff less

echo "Install system dependencies for node"
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
echo "Done base install!"

echo "Installing AWS CLIv2"
curl $AWSCLI_URL -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
echo "Done installing awscliv2!"

echo "Install basics Python tools"
pip install -U pip
pip install pipenv boto3
echo "Done basic python tools install"

echo "Cleaning files!"
echo "Done!"
