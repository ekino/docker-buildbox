FROM docker:29.7.2-dind AS base
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
# Tool versions, resolved from the GitHub API by image_builder.py
ARG COSIGN_VERSION
ARG CRANE_VERSION
ARG SYFT_VERSION
ARG TRIVY_VERSION
RUN echo "Install Taskfile" && \
    sh -c "$(curl -f --location https://taskfile.dev/install.sh)" -- -d && \
    echo "Done Install Taskfile" && \
    echo "Install Docker Compose" && \
    apk add --update docker-compose && \
    echo "Done install Docker Compose" && \
    echo "Install Trivy" && \
    # Downloading latest trivy
    : "${TRIVY_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    curl -fLO --retry 3 --retry-delay 2 https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    tar xf trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    rm trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    mv trivy /usr/bin/trivy && \
    echo "Done install Trivy" && \
    echo "Install Cosign" && \
    : "${COSIGN_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    curl -f --retry 3 --retry-delay 2 -Lo /usr/bin/cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-${TARGETARCH} && \
    chmod +x /usr/bin/cosign && \
    echo "Done install Cosign" && \
    echo "Install Crane" && \
    CRANE_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") && \
    : "${CRANE_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    curl -fLO --retry 3 --retry-delay 2 https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_${CRANE_ARCH}.tar.gz && \
    tar xf go-containerregistry_Linux_${CRANE_ARCH}.tar.gz crane && \
    rm go-containerregistry_Linux_${CRANE_ARCH}.tar.gz && \
    mv crane /usr/bin/crane && \
    echo "Done install Crane" && \
    echo "Install Syft" && \
    : "${SYFT_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    curl -fLO --retry 3 --retry-delay 2 https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz && \
    tar xf syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz syft && \
    rm syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz && \
    mv syft /usr/bin/syft && \
    echo "Done install Syft" && \
    echo "Adding an up to date mime-types definition file" && \
    curl -fsSL --retry 3 --retry-delay 2 https://salsa.debian.org/debian/media-types/raw/master/mime.types -o /etc/mime.types && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
