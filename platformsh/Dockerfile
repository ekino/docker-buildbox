FROM python:3.6-alpine
LABEL maintainer="Maxime Sibellas<maxime.sibellas@ekino.com>"

ARG PLATFORMSH_CLI_VERSION
ARG PLATFORMSH_CLI_SHASUM

ENV PATH="/usr/local/bin/:${PATH}"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apk add --update -q --no-cache bash build-base curl git libffi-dev make openldap-dev openssh-client php7 && \
    pip install --upgrade pip pipenv

# Install the Platform.sh CLI
ADD install-cli.sh .
RUN bash ./install-cli.sh ${PLATFORMSH_CLI_VERSION} ${PLATFORMSH_CLI_SHASUM}
