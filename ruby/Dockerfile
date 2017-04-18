FROM ruby:2.4.1-alpine
MAINTAINER Rémi Marseille <marseille@ekino.com>

ARG CI_HELPER_VERSION

RUN echo "Starting ..." && \
    apk add --update curl git make openssh-client rsync tzdata && \
    echo "Done base install!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk -O && \
    apk add -q glibc-2.23-r3.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-2.23-r3.apk && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \

    echo "Done!"
