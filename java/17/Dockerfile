FROM eclipse-temurin:17.0.12_7-jdk-jammy as base
LABEL maintainer="opensource@ekino.com"
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

FROM base as base-amd64
ARG AWSCLI_ARCH="linux-x86_64"

FROM base as base-arm64
ARG AWSCLI_ARCH="linux-aarch64"

FROM base-${TARGETARCH}

# Updating packages using sources
RUN cat /etc/apt/sources.list && \
    apt-get -qq clean -qq && apt-get -qq update && \

    # Install base
    apt-get -qq -y install build-essential curl git make openssh-client jq unzip groff less && \

    # Installing AWS CLIv2
    curl https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip -o awscliv2.zip && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && \
    rm -rf aws && \

    # Install graphviz
    apt-get -qq -y install graphviz && \

    # Install postgresql-client
    apt-get -qq -y install postgresql-client && \

    # Cleaning files!
    rm -rf /tmp/* && \
    apt-get -y remove --purge dpkg-dev fakeroot file manpages manpages-dev patch xauth xz-utils && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB
