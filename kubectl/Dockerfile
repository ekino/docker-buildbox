FROM alpine:3.10
LABEL maintainer="Maxime Sibellas <maxime.sibellas@ekino.com>"

ARG KUBECTL_VERSION
ARG KUBECTX_VERSION
ARG KUBESCORE_VERSION
ARG KUBEVAL_VERSION
ARG KUSTOMIZATION_VERSION

ENV PATH="${PATH}:/usr/bin"

RUN apk add ca-certificates curl bash wget ncurses && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZATION_VERSION}/kustomize_${KUSTOMIZATION_VERSION}_linux_amd64 && \
    chmod +x ./kustomize_${KUSTOMIZATION_VERSION}_linux_amd64 && \
    mv ./kustomize_${KUSTOMIZATION_VERSION}_linux_amd64 /usr/bin/kustomize

RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/v${KUBECTX_VERSION}/kubectx && \
    chmod +x kubectx && \
    mv kubectx /usr/bin/kubectx && \
    wget https://raw.githubusercontent.com/ahmetb/kubectx/v${KUBECTX_VERSION}/kubens && \
    chmod +x kubens && \
    mv kubens /usr/bin/kubens

RUN wget https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_amd64 && \
    chmod +x kube-score_${KUBESCORE_VERSION}_linux_amd64 && \
    mv kube-score_${KUBESCORE_VERSION}_linux_amd64 /usr/bin/kube-score

RUN wget https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin/kubeval
