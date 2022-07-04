#!/bin/sh

set -ex

echo "Install system dependencies for python and pip"
apt-get update -y
apt-get install curl unzip groff less -y
pip install -U pip
echo "Done base install!"

echo "Installing AWS CLIv2"
curl $AWSCLI_URL -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
echo "Done installing awscliv2!"


echo "Install basics Python tools"
pip install pipenv boto3
apt-get -qq -y autoremove
apt-get -qq clean && apt-get -qq purge
rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old
echo "Done!"
