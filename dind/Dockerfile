FROM docker:20.10.24-dind as base
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"
ARG GLIBC_VERSION
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
    curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O && \
    apk add --update -q --force-overwrite glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    curl https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && rm -rf aws && \
    echo "Done installing AWS & Azure CLIs"

FROM python:3.11-alpine@sha256:4e8e9a59bf1b3ca8e030244bc5f801f23e41e37971907371da21191312087a07 AS aws-builder
ARG AWSCLI_VERSION=2.11.18
RUN apk add --no-cache curl make cmake gcc g++ libc-dev libffi-dev openssl-dev && \
    pip3 install --no-cache --upgrade pip setuptools wheel
RUN curl https://awscli.amazonaws.com/awscli-$AWSCLI_VERSION.tar.gz | tar -xz && \
    cd awscli-$AWSCLI_VERSION && \
   ./configure --bindir=/usr/local/bin --prefix=/aws-cli/ --with-download-deps --with-install-type=portable-exe && \
    make && \
    make install
# reduce image size
RUN rm -rf awscli-$AWSCLI_VERSION

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
    echo "Done installing AWS & Azure CLIs"
COPY --from=aws-builder aws-cli/lib/aws-cli/ /usr/local/lib/aws-cli/
RUN ln -s /usr/local/lib/aws-cli/aws /usr/local/bin/aws

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
