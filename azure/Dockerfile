FROM python:3.11.0rc2-slim-buster

LABEL maintainer="opensource@ekino.com"

ADD requirements.txt .

RUN apt-get update -qq && apt-get install -qq -y ca-certificates curl apt-transport-https gcc wget unzip \
    && pip install -r requirements.txt \
    && apt-get remove -y unzip gcc && apt-get -qq -y autoremove \
    && apt-get -qq -y clean && apt-get -y -qq purge\
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old
