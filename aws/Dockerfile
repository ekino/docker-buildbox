FROM python:3.13.5-slim-bullseye AS base
LABEL maintainer="Frank Pavageau <fpavageau@ekino.com>"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

FROM base AS base-amd64
ARG AWSCLI_ARCH="x86_64"
ARG HELM_ARCH="linux-amd64"
ARG KUBECTL_ARCH="amd64"
ARG KUSTOMIZE_ARCH="linux_amd64"
ARG TRIVY_ARCH="Linux-64bit"
ARG TERRAGRUNT_ARCH="amd64"
ARG INFRACOST_ARCH="amd64"
ARG JQ_ARCH="amd64"

FROM base AS base-arm64
ARG AWSCLI_ARCH="aarch64"
ARG HELM_ARCH="linux-arm64"
ARG KUBECTL_ARCH="arm64"
ARG KUSTOMIZE_ARCH="linux_arm64"
ARG TRIVY_ARCH="Linux-ARM64"
ARG TERRAGRUNT_ARCH="arm64"
ARG INFRACOST_ARCH="arm64"
ARG JQ_ARCH="arm64"

FROM base-$TARGETARCH
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"

RUN apt-get update -qq && apt-get install -qq -y curl git zip jq wget && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    # Adding an up to date mime-types definition file
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    # Adding yq bin
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${JQ_ARCH} -O /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    pip install -U pip && \
    pip install pipenv && \
    # Installing AWS Cli
    curl ${AWSCLI_URL} -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && rm -rf aws && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL_ARCH}/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    # Downloading latest kustomize
    KUSTOMIZE_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep '"tag_name":' | sed -E 's/.*"kustomize\/v([^"]+)".*/\1/') && \
    curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz && \
    tar -xf kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz && \
    rm kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz && \
    mv ./kustomize /usr/bin/kustomize && \
    # Downloading latest helm
    HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && \
    tar xf helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && rm helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && \
    mv ${HELM_ARCH}/helm /usr/local/bin/helm && \
    # Downloading latest helm diff plugin
    HELM_DIFF_VERSION=$(curl -s https://api.github.com/repos/databus23/helm-diff/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff && \
    # Downloading latest trivy
    TRIVY_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    tar xf trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    rm trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    mv trivy /usr/bin/trivy && \
    # Downloading latest terragrunt
    TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TERRAGRUNT_ARCH} && \
    mv terragrunt_linux_${TERRAGRUNT_ARCH} /usr/bin/terragrunt && \
    chmod +x /usr/bin/terragrunt && \
    # Downloading latest infracost
    INFRACOST_VERSION=$(curl -s https://api.github.com/repos/infracost/infracost/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -LO https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-${INFRACOST_ARCH}.tar.gz && \
    tar xvf infracost-linux-${INFRACOST_ARCH}.tar.gz && \
    mv infracost-linux-${INFRACOST_ARCH} /usr/bin/infracost && \
    curl -LO https://raw.githubusercontent.com/infracost/infracost/v${INFRACOST_VERSION}/scripts/ci/diff.sh && \
    mv diff.sh /opt/diff.sh && \
    chmod +x /opt/diff.sh && \
    git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin
