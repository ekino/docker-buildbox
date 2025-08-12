FROM python:3.13.6-slim-bullseye as base
LABEL maintainer="Axel Pavageau <axel.pavageau@ekino.com>"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

FROM base as base-amd64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FROM base as base-arm64
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"

FROM base-$TARGETARCH
WORKDIR /tmp

ADD package.json .
RUN apt-get update -qq && apt-get install -y wget zip curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && export NODE_MAJOR=20 \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && pip install -U pip \
    && pip install pipenv boto3 \
    && apt install -y nodejs git \
    && curl ${AWSCLI_URL} -o "awscliv2.zip" \
    && unzip -q awscliv2.zip\
    && ./aws/install \
    && rm -f awscliv2.zip && rm -rf aws
RUN npm install \
    && ln -s /tmp/node_modules/cloudsploit/index.js /usr/local/bin/cloudsploit
