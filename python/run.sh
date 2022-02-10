#!/bin/sh

set -ex

echo "Install system dependencies for python and pip"
pip install -U pip
echo "Done base install!"

echo "Install basics Python tools"
pip install pipenv awscli boto3
apt-get -qq -y autoremove
apt-get -qq clean && apt-get -qq purge
rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old
echo "Done!"
