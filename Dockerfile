FROM debian:8.2
MAINTAINER Thomas Rabaix <rabaix@ekino.com>

ENV DEBIAN_FRONTEND noninteractive

COPY /extra /extra

RUN apt-get -qq update
RUN apt-get -qq -y upgrade
RUN apt-get -qq -y install build-essential libssl-dev curl git subversion make mercurial strace vim \
    python-software-properties libmcrypt-dev libreadline-dev

