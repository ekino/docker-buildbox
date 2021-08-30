#!/bin/sh

echo "Starting ..."
apt-get update -qq
apt-get install -qq -y curl

echo "Install system dependencies for node"
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
echo "Done base install!"

echo "Install basics Python tools"
pip install -U pip
pip install pipenv awscli boto3
echo "Done basic python tools install"

echo "Cleaning files!"
echo "Done!"
