FROM debian:8.2
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb-src http://httpredir.debian.org/debian jessie main" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qq -y upgrade && \
    apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial strace vim \
    python-software-properties libmcrypt-dev libreadline-dev

RUN cat /etc/apt/sources.list
RUN apt-get -y build-dep php5-cli
RUN git clone git://github.com/php-build/php-build && \
    cd php-build &&  \
    ./install.sh

#RUN php-build -i development 7.0.3 "~/local/php/7.0.3"
RUN php-build -i development 5.6.18 "/opt/php/5.6.18"
RUN php-build -i development 5.5.32 "/opt/php/5.5.32"
RUN php-build -i development 5.4.45 "/opt/php/5.4.45"
RUN php-build -i development 5.3.29 "/opt/php/5.3.29"
