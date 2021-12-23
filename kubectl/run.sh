#!/bin/sh

set -ex

echo "Starting AWS" && \
    apk add groff py-pip && \
    pip install -q -U awscli && \
    echo "Done AWS!"

apk add ca-certificates curl bash wget ncurses

if [ "${TARGETARCH}" = "arm64" ]; then
    KUBECTL_ARCH="darwin/arm64"
    KUBECTX_ARCH="linux_arm64"
else
    KUBECTL_ARCH="linux/amd64"
    KUBECTX_ARCH="linux_x86_64"
fi

curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${KUBECTL_ARCH}/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZATION_VERSION}/kustomize_v${KUSTOMIZATION_VERSION}_linux_${TARGETARCH}.tar.gz && \
    tar -xf kustomize_v${KUSTOMIZATION_VERSION}_linux_${TARGETARCH}.tar.gz && \
    mv ./kustomize /usr/bin/kustomize

wget https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_${KUBECTX_ARCH}.tar.gz && \
    tar -xf kubectx_v${KUBECTX_VERSION}_${KUBECTX_ARCH}.tar.gz && \
    mv kubectx /usr/bin/kubectx && \
    wget https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_${KUBECTX_ARCH}.tar.gz && \
    tar -xf kubens_v${KUBECTX_VERSION}_${KUBECTX_ARCH}.tar.gz && \
    mv kubens /usr/bin/kubens

wget https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_${TARGETARCH} && \
    chmod +x kube-score_${KUBESCORE_VERSION}_linux_${TARGETARCH} && \
    mv kube-score_${KUBESCORE_VERSION}_linux_${TARGETARCH} /usr/bin/kube-score

wget https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar xf kubent-${KUBENT_VERSION}-linux-${TARGETARCH}.tar.gz && \
    mv kubent /usr/bin/kubent

wget https://github.com/instrumenta/kubeval/releases/download/v${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin/kubeval

wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar xf helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz && rm helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz && \
    mv linux-${TARGETARCH}/helm /usr/local/bin/helm

apk add git && \
    helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff
