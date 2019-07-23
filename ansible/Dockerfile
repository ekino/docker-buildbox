FROM python:2.7-alpine3.8

ARG VERSION
ARG CI_HELPER_VERSION

WORKDIR /root
RUN echo "Install Ansible with deps" && \
    apk add --update -q --no-cache bash build-base curl git libffi-dev make openssh-client rsync tzdata openssl-dev && \
    pip install ansible==${VERSION} && \
    echo "Done install Ansible with deps" && \
    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \
    rm -rf /var/cache/apk/*
