FROM python:3.10.1-slim-buster
LABEL maintainer="Frank Pavageau <fpavageau@ekino.com>"

ARG TASKFILE_VERSION

RUN echo "Install AWS" && \
    apt-get update -qq && apt-get install -qq -y curl git make rsync zip jq gcc && \
    pip install -U pip && \
    pip install pipenv awscli boto3 awsebcli PyYAML && \
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} && \
    echo "Done install AWS" && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types
