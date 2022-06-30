FROM python:3.10.5-slim-buster as base
ARG ANSIBLE_VERSION

FROM base as base-amd64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FROM base as base-arm64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"

FROM base-$TARGETARCH
ADD ${ANSIBLE_VERSION}/requirements.txt .
ADD run.sh .
RUN sh run.sh

