FROM python:3.11.0-slim-buster as base

ARG ANSIBLE_VERSION

FROM base as base-amd64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FROM base as base-arm64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"

FROM base-$TARGETARCH
ADD ${ANSIBLE_VERSION}/requirements.txt .
RUN apt update && apt install -y curl zip && \
    pip install -U pip pipenv boto3 && \
    pip install -r requirements.txt &&  \
    rm -rf /var/cache/apk/* && \
    curl "${AWSCLI_URL}" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && rm -rf aws
