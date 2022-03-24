#!/bin/sh

echo "Starting ..."

version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")
echo "@edge-main https://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edge-community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
echo "@edge-community-3.13 http://nl.alpinelinux.org/alpine/v3.13/community" >> /etc/apk/repositories
apk add --update --upgrade alpine-sdk apk-tools@edge-main autoconf bash bzip2 cyrus-sasl-dev curl unzip groff less zlib freetype-dev gettext git \
gnu-libiconv@edge-community-3.13==${ICONV_VERSION} icu-dev jq libgcrypt-dev libcrypto1.1 libjpeg-turbo-dev \
libmcrypt-dev libmemcached-dev libpng-dev libssh2-dev libssl1.1 libxml2-dev libxslt-dev libzip-dev make \
musl-dev==${MUSL_VERSION} mysql-client openssh-client patch postgresql-client postgresql-dev rsync tzdata
echo "Done base install!"

echo "Install CI Helper"
curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper
chmod 755 /usr/bin/ci-helper
echo "Done install CI Helper"



echo "Install Modd"
curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd
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

if [ "$version" = "74" ]; then
    pecl install ssh2-${SSH2_VERSION};
    docker-php-ext-enable ssh2;
fi

echo -e "\
date.timezone=${PHP_TIMEZONE:-UTC} \n\
short_open_tag=Off \n\
extension=apcu.so \n\
zend_extension=opcache.so \n\
" > /usr/local/etc/php/php.ini

curl -sSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && chmod a+x /usr/local/bin/composer
curl -sSL https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${PHP_CS_FIXER_VERSION}/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x /usr/local/bin/php-cs-fixer
curl -sSL https://github.com/fabpot/local-php-security-checker/releases/download/v${SECURITY_CHECKER_VERSION}/local-php-security-checker_${SECURITY_CHECKER_VERSION}_linux_amd64 -o /usr/local/bin/local-php-security-checker && chmod a+x /usr/local/bin/local-php-security-checker
ln -s local-php-security-checker /usr/local/bin/security-checker
curl -sSL https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz | tar xz -C /tmp
cd /tmp/phpredis-${REDIS_VERSION} && phpize && ./configure && make && make install
echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
curl -sSL https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.tar.gz | tar xz -C /tmp
cd /tmp/xdebug-${XDEBUG_VERSION} && phpize && ./configure --enable-xdebug && make && make install
echo -e "zend_extension=xdebug.so \nxdebug.mode=coverage \n" > /usr/local/etc/php/conf.d/xdebug.ini

mkdir -p /tmp/blackfire-probe
curl -A "Docker" -o /tmp/blackfire-probe/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version
tar zxpf /tmp/blackfire-probe/blackfire-probe.tar.gz -C /tmp/blackfire-probe
mv /tmp/blackfire-probe/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so
printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini
mkdir -p /tmp/blackfire-client
curl -A "Docker" -L https://blackfire.io/api/v1/releases/client/linux_static/amd64 | tar zxp -C /tmp/blackfire-client
mv /tmp/blackfire-client/blackfire /usr/bin/blackfire
echo "Done PHP!"

# AWS Tools
# install glibc & aws compatibility for alpine
echo "Starting AWS"
export GLIBC_VER=2.31-r0

# install glibc compatibility for alpine
apk --no-cache add \
binutils \
curl \
&& curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
&& curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VER/glibc-$GLIBC_VER.apk \
&& curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VER/glibc-bin-$GLIBC_VER.apk \
&& curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VER/glibc-i18n-$GLIBC_VER.apk \
&& apk add --no-cache \
glibc-$GLIBC_VER.apk \
glibc-bin-$GLIBC_VER.apk \
glibc-i18n-$GLIBC_VER.apk \
&& /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
&& curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
&& unzip awscliv2.zip \
&& aws/install \
&& rm -rf \
awscliv2.zip \
aws \
/usr/local/aws-cli/v2/current/dist/aws_completer \
/usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
/usr/local/aws-cli/v2/current/dist/awscli/examples \
glibc-*.apk \
&& find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete \
&& apk --no-cache del \
binutils \
curl \
&& rm -rf /var/cache/apk/*
echo "Done AWS!"

echo "Adding an up to date mime-types definition file"
curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types

echo "Cleaning files!"
apk del --purge alpine-sdk autoconf
rm -rf /tmp/* /usr/share/doc /var/cache/apk/*

echo "Done!"
