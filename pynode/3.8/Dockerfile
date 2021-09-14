FROM python:3.6-slim-buster
LABEL maintainer="Loïc Nairi <loic.nairi@ekino.com>"

ENV PATH=$PATH:./node_modules/.bin

COPY run.sh .
RUN sh run.sh
