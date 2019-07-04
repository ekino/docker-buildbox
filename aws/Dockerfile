FROM alpine:3.10
LABEL maintainer="Frank Pavageau <fpavageau@ekino.com>"

ARG CI_HELPER_VERSION
ARG PIPENV_VERSION
ARG PIP_VERSION
ARG PY_YAML_VERSION
ENV PYTHON_PIP_VERSION ${PIP_VERSION}

WORKDIR /root

RUN echo "Install AWS" && \
    apk add -q --no-cache bash ca-certificates curl git jq make openssh-client python3 py3-pip rsync zip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip install pip==${PYTHON_PIP_VERSION} && \
    pip install pipenv==${PIPENV_VERSION} awscli boto3 awsebcli PyYAML==${PY_YAML_VERSION} && \
    echo "Done install AWS" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types
