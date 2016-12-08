FROM debian:8.6
MAINTAINER Stephane Leclercq <leclercq@ekino.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get clean && apt-get -qq update && \
    apt-get -qq -y install build-essential curl git subversion make mercurial openssh-client && \

    echo "Done base install!" && \

    echo "Starting Java" && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get -qq update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get -y install oracle-java8-installer oracle-java8-set-default maven && \
    echo "Done Java!" && \

    echo "Starting AWS" && \
    apt-get install -y python-pip groff-base && \
    pip install -U awscli && \
    echo "Done AWS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get remove --purge -y dpkg-dev fakeroot file gcc-4.8-base icc-profiles-free manpages manpages-dev \
      python-pip openssl patch xauth xz-utils zlib1g-dev && \

    apt-get -y autoremove && \
    apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/info /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    rm -rf /usr/lib/jvm/java-8-oracle/*src.zip /usr/lib/jvm/java-8-oracle/lib/*javafx* \
      /usr/lib/jvm/java-8-oracle/lib/missioncontrol /usr/lib/jvm/java-8-oracle/lib/visualvm && \

    echo "Done!"
