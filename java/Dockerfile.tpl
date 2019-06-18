FROM adoptopenjdk/openjdk{{VERSION}}:{{JAVA_VERSION}}
LABEL maintainer="Stephane Leclercq <leclercq@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION
ARG MODD_VERSION

RUN echo "Starting ..." && \

    echo "Updating packages using sources :" && \
    cat /etc/apt/sources.list && \

    apt-get -qq clean -qq && apt-get -qq update && \

    echo "Install base" && \
    apt-get -qq -y install \
        build-essential \
        curl \
        git \
        subversion \
        make \
        mercurial \
        openssh-client \
        jq && \
    echo "Done Install base!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done Install CI Helper" && \

    echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd  && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd" && \

    echo "Install AWS" && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Done Install AWS!" && \

    echo "Install Maven" && \
    apt-get -qq -y install maven && \
    echo "Done Install Maven!" && \

    echo "Install graphviz" && \
    apt-get -qq -y install graphviz && \
    echo "Done Install graphviz!" && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \

    echo "Cleaning files!" && \
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
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \

    echo "Done!"
