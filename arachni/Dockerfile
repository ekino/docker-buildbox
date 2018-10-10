FROM ruby:2.3.3-alpine
LABEL maintainer="Rémi Marseille <remi.marseille@ekino.com>"

ARG ARACHNI_VERSION
ARG CI_HELPER_VERSION

RUN apk add --update alpine-sdk curl make && \
    gem install arachni -v $ARACHNI_VERSION && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Cleaning files!" && \
    apk del --purge alpine-sdk && \
    rm -rf /tmp/* /var/cache/apk/* && \

    echo "Done!"

