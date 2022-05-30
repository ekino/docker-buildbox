FROM python:3.10.5-slim-buster

LABEL maintainer="Axel Pavageau <axel.pavageau@ekino.com>"

ARG TARGETARCH

ADD package.json .

COPY run.sh .
RUN sh run.sh
