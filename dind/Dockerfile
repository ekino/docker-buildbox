FROM docker:20.10.24-dind
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

ARG GLIBC_VERSION
ARG TASKFILE_VERSION
ARG TRIVY_VERSION

ADD requirements.txt .

RUN echo "Install AWS & Azure CLIs" && \
    apk add -q --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers musl-dev openldap-dev openssh-client python3-dev gcc libffi-dev libressl-dev make rsync tzdata groff zip && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 -q install boto3 PyYAML && \
    pip3 install -r requirements.txt && \
    apk del libc6-compat && \
    curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O && \
    apk add --update -q --force-overwrite glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && rm -rf aws && \
    echo "Done installing AWS & Azure CLIs" && \
    echo "Install Taskfile" && \
    curl -sSL https://taskfile.dev/install.sh | sh -s v${TASKFILE_VERSION} && \
    echo "Done Install Taskfile" && \
    echo "Install Docker Compose" && \
    apk add --update docker-compose && \
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
