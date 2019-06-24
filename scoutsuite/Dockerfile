FROM python:3.7-alpine3.8

ARG PIPENV_VERSION
ARG PIP_VERSION
ARG SCOUTSUITE_VERSION

RUN echo "Starting ..." && \
    echo "Install system dependencies for python and pip" && \
    apk add --update -q --no-cache bash build-base curl git libffi-dev libressl-dev libc-dev make openldap-dev openssh-client rsync tzdata linux-headers && \
    pip install pip==${PIP_VERSION} && \
    echo "Done base install!" && \
    echo "Install basics Python tools" && \
    pip install --upgrade pipenv==${PIPENV_VERSION} && \
    pip install scoutsuite==${SCOUTSUITE_VERSION} && \
    echo "Done!"
