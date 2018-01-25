FROM php:{{PHP_VERSION}}
MAINTAINER Rémi Marseille <marseille@ekino.com>

ARG APCU_VERSION
ARG CI_HELPER_VERSION
ARG COMPOSER_VERSION
ARG GLIBC_VERSION
ARG MODD_VERSION
ARG REDIS_VERSION
ARG SECURITY_CHECKER_VERSION
ARG XDEBUG_VERSION

ENV COMPOSER_NO_INTERACTION=1 \
    TERM=xterm

RUN echo "Starting ..." && \
    echo "@edge-community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@edge-main http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --update --upgrade alpine-sdk autoconf bash bzip2 curl freetype-dev git icu-dev@edge-main libjpeg-turbo-dev libmcrypt-dev \
        libpng-dev libxml2-dev make openssh-client php{{PHP_MAJOR_VERSION}}-intl@edge-community postgresql-dev tzdata && \
    echo "Done base install!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    apk add -q glibc-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd" && \

    echo "Starting PHP" && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath gd pcntl pdo_mysql pdo_pgsql soap sockets zip && \
    pecl install apcu-${APCU_VERSION} && \
    echo -e "\
date.timezone=${PHP_TIMEZONE:-UTC} \n\
short_open_tag=Off \n\
extension=apcu.so \n\
extension=/usr/lib/php{{PHP_MAJOR_VERSION}}/modules/intl.so \n\
zend_extension=opcache.so \n\
" > /usr/local/etc/php/php.ini && \

    curl -sSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && chmod a+x /usr/local/bin/composer && \
    curl -sSL http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x /usr/local/bin/php-cs-fixer && \
    curl -sSL http://get.sensiolabs.org/security-checker-v${SECURITY_CHECKER_VERSION}.phar -o /usr/local/bin/security-checker && chmod a+x /usr/local/bin/security-checker && \
    composer global require "hirak/prestissimo:^0.3" && \

    curl -sSL https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/phpredis-${REDIS_VERSION} && phpize && ./configure && make && make install && \
    echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini && \

    curl -sSL https://github.com/xdebug/xdebug/archive/XDEBUG_${XDEBUG_VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/xdebug-XDEBUG_${XDEBUG_VERSION} && phpize && ./configure --enable-xdebug && make && make install && \
    echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini && \

    echo "Done PHP!" && \

    echo "Starting AWS" && \
    apk add groff py-pip && \
    pip install -q -U awscli && \
    echo "Done AWS!" && \

    echo "Cleaning files!" && \
    apk del --purge alpine-sdk autoconf && \
    rm -rf /tmp/* /usr/share/doc /var/cache/apk/* && \

    echo "Done!"
