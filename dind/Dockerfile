FROM docker:29.6.1-dind AS base
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
ARG TARGETARCH
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
    echo "Install Cosign" && \
    COSIGN_VERSION=$(curl -s https://api.github.com/repos/sigstore/cosign/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -Lo /usr/bin/cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-${TARGETARCH} && \
    chmod +x /usr/bin/cosign && \
    echo "Done install Cosign" && \
    echo "Install Crane" && \
    CRANE_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") && \
    CRANE_VERSION=$(curl -s https://api.github.com/repos/google/go-containerregistry/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_${CRANE_ARCH}.tar.gz && \
    tar xf go-containerregistry_Linux_${CRANE_ARCH}.tar.gz crane && \
    rm go-containerregistry_Linux_${CRANE_ARCH}.tar.gz && \
    mv crane /usr/bin/crane && \
    echo "Done install Crane" && \
    echo "Install Syft" && \
    SYFT_VERSION=$(curl -s https://api.github.com/repos/anchore/syft/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz && \
    tar xf syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz syft && \
    rm syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz && \
    mv syft /usr/bin/syft && \
    echo "Done install Syft" && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
