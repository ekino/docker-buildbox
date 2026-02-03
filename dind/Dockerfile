FROM docker:29.2.0-dind AS base
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

FROM base AS base-amd64
ARG TRIVY_ARCH="Linux-64bit"
ARG AWSCLI_ARCH="linux-x86_64"
ADD requirements.txt .
RUN echo "Install AWS & Azure CLIs" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff zip && \
    rm -f /usr/lib/python*/EXTERNALLY-MANAGED && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 -q install boto3 PyYAML && \
    pip3 install -r requirements.txt && \
    apk add aws-cli && \
    echo "Done installing AWS & Azure CLIs"

FROM base AS base-arm64
ARG TRIVY_ARCH="Linux-ARM64"
ADD requirements.txt .
RUN echo "Install AWS & Azure CLIs" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff zip && \
    rm -f /usr/lib/python*/EXTERNALLY-MANAGED && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 -q install boto3 PyYAML && \
    pip3 install -r requirements.txt && \
    apk add aws-cli && \
    echo "Done installing AWS & Azure CLIs"

FROM base-$TARGETARCH
RUN echo "Install Taskfile" && \
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d && \
    echo "Done Install Taskfile" && \
    echo "Install Docker Compose" && \
    apk add --update docker-compose && \
    echo "Done install Docker Compose" && \
    echo "Install Trivy" && \
    # Downloading latest trivy
    TRIVY_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    tar xf trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    rm trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    mv trivy /usr/bin/trivy && \
    echo "Done install Trivy" && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
