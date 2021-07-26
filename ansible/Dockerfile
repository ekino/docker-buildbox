FROM python:3.9.6-slim-buster

RUN pip install -U pip && \
    pip install pipenv && \
    pipenv sync && \
    rm -rf /var/cache/apk/*
