FROM debian:8.2
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_BUILD_EXTRA_MAKE_ARGUMENTS -j4
ENV NVM_DIR /root/.nvm
ENV COMPOSER_NO_INTERACTION 1

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial \
      libmcrypt-dev libreadline-dev && \

    echo "Done base install!" && \

    echo "Starting PHP" && \
    apt-get -y build-dep php5-cli && \
    cd /root && git clone https://github.com/CHH/phpenv.git && cd phpenv && ./bin/phpenv-install.sh  && \
    cd /root && git clone git://github.com/php-build/php-build && cd php-build && ./install.sh && \
    php-build -i development 7.0.3 "/root/.phpenv/versions/7.0.3" && \
    php-build -i development 5.6.18 "/root/.phpenv/versions/5.6.18" && \
    php-build -i development 5.5.32 "/root/.phpenv/versions/5.5.32" && \
    php-build -i development 5.4.45 "/root/.phpenv/versions/5.4.45" && \

    curl https://getcomposer.org/composer.phar -o /usr/local/bin/composer && chmod a+x  /usr/local/bin/composer && \
    curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x  /usr/local/bin/php-cs-fixer && \
    echo "Done PHP!" && \

    echo "Starting Javascript..." && \
    git clone https://github.com/creationix/nvm.git /root/.nvm && cd /root/.nvm && git checkout v0.30.2 && \
    . /root/.nvm/nvm.sh && \

    nvm install 0.10.42 && nvm use 0.10.42 && \
    npm install -g npm@2 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp@3.9 bower@1.7 grunt-cli@0.1 webpack@1.12 browserify@13.0 && \
    npm install -g babel@6.5 eslint@2.0 eslint-plugin-react@3.16 eslint-plugin-angular@0.15  && \

    nvm install 0.12.10 && nvm use 0.12.10 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp@3.9 bower@1.7 grunt-cli@0.1 webpack@1.12 browserify@13.0 && \
    npm install -g babel@6.5 eslint@2.0 eslint-plugin-react@3.16 eslint-plugin-angular@0.15  && \

    nvm install 4.3.0 && nvm use 4.3.0 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp@3.9 bower@1.7 grunt-cli@0.1 webpack@1.12 browserify@13.0 && \
    npm install -g babel@6.5 eslint@2.0 eslint-plugin-react@3.16 eslint-plugin-angular@0.15  && \

    nvm install 5.6.0 && nvm use 5.6.0 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp@3.9 bower@1.7 grunt-cli@0.1 webpack@1.12 browserify@13.0 && \
    npm install -g babel@6.5 eslint@2.0 eslint-plugin-react@3.16 eslint-plugin-angular@0.15  && \

    echo "Done JS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get remove --purge -y dpkg-dev emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common libx11-6 libx11-data libx11-dev man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      openssh-client openssl patch po-debconf psmisc x11-common x11proto-core-dev \
      x11proto-input-dev x11proto-kb-dev xauth xorg-sgml-doctools xtrans-dev xz-utils zlib1g-dev && \

    apt-get clean apt-get purge &&  rm -rf /var/lib/apt/lists/* && \

    echo "Done!"

COPY bashrc /root/.bashrc
