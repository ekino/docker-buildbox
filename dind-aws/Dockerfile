FROM docker:18.06.3-ce-dind
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

ARG CI_HELPER_VERSION
ARG DOCKER_COMPOSE_VERSION
ARG GLIBC_VERSION
ARG PIPENV_VERSION
ARG PIP_VERSION
ENV PYTHON_PIP_VERSION ${PIP_VERSION}

RUN echo "Install AWS" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers make musl-dev openldap-dev openssh-client python py-pip rsync tzdata && \
    pip install pip==${PYTHON_PIP_VERSION} && \
    pip -q install pipenv==${PIPENV_VERSION} awscli boto3 PyYAML && \
    echo "Done install AWS" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Install Docker Compose" && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O && \
    apk add --update -q glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    curl -sSL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \

    echo "Done!"
