#!/bin/sh

echo "Install system dependencies for python and pip"
apt-get update -y
apt-get install curl unzip groff less -y
pip install -U pip
echo "Done base install!"

echo "Installing AWS CLIv2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
awscliv2.zip
rm -rf aws
echo "Done installing awscliv2!"


echo "Install basics Python tools"
pip install pipenv boto3
apt-get -qq -y autoremove
apt-get -qq clean && apt-get -qq purge
rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old
echo "Done!"
