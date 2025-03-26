FROM php:8.3.19-cli-alpine3.21 AS base
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG APCU_VERSION
ARG COMPOSER_VERSION
ARG MEMCACHED_VERSION
ARG PHP_CS_FIXER_VERSION
ARG REDIS_VERSION
ARG SSH2_VERSION
ARG XDEBUG_VERSION
ARG TARGETARCH

# iconv issue https://github.com/docker-library/php/issues/240
FROM base AS base-amd64

FROM base AS base-arm64

FROM base-$TARGETARCH
ENV COMPOSER_NO_INTERACTION=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    TERM=xterm \
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php" \
    PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++17"

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") && \
    apk add --update --upgrade alpine-sdk apk-tools autoconf bash bzip2 cyrus-sasl-dev curl freetype-dev gettext git \
    icu-dev icu-data-full jq libgcrypt-dev libjpeg-turbo-dev \
    libmcrypt-dev libmemcached-dev libpng-dev libssh2-dev libxml2-dev libxslt-dev libzip-dev linux-headers make \
    mysql-client openssh-client patch postgresql-client postgresql-dev rsync tzdata && \
    echo "Starting PHP with $version" && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    CFLAGS_PREVIOUS=$CFLAGS && \
    export CFLAGS="$CFLAGS -D_GNU_SOURCE" && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath exif gd intl mysqli pcntl pdo_mysql pdo_pgsql pgsql soap sockets xsl zip && \
    export CFLAGS=$CFLAGS_PREVIOUS && \
    pecl install apcu-${APCU_VERSION} && \
    pecl install memcached-${MEMCACHED_VERSION} && \
    pecl install pcov && \
    docker-php-ext-enable pcov && \
    docker-php-ext-enable memcached && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    echo -e "\
    date.timezone=${PHP_TIMEZONE:-UTC} \n\
    short_open_tag=Off \n\
    extension=apcu.so \n\
    zend_extension=opcache.so \n\
    " > /usr/local/etc/php/php.ini && \
    curl -sSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && chmod a+x /usr/local/bin/composer && \
    curl -sSL https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${PHP_CS_FIXER_VERSION}/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x /usr/local/bin/php-cs-fixer && \
    curl -sSL https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/phpredis-${REDIS_VERSION} && phpize && ./configure && make && make install && \
    echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini && \
    curl -sSL https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/xdebug-${XDEBUG_VERSION} && phpize && ./configure --enable-xdebug && make && make install && \
    echo -e "zend_extension=xdebug.so \nxdebug.mode=coverage \n" > /usr/local/etc/php/conf.d/xdebug.ini && \
    mkdir -p /tmp/blackfire-probe && \
    curl -A "Docker" -o /tmp/blackfire-probe/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/${TARGETARCH}/$version && \
    tar zxpf /tmp/blackfire-probe/blackfire-probe.tar.gz -C /tmp/blackfire-probe && \
    mv /tmp/blackfire-probe/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && \
    printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini && \
    mkdir -p /tmp/blackfire-client && \
    curl -A "Docker" -L https://blackfire.io/api/v1/releases/cli/linux/${TARGETARCH} | tar zxp -C /tmp/blackfire-client && \
    mv /tmp/blackfire-client/blackfire /usr/bin/blackfire && \
    # Starting AWS
    apk add aws-cli && \
    # Adding an up to date mime-types definition file
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    # Cleaning files
    apk del --purge alpine-sdk autoconf && \
    rm -rf /tmp/* /usr/share/doc /var/cache/apk/*
