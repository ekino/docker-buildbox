FROM python:3.10.7-slim-buster

ARG ANSIBLE_VERSION

ADD ${ANSIBLE_VERSION}/requirements.txt .

RUN apt update && apt install -y curl zip && \
    pip install -U pip pipenv boto3 && \
    pip install -r requirements.txt &&  \
    rm -rf /var/cache/apk/* && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && rm -rf aws
