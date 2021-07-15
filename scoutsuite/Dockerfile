FROM python:3.9.6-slim-buster

ARG SCOUTSUITE_VERSION

RUN pip install -U pip && \
    pip install pipenv awscli boto3 scoutsuite==${SCOUTSUITE_VERSION}
