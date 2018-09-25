FROM debian:squeeze
MAINTAINER Jean-Baptiste Hembise <jean-baptiste.hembise@ekino.com>

ARG MAVEN_VERSION

RUN echo "Starting ..." && \

    echo "Updating packages using sources :" && \
    rm /etc/apt/sources.list  && \
    echo "deb http://archive.debian.org/debian squeeze main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian squeeze-lts main contrib non-free" >> /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" >> /etc/apt/apt.conf.d/02CheckValid && \
    apt-get -qq clean -qq && apt-get -qq update && \

    echo "Install base" && \
    apt-get -qq -y --force-yes install \
		build-essential \
		curl \
		git \
		subversion \
		make \
		mercurial \
		openssh-client && \
    echo "Done Install base!" && \

    echo "Install java" && \
    echo debconf shared/accepted-sun-dlj-v1-1 boolean true | debconf-set-selections &&\
    apt-get -y --force-yes install sun-java6-jdk && \
    java -version && \
    echo "Done Install java" && \

    echo "Install Maven" && \
    curl -sSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar -xzf - -C /usr/bin && \
    chmod 755 /usr/bin/apache-maven-${MAVEN_VERSION} && \
    ln -s /usr/bin/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn && \
    echo "Done Install Maven!" && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \

    echo "Done!"