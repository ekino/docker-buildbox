FROM python:3.9.7-slim-buster

ADD requirements.txt .

RUN pip install -U pip && \
    pip install pipenv awscli boto3 && \
    pip install -r requirements.txt
