#!/bin/sh

set -ex

echo "Installing Terraform..."
apt-get update -qq \
    && apt-get -y -qq install unzip wget git jq bc gcc \
    && pip install -U pip \
    && pip install awscli boto3 pipenv \
    && pip install -r requirements.txt \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip -O terraform.zip \
    && unzip -o terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/bin/ \
    && chmod +x /usr/bin/terraform \
    && echo "Done installing Terraform!"

echo "Installing Terragrunt..."
wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH} -O terragrunt \
    && mv terragrunt /usr/bin \
    && chmod +x /usr/bin/terragrunt \
    && echo "Done installing Terragrunt!"

echo "Installing Infracost..."
if [ "${TARGETARCH}" = "arm64" ]; then
    INFRACOST_ARCH="darwin-arm64"
else
    INFRACOST_ARCH="linux-amd64"
fi
wget https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-${INFRACOST_ARCH}.tar.gz -O infracost.tar.gz \
    && tar xvf infracost.tar.gz \
    && mv infracost-linux-amd64 /usr/bin/infracost \
    && wget https://raw.githubusercontent.com/infracost/infracost/v${INFRACOST_VERSION}/scripts/ci/diff.sh -O /opt/diff.sh \
    && chmod +x /opt/diff.sh \
    && echo "Done installing Infracost!"

echo "Finished!"
