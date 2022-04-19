FROM ruby:2.6.10-alpine
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

ARG CI_HELPER_VERSION

RUN echo "Starting ..." && \
    apk add --update curl git make openssh-client rsync tzdata && \
    echo "Done base install!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \

    echo "Done!"
