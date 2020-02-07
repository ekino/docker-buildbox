FROM debian:stretch-slim
LABEL maintainer="Rémi Marseille <remi.marseille@ekino.com>"

ARG ARACHNI_VERSION
ARG ARACHNI_WEB_UI_VERSION

ENV PATH="${PATH}:/arachni-${ARACHNI_VERSION}-${ARACHNI_WEB_UI_VERSION}/bin"

RUN echo "Starting ..." && \
    echo "Updating packages using sources:" && \
    apt-get -qq clean -qq && apt-get -qq update && \
    echo "Install base" && \
    apt-get -qq -y install curl && \
    echo "Done Install base!" && \
    echo "Install Arachni" && \
    curl -sSL https://github.com/Arachni/arachni/releases/download/v${ARACHNI_VERSION}/arachni-${ARACHNI_VERSION}-${ARACHNI_WEB_UI_VERSION}-linux-x86_64.tar.gz | tar zx && \
    echo "Done install Arachni" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc && \
    echo "Done!"
