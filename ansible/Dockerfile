FROM python:3.10.5-slim-buster

ARG ANSIBLE_VERSION

ADD ${ANSIBLE_VERSION}/requirements.txt .

ARG TARGETARCH

COPY run.sh .
RUN sh run.sh

