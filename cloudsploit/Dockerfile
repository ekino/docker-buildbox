FROM python:3.11.4-slim-bullseye as base
LABEL maintainer="Axel Pavageau <axel.pavageau@ekino.com>"

FROM base as base-amd64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FROM base as base-arm64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"

FROM base-$TARGETARCH
WORKDIR /tmp

ADD package.json .
RUN apt-get update -qq && apt-get install -y wget zip curl \
    && pip install -U pip \
    && pip install pipenv boto3 \
    && apt install -y npm git \
    && curl ${AWSCLI_URL} -o "awscliv2.zip" \
    && unzip awscliv2.zip\
    && ./aws/install
RUN npm install \
    && ln -s /tmp/node_modules/cloudsploit/index.js /usr/local/bin/cloudsploit
