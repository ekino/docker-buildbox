FROM python:{{PYTHON_VERSION}}-alpine3.8

ARG CI_HELPER_VERSION

RUN echo "Install system dependencies for python and pip" && \
    apk add --update -q --no-cache bash build-base curl git libffi-dev make openldap-dev openssh-client rsync tzdata && \
    pip install pip=={{PIP_VERSION}}
RUN echo "Starting ..." && \
    echo "Done base install!" && \
    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \
    echo "Install basics Python tools" && \
    pip install --upgrade pipenv=={{PIPENV_VERSION}} && \
    echo "Done install CI Helper"
