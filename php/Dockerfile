FROM debian:8.6
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j2 \
    COMPOSER_NO_INTERACTION=1 \
    PATH=/root/.phpenv/versions/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PHP_BUILD_CONFIGURE_OPTS="--with-pdo-pgsql --disable-phpdbg --disable-cgi" \
    COMPOSER_VERSION=1.2.4

ARG PHP_VERSION
ARG PHP_BUILD_INSTALL_EXTENSION

RUN echo "Starting ..." && \
    echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq clean && apt-get -qq update && \
    apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial \
      libmcrypt-dev libreadline-dev openssh-client pgtop && \

    echo "Done base install!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/0.0.1/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Starting PHP" && \
    export PHP_BUILD_INSTALL_EXTENSION=${PHP_BUILD_INSTALL_EXTENSION} && \
    apt-get -qq -y build-dep php5-cli && \
    cd /root && git clone https://github.com/CHH/phpenv.git && cd phpenv && ./bin/phpenv-install.sh  && \
    cd /root && git clone git://github.com/php-build/php-build && cd php-build && ./install.sh && \

    sed -i "/--enable-cgi/d" share/php-build/default_configure_options && \
    sed -i "/--enable-phpdbg/d" share/php-build/default_configure_options && \
    sed -i "/--enable-ftp/d" share/php-build/default_configure_options && \
    sed -i "/--with-tidy/d" share/php-build/default_configure_options && \
    sed -i "/--enable-sysvsem/d" share/php-build/default_configure_options && \
    sed -i "/--enable-sysvshm/d" share/php-build/default_configure_options && \
    sed -i "/--with-kerberos/d" share/php-build/default_configure_options && \

    cat share/php-build/default_configure_options && \

    php-build -i development ${PHP_VERSION} "/root/.phpenv/versions/${PHP_VERSION}" && \
    ln -s /root/.phpenv/versions/${PHP_VERSION} /root/.phpenv/versions/current && \

    ls -lsah /root/.phpenv/versions/current/bin && \
    curl -sSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && chmod a+x  /usr/local/bin/composer && \
    curl -sSL http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x  /usr/local/bin/php-cs-fixer && \

    echo "date.timezone=${PHP_TIMEZONE:-UTC}" > /root/.phpenv/versions/${PHP_VERSION}/etc/conf.d/date_timezone.ini && \

    echo "Done PHP!" && \

    echo "Starting AWS" && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Done AWS!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq -y remove --purge dpkg-dev emacsen-common fakeroot file firebird2.5-common firebird2.5-common-doc \
      firebird2.5-server-common libx11-6 libx11-data libx11-dev man-db manpages manpages-dev \
      mysql-client-5.5 mysql-common mysql-server-5.5 mysql-server-core-5.5 odbcinst odbcinst1debian2 \
      openssl patch po-debconf psmisc python-pip x11-common x11proto-core-dev \
      x11proto-input-dev x11proto-kb-dev xauth xorg-sgml-doctools xtrans-dev xz-utils zlib1g-dev && \

    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \

    echo "Done!"
