#!/bin/sh

echo "Starting ..."
apt-get update -qq
apt-get install -qq -y curl

echo "Installing system dependencies for node"
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
echo "Done base install!"

echo "Installing basics Python tools"
pip install -U pip
pip install pipenv boto3
echo "Done basic python tools install"

echo "Installing AWS tools"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
unzip awscliv2.zip && \
./aws/install && \
echo "Done installing AWS tools" && \

echo "Cleaning files!"
echo "Done!"
