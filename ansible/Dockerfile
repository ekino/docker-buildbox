FROM python:3.10.1-slim-buster

ARG ANSIBLE_VERSION

ADD ${ANSIBLE_VERSION}/requirements.txt .

RUN pip install -U pip pipenv boto3 awscli && \
    pip install -r requirements.txt &&  \
    rm -rf /var/cache/apk/*
