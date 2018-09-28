FROM alpine:3.8

ARG CI_HELPER_VERSION
ARG PYTHON_VERSION
ARG VERSION

WORKDIR /root
RUN echo "Install Ansible with deps" && \
    apk --update --no-cache add bash ca-certificates curl git openssh-client python=${PYTHON_VERSION} py-pip ansible=${VERSION} && \
    echo "Done install Ansible with deps" &&\
    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper"
