FROM eclipse-temurin:25_36-jdk-noble AS base

LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

FROM base AS base-amd64
ARG AWSCLI_ARCH="linux-x86_64"

FROM base AS base-arm64
ARG AWSCLI_ARCH="linux-aarch64"

FROM base-${TARGETARCH}

# Updating packages using sources
RUN cat /etc/apt/sources.list && \
    apt-get -qq clean -qq && apt-get -qq update && \
    # Install base
    apt-get -qq -y install curl git openssh-client jq unzip graphviz postgresql-client && \
    # Installing AWS CLIv2
    curl https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip -o awscliv2.zip && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && \
    rm -rf aws && \
    # Cleaning files!
    rm -rf /tmp/* && \
    apt-get -y remove --purge patch xauth && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB
