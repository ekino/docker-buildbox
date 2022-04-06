FROM python:3.10.4-slim-buster
LABEL maintainer="Frank Pavageau <fpavageau@ekino.com>"

ARG TASKFILE_VERSION

RUN echo "Installing AWS" && \
    apt-get update -qq && apt-get install -qq -y curl git make rsync zip jq gcc && \
    pip install -U pip && \
    pip install pipenv boto3 awsebcli PyYAML && \
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    echo "Done installing AWS" && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types
