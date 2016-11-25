FROM debian:8.6
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV NVM_DIR /root/.nvm
ENV PATH /root/.nvm/versions/node/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NODE_VERSION 7.0.0

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
    git clone https://github.com/creationix/nvm.git /root/.nvm && cd /root/.nvm && git checkout v0.32.1 && \
    . /root/.nvm/nvm.sh && \

    nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && \
    ln -s /root/.nvm/versions/node/v${NODE_VERSION} /root/.nvm/versions/node/current && \

    npm install -g npm@3 && \

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn && \

    echo "Done JS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get remove --purge -y emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      patch po-debconf psmisc xauth xtrans-dev xz-utils zlib1g-dev && \

    apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* && \

    echo "Done!"
