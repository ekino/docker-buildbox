FROM debian:8.6
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_BUILD_EXTRA_MAKE_ARGUMENTS -j4
ENV COMPOSER_NO_INTERACTION 1
ENV PATH /root/.phpenv/versions/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PHP_VERSION 5.6.28
ENV PHP_BUILD_CONFIGURE_OPTS --with-pdo-pgsql
ENV PHP_BUILD_INSTALL_EXTENSION apcu=4.0.11

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get clean && apt-get -qq update && \
    apt-get -y install build-essential libssl-dev curl git subversion make mercurial \
      libmcrypt-dev libreadline-dev openssh-client && \

    echo "Done base install!" && \

    echo "Starting PHP" && \
    apt-get -y build-dep php5-cli && \
    cd /root && git clone https://github.com/CHH/phpenv.git && cd phpenv && ./bin/phpenv-install.sh  && \
    cd /root && git clone git://github.com/php-build/php-build && cd php-build && ./install.sh && \
    php-build -i development ${PHP_VERSION} "/root/.phpenv/versions/${PHP_VERSION}" && \
    ln -s /root/.phpenv/versions/${PHP_VERSION} /root/.phpenv/versions/current && \
    rm -rf /root/.phpenv/versions/current/bin/phpdbg && \
    rm -rf /root/.phpenv/versions/current/bin/php-cgi && \

    curl https://getcomposer.org/composer.phar -o /usr/local/bin/composer && chmod a+x  /usr/local/bin/composer && \
    curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x  /usr/local/bin/php-cs-fixer && \

    echo "date.timezone=${PHP_TIMEZONE:-UTC}" > /root/.phpenv/versions/${PHP_VERSION}/etc/conf.d/date_timezone.ini && \

    echo "Done PHP!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get remove --purge -y dpkg-dev emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common libx11-6 libx11-data libx11-dev man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      openssl patch po-debconf psmisc x11-common x11proto-core-dev \
      x11proto-input-dev x11proto-kb-dev xauth xorg-sgml-doctools xtrans-dev xz-utils zlib1g-dev && \

    apt-get clean && apt-get purge &&  rm -rf /var/lib/apt/lists/* && \

    echo "Done!"
