#!/bin/sh

echo "Starting ..."

version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")
echo "@edge-main https://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edge-community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
echo "@edge-community-3.13 http://nl.alpinelinux.org/alpine/v3.13/community" >> /etc/apk/repositories
apk add --update --upgrade alpine-sdk apk-tools@edge-main autoconf bash bzip2 cyrus-sasl-dev curl freetype-dev gettext git \
    gnu-libiconv@edge-community-3.13==${ICONV_VERSION} icu-dev jq libgcrypt-dev libcrypto1.1 libjpeg-turbo-dev \
    libmcrypt-dev libmemcached-dev libpng-dev libssh2-dev libssl1.1 libxml2-dev libxslt-dev libzip-dev linux-headers make \
    musl-dev==${MUSL_VERSION} mysql-client openssh-client patch postgresql-client postgresql-dev rsync tzdata
echo "Done base install!"

echo "Install Modd"
curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-${MODD_ARCH}.tgz | tar -xOvzf - modd-${MODD_VERSION}-${MODD_ARCH}/modd > /usr/bin/modd
chmod 755 /usr/bin/modd
echo "Done Install Modd"

echo "Starting PHP with $version"

docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

CFLAGS_PREVIOUS=$CFLAGS
export CFLAGS="$CFLAGS -D_GNU_SOURCE"
docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath exif gd intl mysqli pcntl pdo_mysql pdo_pgsql pgsql soap sockets xsl zip
export CFLAGS=$CFLAGS_PREVIOUS

pecl install apcu-${APCU_VERSION}
pecl install memcached-${MEMCACHED_VERSION}
pecl install pcov
docker-php-ext-enable pcov
docker-php-ext-enable memcached
docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

echo -e "\
date.timezone=${PHP_TIMEZONE:-UTC} \n\
short_open_tag=Off \n\
extension=apcu.so \n\
zend_extension=opcache.so \n\
" > /usr/local/etc/php/php.ini

curl -sSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && chmod a+x /usr/local/bin/composer
curl -sSL https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${PHP_CS_FIXER_VERSION}/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x /usr/local/bin/php-cs-fixer
curl -sSL https://github.com/fabpot/local-php-security-checker/releases/download/v${SECURITY_CHECKER_VERSION}/local-php-security-checker_${SECURITY_CHECKER_VERSION}_${SECURITY_CHECKER_ARCH} -o /usr/local/bin/local-php-security-checker && chmod a+x /usr/local/bin/local-php-security-checker
ln -s local-php-security-checker /usr/local/bin/security-checker
curl -sSL https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz | tar xz -C /tmp
cd /tmp/phpredis-${REDIS_VERSION} && phpize && ./configure && make && make install
echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
curl -sSL https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.tar.gz | tar xz -C /tmp
cd /tmp/xdebug-${XDEBUG_VERSION} && phpize && ./configure --enable-xdebug && make && make install
echo -e "zend_extension=xdebug.so \nxdebug.mode=coverage \n" > /usr/local/etc/php/conf.d/xdebug.ini

mkdir -p /tmp/blackfire-probe
curl -A "Docker" -o /tmp/blackfire-probe/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/${TARGETARCH}/$version
tar zxpf /tmp/blackfire-probe/blackfire-probe.tar.gz -C /tmp/blackfire-probe
mv /tmp/blackfire-probe/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so
printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini
mkdir -p /tmp/blackfire-client
curl -A "Docker" -L https://blackfire.io/api/v1/releases/client/linux/${TARGETARCH} | tar zxp -C /tmp/blackfire-client
mv /tmp/blackfire-client/blackfire /usr/bin/blackfire
echo "Done PHP!"

echo "Starting AWS"
apk add groff py-pip
pip install -q -U awscli
echo "Done AWS!"

echo "Adding an up to date mime-types definition file"
curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

echo "Cleaning files!"
apk del --purge alpine-sdk autoconf
rm -rf /tmp/* /usr/share/doc /var/cache/apk/*

echo "Done!"
