FROM python:3.9.7-slim-buster

ADD requirements.txt .

RUN pip install -U pip pipenv boto3 awscli && \
    pip install -r requirements.txt &&  \
    rm -rf /var/cache/apk/*
