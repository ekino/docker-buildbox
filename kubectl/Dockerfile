FROM alpine:3.14.3
LABEL maintainer="Maxime Sibellas <maxime.sibellas@ekino.com>"

ARG EKSCTL_VERSION
ARG HELM_DIFF_VERSION
ARG HELM_VERSION
ARG HELMFILE_VERSION
ARG KUBECTL_VERSION
ARG KUBECTX_VERSION
ARG KUBESCORE_VERSION
ARG KUBEVAL_VERSION
ARG KUSTOMIZATION_VERSION

ENV PATH="${PATH}:/usr/bin"

RUN echo "Starting AWS" && \
    apk add groff py-pip && \
    pip install -q -U awscli && \
    echo "Done AWS!"

RUN apk add ca-certificates curl bash wget ncurses && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZATION_VERSION}/kustomize_v${KUSTOMIZATION_VERSION}_linux_amd64.tar.gz && \
    tar -xf kustomize_v${KUSTOMIZATION_VERSION}_linux_amd64.tar.gz && \
    mv ./kustomize /usr/bin/kustomize

RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/v${KUBECTX_VERSION}/kubectx && \
    chmod +x kubectx && \
    mv kubectx /usr/bin/kubectx && \
    wget https://raw.githubusercontent.com/ahmetb/kubectx/v${KUBECTX_VERSION}/kubens && \
    chmod +x kubens && \
    mv kubens /usr/bin/kubens

RUN wget https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_amd64 && \
    chmod +x kube-score_${KUBESCORE_VERSION}_linux_amd64 && \
    mv kube-score_${KUBESCORE_VERSION}_linux_amd64 /usr/bin/kube-score

RUN wget https://github.com/instrumenta/kubeval/releases/download/v${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin/kubeval

RUN wget https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz && \
    tar xf eksctl_$(uname -s)_amd64.tar.gz && \
    mv eksctl /usr/local/bin/eksctl

RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xf helm-v${HELM_VERSION}-linux-amd64.tar.gz && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm

RUN wget https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x helmfile_linux_amd64 && \
    mv helmfile_linux_amd64 /usr/bin/helmfile

RUN apk add git && \
    helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff
