FROM docker:20.10.24-dind as base
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"
ARG TASKFILE_VERSION
ARG TRIVY_VERSION

FROM base as base-amd64
ARG TRIVY_ARCH="Linux-64bit"
ARG AWSCLI_ARCH="linux-x86_64"
ADD requirements.txt .
RUN echo "Install AWS & Azure CLIs" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff zip && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 -q install boto3 PyYAML && \
    pip3 install -r requirements.txt && \
    apk del libc6-compat && \
    apk add aws-cli && \
    echo "Done installing AWS & Azure CLIs"

FROM base as base-arm64
ARG TRIVY_ARCH="Linux-ARM64"
ADD requirements.txt .
RUN echo "Install AWS & Azure CLIs" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff zip && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 -q install boto3 PyYAML && \
    pip3 install -r requirements.txt && \
    apk del libc6-compat && \
    apk add aws-cli && \
    echo "Done installing AWS & Azure CLIs"

FROM base-$TARGETARCH
RUN echo "Install Taskfile" && \
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} && \
    echo "Done Install Taskfile" && \
    echo "Install Docker Compose" && \
    apk add --update docker-compose && \
    docker-compose --version && \
    echo "Done install Docker Compose" && \
    echo "Install Trivy" && \
    apk add -q curl && \
    curl -sSL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz -o trivy_${TRIVY_ARCH}.tar.gz && \
    tar -zxf trivy_${TRIVY_ARCH}.tar.gz -C /usr/bin/ && \
    echo "Done install Trivy" && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
