FROM python:3.10.1-slim-buster

LABEL maintainer="Axel Pavageau <axel.pavageau@ekino.com>"

ADD package.json .

RUN apt-get update -qq \
    && pip install -U pip \
    && pip install pipenv awscli boto3 \
    && apt install -y npm git

RUN npm install \
    && ln -s /node_modules/cloudsploit/index.js /usr/local/bin/cloudsploit
