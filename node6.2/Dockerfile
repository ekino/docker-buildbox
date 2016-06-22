FROM debian:8.5
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV NVM_DIR /root/.nvm
ENV PATH /root/.nvm/versions/node/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NODE_VERSION 6.2.2

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get clean && apt-get -qq update && \
    apt-get -y install build-essential libssl-dev curl git subversion make mercurial \
      libmcrypt-dev libreadline-dev ruby-full openssh-client && \
    gem install sass --verbose && \
    gem install scss_lint --verbose && \

    echo "Done base install!" && \

    echo "Starting Javascript..." && \
    git clone https://github.com/creationix/nvm.git /root/.nvm && cd /root/.nvm && git checkout v0.31.1 && \
    . /root/.nvm/nvm.sh && \

    nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && \
    ln -s /root/.nvm/versions/node/v${NODE_VERSION} /root/.nvm/versions/node/current && \

    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp@3.9 bower@1.7 grunt-cli@1.2 webpack@1.13 browserify@13.0 && \
    npm install -g babel@6.5 eslint@2.13 eslint-plugin-react@5.2 eslint-plugin-angular@1.1 && \
    npm install -g eslint-config-standard@5.3 eslint-plugin-promise@1.3 eslint-plugin-standard@1.3 && \

    echo "Done JS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get remove --purge -y emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      patch po-debconf psmisc xauth xtrans-dev xz-utils zlib1g-dev && \

    apt-get clean apt-get purge && rm -rf /var/lib/apt/lists/* && \

    echo "Done!"
