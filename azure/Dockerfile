FROM python:3.9.6-slim-buster

LABEL maintainer="Maxime Sibellas <maxime.sibellas@ekino.com>"

ARG AZURE_CLI_VERSION

RUN apt-get update -qq && apt-get install -qq -y ca-certificates curl apt-transport-https gcc wget unzip \
    && pip install azure-cli==${AZURE_CLI_VERSION} \
    && apt-get remove -y unzip gcc && apt-get -qq -y autoremove \
    && apt-get -qq -y clean && apt-get -y -qq purge\
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old
