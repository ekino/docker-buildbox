FROM debian:8.2
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_BUILD_EXTRA_MAKE_ARGUMENTS -j4
ENV NVM_DIR /root/.nvm

RUN echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qq -y upgrade && \
    apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial strace vim \
    python-software-properties libmcrypt-dev libreadline-dev && \

    echo "Done base install!"

RUN apt-get -y build-dep php5-cli && \
    cd /root && git clone https://github.com/CHH/phpenv.git && cd phpenv && ./bin/phpenv-install.sh  && \
    cd /root && git clone git://github.com/php-build/php-build && cd php-build && ./install.sh && \
    php-build -i development 5.6.18 "/root/.phpenv/versions/5.6.18" && \
    php-build -i development 5.5.32 "/root/.phpenv/versions/5.5.32" && \
    php-build -i development 5.4.45 "/root/.phpenv/versions/5.4.45" && \

    echo "Done PHP!"

## PHP Stuff
#RUN php-build -i development 7.0.3 "/root/.phpenv/versions/7.0.3"
#RUN php-build -i development 5.3.29 "/root/.phpenv/versions/5.3.29"

#RUN curl https://getcomposer.org/composer.phar -o /usr/local/bin/composer && chmod a+x  /usr/local/bin/composer
#RUN curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod a+x  /usr/local/bin/php-cs-fixer

## JS Stuff
RUN git clone https://github.com/creationix/nvm.git /root/.nvm && cd /root/.nvm && git checkout v0.30.2 && \
    . /root/.nvm/nvm.sh && \

    nvm install 0.10 && nvm use 0.10 && \
    npm install -g npm@2 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp grunt-cli webpack browserify && \
    npm install -g babel eslint eslint-plugin-react eslint-plugin-angular  && \

    nvm install 0.12 && nvm use 0.12 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp grunt-cli webpack browserify && \
    npm install -g babel eslint eslint-plugin-react eslint-plugin-angular  && \

    nvm install 4.0 && nvm use 4.0 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp grunt-cli webpack browserify && \
    npm install -g babel eslint eslint-plugin-react eslint-plugin-angular  && \

    nvm install 5.0 && nvm use 5.0 && \
    npm install -g npm@3 && \
    npm config set progress false && \
    npm config set loglevel warn && \
    npm install -g gulp grunt-cli webpack browserify && \
    npm install -g babel eslint eslint-plugin-react eslint-plugin-angular && \

    echo "Done JS!"

COPY bashrc /root/.bashrc