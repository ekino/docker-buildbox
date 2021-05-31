FROM python:3.8-slim-buster

ARG ANSIBLE_VERSION

RUN pip install ansible==${ANSIBLE_VERSION} pipenv awscli boto3 && \
    pip install -U pip && \
    rm -rf /var/cache/apk/*
