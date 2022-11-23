FROM python:3.11.0-slim-buster as base

LABEL maintainer="opensource@ekino.com"

ARG HELM_DIFF_VERSION
ARG HELM_VERSION
ARG KUBECTL_VERSION
ARG KUSTOMIZATION_VERSION
ARG TRIVY_VERSION

FROM base as base-amd64
ARG AWSCLI_ARCH="x86_64"
ARG HELM_ARCH="linux-amd64"
ARG KUBECTL_ARCH="linux/amd64"
ARG KUSTOMIZATION_ARCH="linux_amd64"
ARG TRIVY_ARCH="Linux-64bit"

FROM base as base-arm64
ARG AWSCLI_ARCH="aarch64"
ARG HELM_ARCH="linux-arm64"
ARG KUBECTL_ARCH="linux/arm64"
ARG KUSTOMIZATION_ARCH="linux_arm64"
ARG TRIVY_ARCH="Linux-ARM64"

FROM base-$TARGETARCH

RUN apt-get update -qq && apt-get install -qq -y curl git gcc jq\
    && pip install -U pip \
    && pip install pipenv azure-cli \
    && apt-get remove -y gcc && apt-get -qq -y autoremove \
    && apt-get -qq -y clean && apt-get -y -qq purge\
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/${KUBECTL_ARCH}/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZATION_VERSION}/kustomize_v${KUSTOMIZATION_VERSION}_${KUSTOMIZATION_ARCH}.tar.gz && \
    tar -xf kustomize_v${KUSTOMIZATION_VERSION}_${KUSTOMIZATION_ARCH}.tar.gz && \
    rm kustomize_v${KUSTOMIZATION_VERSION}_${KUSTOMIZATION_ARCH}.tar.gz && \
    mv ./kustomize /usr/bin/kustomize

RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && \
    tar xf helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && rm helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && \
    mv ${HELM_ARCH}/helm /usr/local/bin/helm

RUN curl -LO https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    tar xf trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    rm trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    mv trivy /usr/bin/trivy

RUN helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff
