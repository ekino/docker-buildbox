#!/bin/sh

set -ex

if [ "${TARGETARCH}" = "arm64" ]; then
    INFRACOST_ARCH="darwin-arm64"
else
    INFRACOST_ARCH="linux-amd64"
fi
echo "Installing Terraform..." &&
apt-get update -qq \
    && apt-get -y -qq install unzip wget curl git jq bc gcc groff less apt-transport-https ca-certificates gnupg \
    && pip install -U pip \
    && pip install boto3 pipenv \
    && pip install -r requirements.txt \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O terraform.zip \
    && unzip -o terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/bin/ \
    && chmod +x /usr/bin/terraform
    && echo "Done installing Terraform!"

echo "Installing AWS CLIv2" &&
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && echo "Done installing awscliv2!"

echo "Installing gcloud CLI" \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
    && wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O terragrunt \
    && mv terragrunt /usr/bin \
    && chmod +x /usr/bin/terragrunt

echo "Installing infracost" &&
    wget https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz -O infracost.tar.gz \
    && tar xvf infracost.tar.gz \
    && mv infracost-linux-amd64 /usr/bin/infracost
    && wget https://raw.githubusercontent.com/infracost/infracost/v${INFRACOST_VERSION}/scripts/ci/diff.sh -O /opt/diff.sh \
    && chmod +x /opt/diff.sh \
    && echo "Done installing Infracost!"

echo "Finished!"
