FROM python:3.9.5-slim-buster

ARG ANSIBLE_VERSION

RUN pip install ansible==${ANSIBLE_VERSION} pipenv awscli boto3 && \
    pip install -U pip && \
    rm -rf /var/cache/apk/*
