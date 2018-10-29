FROM python:{{PYTHON_VERSION}}-alpine3.8

ARG CI_HELPER_VERSION
ARG PIPENV_VERSION
ARG PIP_VERSION
ENV PYTHON_PIP_VERSION ${PIP_VERSION}

RUN echo "Starting ..." && \
    echo "Install system dependencies for python and pip" && \
    apk add --update -q --no-cache bash build-base curl git libffi-dev make openldap-dev openssh-client rsync tzdata && \
    pip install pip==${PYTHON_PIP_VERSION} && \
    echo "Done base install!" && \
    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \
    echo "Install basics Python tools" && \
    pip install --upgrade pipenv==${PIPENV_VERSION} && \
    if [ "${PYTHON_VERSION:0:1}" = "2" ]; then \
        pip install anchorecli; \
    fi && \
    echo "Done!"
