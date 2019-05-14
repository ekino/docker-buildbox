FROM debian:8.7
LABEL maintainer="Thomas Rabaix <rabaix@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    NVM_DIR=/root/.nvm \
    PATH=/root/.nvm/versions/node/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG NODE_VERSION
ARG NPM_VERSION
ARG NVM_VERSION
ARG CI_HELPER_VERSION
ARG MODD_VERSION

RUN echo "Starting ..." && \
    echo "Acquire::Check-Valid-Until \"false\";" > /etc/apt/apt.conf && \
    echo "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq clean && apt-get -qq update && \
    apt-get -qq -y install build-essential libssl-dev curl git imagemagick subversion make mercurial \
      libmcrypt-dev libreadline-dev ruby-full openssh-client ocaml libelf-dev bzip2 gcc g++ && \
    gem install rb-inotify:'~> 0.9.10' sass --verbose && \
    gem install scss_lint:'~> 0.57.1' --verbose && \

    echo "Done base install!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd  && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd" && \

    echo "Starting Javascript..." && \
    git clone https://github.com/creationix/nvm.git /root/.nvm && cd /root/.nvm && git checkout v${NVM_VERSION} && \
    . /root/.nvm/nvm.sh && \

    nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && \
    ln -s /root/.nvm/versions/node/v${NODE_VERSION} /root/.nvm/versions/node/current && \

    npm install -g npm@${NPM_VERSION} && \

    curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn --no-install-recommends && \

    echo "Done JS!" && \

    echo "Starting AWS" && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Done AWS!" && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq -y remove --purge emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      patch po-debconf psmisc python-pip xauth xtrans-dev xz-utils zlib1g-dev && \

    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \

    echo "Done!"
