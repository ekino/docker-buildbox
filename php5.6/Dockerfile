FROM debian:8.2
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_BUILD_EXTRA_MAKE_ARGUMENTS -j4
ENV COMPOSER_NO_INTERACTION 1

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial \
      libmcrypt-dev libreadline-dev openssh-client && \

    echo "Done base install!" && \

    echo "Starting PHP" && \
    apt-get -y build-dep php5-cli && \
    cd /root && git clone https://github.com/CHH/phpenv.git && cd phpenv && ./bin/phpenv-install.sh  && \
    cd /root && git clone git://github.com/php-build/php-build && cd php-build && ./install.sh && \
    php-build -i development 5.6.18 "/root/.phpenv/versions/5.6.18" && \
    /root/.phpenv/bin/phpenv global 5.6.18  && \
    rm -rf /root/.phpenv/versions/5.6.18/bin/phpdbg && \
    rm -rf /root/.phpenv/versions/5.6.18/bin/php-cgi && \

    curl https://getcomposer.org/composer.phar -o /usr/local/bin/composer && chmod a+x  /usr/local/bin/composer && \
    curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x  /usr/local/bin/php-cs-fixer && \
    echo "Done PHP!" && \

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
