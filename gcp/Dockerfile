# check=skip=InvalidDefaultArgInFrom
# UV_VERSION is resolved from the GitHub API by image_builder.py. It has to be a
# global ARG, declared before the first FROM: FROM can expand one, but
# `COPY --from` cannot expand variables at all, so uv arrives through a named
# stage below. It deliberately has no default, so that a bare `docker build`
# fails instead of silently pulling an unpinned uv - which is the lint the
# check directive above skips.
ARG UV_VERSION

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM python:3.14.7-slim-trixie AS base

LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

FROM base AS base-amd64
ARG HELM_ARCH="linux-amd64"
ARG KUBECTL_ARCH="amd64"
ARG KUSTOMIZE_ARCH="linux_amd64"
ARG TRIVY_ARCH="Linux-64bit"
ARG TERRAGRUNT_ARCH="amd64"
ARG INFRACOST_ARCH="amd64"
ARG JQ_ARCH="amd64"

FROM base AS base-arm64
ARG HELM_ARCH="linux-arm64"
ARG KUBECTL_ARCH="arm64"
ARG KUSTOMIZE_ARCH="linux_arm64"
ARG TRIVY_ARCH="Linux-ARM64"
ARG TERRAGRUNT_ARCH="arm64"
ARG INFRACOST_ARCH="arm64"
ARG JQ_ARCH="arm64"

FROM base-$TARGETARCH

# Tool versions, resolved from the GitHub API by image_builder.py
ARG HELM_DIFF_VERSION
ARG HELM_VERSION
ARG INFRACOST_VERSION
ARG KUSTOMIZE_VERSION
ARG TERRAGRUNT_VERSION
ARG TRIVY_VERSION
# uv installs the Python packages below, and stays in the image as a tool. The
# distroless binaries are statically linked, so they are portable.
COPY --from=uv /uv /uvx /usr/local/bin/

RUN apt-get update -qq && apt-get install -qq -y apt-transport-https ca-certificates gnupg curl git zip unzip jq wget \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update -qq \
    && apt-get install -qq -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin \
    && apt-get -qq -y autoremove \
    && apt-get -qq -y clean && apt-get -y -qq purge \
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old \
    && wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${JQ_ARCH} -O /usr/bin/yq \
    && chmod +x /usr/bin/yq \
    && uv pip install --system --no-cache pipenv \
    # Installing kubectl
    && curl -fLO --retry 3 --retry-delay 2 "https://dl.k8s.io/release/$(curl -fL -s --retry 3 --retry-delay 2 https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL_ARCH}/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/bin/kubectl \
    # Downloading latest kustomize
    && : "${KUSTOMIZE_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && curl -fLO --retry 3 --retry-delay 2 https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz \
    && tar -xf kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz \
    && rm kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz \
    && mv ./kustomize /usr/bin/kustomize \
    # Downloading latest trivy
    && : "${TRIVY_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && curl -fLO --retry 3 --retry-delay 2 https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz \
    && tar xf trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz \
    && rm trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz \
    && mv trivy /usr/bin/trivy \
    # Downloading latest helm (3.x.x)
    && : "${HELM_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && curl -fLO --retry 3 --retry-delay 2 https://get.helm.sh/helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz \
    && tar xf helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && rm helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz \
    && mv ${HELM_ARCH}/helm /usr/local/bin/helm \
    # Downloading latest helm diff plugin
    && : "${HELM_DIFF_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff \
    # Downloading latest terragrunt
    && : "${TERRAGRUNT_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && curl -fLO --retry 3 --retry-delay 2 https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TERRAGRUNT_ARCH} \
    && mv terragrunt_linux_${TERRAGRUNT_ARCH} /usr/bin/terragrunt \
    && chmod +x /usr/bin/terragrunt \
    # Downloading latest infracost
    && : "${INFRACOST_VERSION:?must be passed as a build arg, resolved by image_builder.py}" \
    && curl -fLO --retry 3 --retry-delay 2 https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-${INFRACOST_ARCH}.tar.gz \
    && tar xvf infracost-linux-${INFRACOST_ARCH}.tar.gz \
    && mv infracost-linux-${INFRACOST_ARCH} /usr/bin/infracost \
    && curl -fLO --retry 3 --retry-delay 2 https://raw.githubusercontent.com/infracost/infracost/v${INFRACOST_VERSION}/scripts/ci/diff.sh \
    && mv diff.sh /opt/diff.sh \
    && chmod +x /opt/diff.sh \
    && git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin
