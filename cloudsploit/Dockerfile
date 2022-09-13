FROM python:3.10.7-slim-buster

LABEL maintainer="Axel Pavageau <axel.pavageau@ekino.com>"

ADD package.json .

RUN apt-get update -qq && apt-get install -y wget zip \
    && pip install -U pip \
    && pip install pipenv boto3 \
    && apt install -y npm git \
    && wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install

RUN npm install \
    && ln -s /node_modules/cloudsploit/index.js /usr/local/bin/cloudsploit
