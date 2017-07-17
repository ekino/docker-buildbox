FROM jolicode/phpenv
MAINTAINER Rémi Marseille <marseille@ekino.com>

ARG PHP_VERSION
ARG PHP_BUILD_INSTALL_EXTENSION
ARG CI_HELPER_VERSION
ARG MODD_VERSION
ARG REDIS_VERSION

# restore to root config
USER root
ENV HOME /root

RUN echo "Starting ..." && \
    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd" && \

    echo "Starting PHP" && \
    MAKEFLAGS=' -j8' LDFLAGS=-lstdc++ phpenv install ${PHP_VERSION} && \
    phpenv global ${PHP_VERSION} && \
    phpenv rehash && \
    pear config-set php_ini $(php -r 'echo php_ini_loaded_file();') && \

    ln -s /home/.phpenv/versions/${PHP_VERSION} /home/.phpenv/versions/current && \

    composer global require "hirak/prestissimo:^0.3" && \

    echo "date.timezone=${PHP_TIMEZONE:-UTC}" > /home/.phpenv/versions/${PHP_VERSION}/etc/conf.d/date_timezone.ini && \

    curl -sSL https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/phpredis-${REDIS_VERSION} && phpize && ./configure && make && make install && \
    echo "extension=redis.so" > /home/.phpenv/versions/${PHP_VERSION}/etc/conf.d/redis.ini && \

    echo "Done PHP!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \

    echo "Done!"
