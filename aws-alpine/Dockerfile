FROM python:3.11-alpine@sha256:4e8e9a59bf1b3ca8e030244bc5f801f23e41e37971907371da21191312087a07 AS aws-builder

ENV AWSCLI_VERSION=2.11.18

RUN apk add --no-cache \
  curl \
  make \
  cmake \
  gcc \
  g++ \
  libc-dev \
  libffi-dev \
  openssl-dev 
RUN pip3 install --no-cache --upgrade pip setuptools wheel
RUN curl https://awscli.amazonaws.com/awscli-$AWSCLI_VERSION.tar.gz | tar -xz
RUN cd awscli-$AWSCLI_VERSION \
  && ./configure --bindir=/usr/local/bin --prefix=/aws-cli/ --with-download-deps --with-install-type=portable-exe \
  && make \
  && make install