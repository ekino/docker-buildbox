FROM debian:8.7
LABEL maintainer="Stephane Leclercq <leclercq@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG JAVA_VERSION
ARG CI_HELPER_VERSION
ARG MODD_VERSION

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
    echo oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get -qq -y install oracle-java9-installer=${JAVA_VERSION} oracle-java9-set-default=${JAVA_VERSION} maven3 && \
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
    rm -rf /var/cache/oracle-jdk9-installer && \
    rm -rf /usr/lib/jvm/java-9-oracle/*src.zip \
      /usr/lib/jvm/java-9-oracle/bin/javaws \
      /usr/lib/jvm/java-9-oracle/lib/*jfx* \
      /usr/lib/jvm/java-9-oracle/lib/libdecora_sse.so \
      /usr/lib/jvm/java-9-oracle/lib/libfxplugins.so \
      /usr/lib/jvm/java-9-oracle/lib/libglass.so \
      /usr/lib/jvm/java-9-oracle/lib/libgstreamer-lite.so \
      /usr/lib/jvm/java-9-oracle/lib/libjavafx*.so \
      /usr/lib/jvm/java-9-oracle/lib/libjfx*.so \
      /usr/lib/jvm/java-9-oracle/lib/libprism_*.so \
      /usr/lib/jvm/java-9-oracle/lib/deploy* \
      /usr/lib/jvm/java-9-oracle/lib/desktop \
      /usr/lib/jvm/java-9-oracle/lib/javaws.jar \
      /usr/lib/jvm/java-9-oracle/lib/plugin.jar \
      /usr/lib/jvm/java-9-oracle/lib/*javafx* \
      /usr/lib/jvm/java-9-oracle/lib/missioncontrol && \

    echo "Done!"
