#!/bin/sh

set -ex

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
    && curl $AWSCLI_URL -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && echo "Done installing awscliv2!"

echo "Installing gcloud CLI" \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
    && wget $TERRAGRUNT_URL -O terragrunt \
    && mv terragrunt /usr/bin \
    && chmod +x /usr/bin/terragrunt

echo "Installing infracost" &&
    wget $INFRACOST_URL -O infracost.tar.gz \
    && tar xvf infracost.tar.gz \
    && mv infracost-linux-amd64 /usr/bin/infracost
    && wget https://raw.githubusercontent.com/infracost/infracost/v${INFRACOST_VERSION}/scripts/ci/diff.sh -O /opt/diff.sh \
    && chmod +x /opt/diff.sh \
    && echo "Done installing Infracost!"

echo "Finished!"
