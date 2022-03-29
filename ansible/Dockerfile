FROM python:3.10.4-slim-buster

ARG ANSIBLE_VERSION

ADD ${ANSIBLE_VERSION}/requirements.txt .

RUN apt update && apt install -y wget zip && \
    pip install -U pip pipenv boto3 && \
    pip install -r requirements.txt &&  \
    rm -rf /var/cache/apk/* && \
    wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    unzip awscli-exe-linux-x86_64.zip && \
    ./aws/install
