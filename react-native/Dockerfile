FROM openjdk:8u171-jdk-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    ANDROID_HOME="/opt/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/node/bin:${PATH}"

ARG CI_HELPER_VERSION
ARG MODD_VERSION
ARG NODE_VERSION

# ——————————
# Install base software packages
# ——————————
RUN echo "Starting ..." && \
    echo "Updating packages using sources :" && \
    cat /etc/apt/sources.list && \
    apt-get -qq clean && apt-get -qq update && \

    echo "Install base" && \
    apt-get -qq -y install \
        build-essential \
        curl \
        git \
        subversion \
        make \
        mercurial \
        openssh-client \
        software-properties-common \
        automake \
        python-dev \
        python-setuptools \
        unzip && \
    echo "Done Install base!"

# ——————————
# Install CI Helper
# ——————————
RUN echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done Install CI Helper"

# ——————————
# Install Modd
# ——————————
RUN echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd  && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd"

# ——————————
# Install AWS
# ——————————
RUN echo "Install AWS" && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Done Install AWS!"

# ——————————
# Setup Java 8
# ——————————
RUN echo "Removing unnecessary JDK 8 binaries and libraries ..." && \
    rm -rf /usr/lib/jvm/java-8-openjdk-amd64/*src.zip \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/javaws \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/*javafx* \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/*jfx* \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libdecora_sse.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libfxplugins.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libglass.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libgstreamer-lite.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libjavafx*.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libjfx*.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libprism_*.so \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/deploy* \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/desktop \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/jfxrt.jar \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/javaws.jar \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/plugin.jar \
           /usr/lib/jvm/java-8-openjdk-amd64/jre/plugin \
           /usr/lib/jvm/java-8-openjdk-amd64/lib/*javafx* && \

    export PATH=$PATH:/docker-java-home

# ——————————
# Installs i386 architecture required for running 32 bit Android tools
# —————————
RUN dpkg --add-architecture i386 && \
    apt-get -qq -y update && \
    apt-get -qq -y install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1

# ——————————
# Update certificates
# ——————————
RUN update-ca-certificates --fresh

# ——————————
# Download Android SDK
# ——————————
RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -sSL -o sdk.zip $SDK_URL > /dev/null && \
    unzip -qq sdk.zip && \
    rm sdk.zip && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# ——————————
# Install Node and global packages
# ——————————
RUN cd /tmp && \
    curl -sSL -O http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz > /dev/null && \
    tar -xzf node-v${NODE_VERSION}-linux-x64.tar.gz && \
    mv node-v${NODE_VERSION}-linux-x64 /opt/node && \
    rm node-v${NODE_VERSION}-linux-x64.tar.gz


# ——————————
# Install Basic React-Native packages
# ——————————
RUN npm install react-native-cli -g
RUN npm install rnpm -g
RUN npm install -g yarn

# ——————————
# Mime types
# ——————————
RUN echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

# ——————————
# Clean files
# ——————————
RUN echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -y remove --purge \
        dpkg-dev \
        fakeroot \
        file \
        manpages \
        manpages-dev \
        patch \
        xauth \
        xz-utils && \

    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB

ENV LANG en_US.UTF-8

WORKDIR /data
