FROM debian:8.7

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG JAVA_VERSION
ARG CI_HELPER_VERSION
ARG MODD_VERSION

# ——————————
# Install from Java 8 dockerfile
# ——————————

RUN echo "Starting ..." && \
    echo "deb-src http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq clean && apt-get -qq update && \
    apt-get -qq -y install build-essential curl git subversion make mercurial openssh-client bzip2 && \

    echo "Done base install!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd  && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd" && \

    echo "Starting Java" && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" >> /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb http://ppa.launchpad.net/andrei-pozolotin/maven3/ubuntu trusty main" > /etc/apt/sources.list.d/maven3.list && \
    echo "deb-src http://ppa.launchpad.net/andrei-pozolotin/maven3/ubuntu trusty main" >> /etc/apt/sources.list.d/maven3.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 68B166DC && \
    apt-get -qq update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get -qq -y install oracle-java8-installer=${JAVA_VERSION} oracle-java8-set-default=${JAVA_VERSION} maven3 && \
    echo "Done Java!" && \

    echo "Starting AWS" && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Done AWS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq -y remove --purge dpkg-dev fakeroot file gcc-4.8-base icc-profiles-free manpages manpages-dev \
      python-pip openssl patch xauth xz-utils zlib1g-dev && \

    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    rm -rf /usr/lib/jvm/java-8-oracle/*src.zip \
      /usr/lib/jvm/java-8-oracle/jre/bin/javaws \
      /usr/lib/jvm/java-8-oracle/jre/lib/*javafx* \
      /usr/lib/jvm/java-8-oracle/jre/lib/*jfx* \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libdecora_sse.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libfxplugins.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libglass.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libgstreamer-lite.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libjavafx*.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libjfx*.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libprism_*.so \
      /usr/lib/jvm/java-8-oracle/jre/lib/deploy* \
      /usr/lib/jvm/java-8-oracle/jre/lib/desktop \
      /usr/lib/jvm/java-8-oracle/jre/lib/ext/jfxrt.jar \
      /usr/lib/jvm/java-8-oracle/jre/lib/javaws.jar \
      /usr/lib/jvm/java-8-oracle/jre/lib/plugin.jar \
      /usr/lib/jvm/java-8-oracle/jre/plugin \
      /usr/lib/jvm/java-8-oracle/lib/*javafx* \
      /usr/lib/jvm/java-8-oracle/lib/missioncontrol \
      /usr/lib/jvm/java-8-oracle/lib/visualvm

# ——————————
# Install base software packages
# ——————————
RUN apt-get update && \
    apt-get install software-properties-common \
    automake \
    build-essential \
    python-software-properties \
    python-dev \
    python-setuptools \
    unzip -y && \
    apt-get clean

# ——————————
# Installs i386 architecture required for running 32 bit Android tools
# —————————
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

# ——————————
# Update certificates
# ——————————
RUN update-ca-certificates --fresh

# ——————————
# Set up environment variables
# ——————————
ENV ANDROID_HOME="/home/user/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-3.3-all.zip"

# ——————————
# Create a non-root user
# ——————————
RUN useradd -m user
USER user
WORKDIR /home/user

# ——————————
# Download Android SDK
# ——————————
RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# ——————————
# Install Gradle
# ——————————
RUN wget $GRADLE_URL -O gradle.zip && \
    unzip gradle.zip && \
    mv gradle-3.3 gradle && \
    rm gradle.zip && \
    mkdir .gradle

ENV PATH="/home/user/gradle/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"

# ——————————
# Install Node and global packages
# ——————————
ENV NODE_VERSION 7.10.0
RUN cd && \
    wget -q http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
    tar -xzf node-v${NODE_VERSION}-linux-x64.tar.gz && \
    mkdir opt && \
    mv node-v${NODE_VERSION}-linux-x64 /home/user/opt/node && \
    rm node-v${NODE_VERSION}-linux-x64.tar.gz
ENV PATH ${PATH}:/home/user/opt/node/bin

# ——————————
# Installs FB Watchman
# ——————————
RUN git clone -b v4.7.0 https://github.com/facebook/watchman.git /home/user/tmp/watchman
WORKDIR /home/user/tmp/watchman
RUN ./autogen.sh
RUN ./configure
RUN make
USER root
RUN make install
USER user

# ——————————
# Install Basic React-Native packages
# ——————————
RUN npm install react-native-cli -g
RUN npm install rnpm -g
RUN npm install -g yarn

ENV LANG en_US.UTF-8

WORKDIR /home/user/data

# Expose ports
EXPOSE 8080
EXPOSE 8082
EXPOSE 8081