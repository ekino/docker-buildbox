FROM debian:stretch-slim
LABEL maintainer="Rémi Marseille <remi.marseille@ekino.com>"

ARG ARACHNI_VERSION
ARG ARACHNI_WEB_UI_VERSION
ARG CI_HELPER_VERSION

ENV PATH="${PATH}:/arachni-${ARACHNI_VERSION}-${ARACHNI_WEB_UI_VERSION}/bin"

RUN echo "Starting ..." && \

    echo "Updating packages using sources:" && \
    cat /etc/apt/sources.list && \
    apt-get -qq clean -qq && apt-get -qq update && \

    echo "Install base" && \
    apt-get -qq -y install curl && \
    echo "Done Install base!" && \

    echo "Install Arachni" && \
    curl -sSL https://github.com/Arachni/arachni/releases/download/v${ARACHNI_VERSION}/arachni-${ARACHNI_VERSION}-${ARACHNI_WEB_UI_VERSION}-linux-x86_64.tar.gz | tar zx && \
    echo "Done install Arachni" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \

    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc && \

    echo "Done!"
