FROM python:3.10.5-slim-buster

LABEL maintainer="opensource@ekino.com"

ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
ARG INFRACOST_VERSION
ARG TARGETARCH

COPY requirements.txt .

COPY run.sh .
RUN sh run.sh
