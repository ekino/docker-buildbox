FROM debian:8.2
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV NVM_DIR /root/.nvm

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial \
      libmcrypt-dev libreadline-dev ruby-full openssh-client && \
    gem install sass && \
    gem install scss_lint && \

    echo "Done base install!" && \

    echo "Starting Javascript..." && \
    git clone https://github.com/creationix/nvm.git /root/.nvm && cd /root/.nvm && git checkout v0.30.2 && \
    . /root/.nvm/nvm.sh && \

    nvm install 4.3.0 && nvm alias default 4.3.0 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp@3.9 bower@1.7 grunt-cli@0.1 webpack@1.12 browserify@13.0 && \
    npm install -g babel@6.5 eslint@2.0 eslint-plugin-react@3.16 eslint-plugin-angular@0.15 && \
    npm install -g eslint-config-standard@5.1 eslint-plugin-promise@1.0 eslint-plugin-standard@1.3 && \
    npm install -g mocha@2.4 && \

    echo "Done JS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get remove --purge -y dpkg-dev emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common libx11-6 libx11-data libx11-dev man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      openssl patch po-debconf psmisc x11-common x11proto-core-dev \
      x11proto-input-dev x11proto-kb-dev xauth xorg-sgml-doctools xtrans-dev xz-utils zlib1g-dev && \

    apt-get clean apt-get purge &&  rm -rf /var/lib/apt/lists/* && \

    echo "Done!"

COPY bashrc /root/.bashrc
