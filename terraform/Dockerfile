FROM python:3.11.1-slim-buster

LABEL maintainer="opensource@ekino.com"

ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
ARG INFRACOST_VERSION

ADD requirements.txt .

RUN apt-get update -qq \
    && apt-get -y -qq install unzip wget curl git jq bc gcc groff less apt-transport-https ca-certificates gnupg \
    && pip install -U pip \
    && pip install boto3 pipenv \
    && pip install -r requirements.txt \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O terraform.zip \
    && unzip -o terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/bin/ \
    && chmod +x /usr/bin/terraform

RUN echo "Installing AWS CLIv2" \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -f awscliv2.zip && rm -rf aws \
    && echo "Done installing awscliv2!"

RUN echo "Installing gcloud CLI" \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O terragrunt \
    && mv terragrunt /usr/bin \
    && chmod +x /usr/bin/terragrunt

RUN wget https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz -O infracost.tar.gz \
    && tar xvf infracost.tar.gz \
    && mv infracost-linux-amd64 /usr/bin/infracost

RUN wget https://raw.githubusercontent.com/infracost/infracost/v${INFRACOST_VERSION}/scripts/ci/diff.sh -O /opt/diff.sh \
    && chmod +x /opt/diff.sh
