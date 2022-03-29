FROM docker:20.10.14-dind
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

ARG CI_HELPER_VERSION
ARG DOCKER_COMPOSE_VERSION
ARG GLIBC_VERSION
ARG PIP_VERSION
ARG TASKFILE_VERSION
ARG TRIVY_VERSION
ENV PYTHON_PIP_VERSION ${PIP_VERSION}

ADD requirements.txt .

RUN echo "Install AWS & Azure CLIs" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff zip && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip -q install boto3 PyYAML && \
    pip install -r requirements.txt && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    echo "Done installing AWS & Azure CLIs" && \
    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \
    echo "Install Taskfile" && \
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} && \
    echo "Done Install Taskfile" && \
    echo "Install Docker Compose" && \
    apk del libc6-compat && \
    curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O && \
    apk add --update -q glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    curl -sSL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version && \
    echo "Done install Docker Compose" && \
    echo "Install Trivy" && \
    apk add -q curl && \
    curl -sSL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -o trivy_Linux-64bit.tar.gz && \
    tar -zxf trivy_Linux-64bit.tar.gz -C /usr/bin/ && \
    echo "Done install Trivy" && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
