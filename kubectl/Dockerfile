FROM alpine:3.15.1
LABEL maintainer="opensource@ekino.com"

ARG HELM_DIFF_VERSION
ARG HELM_VERSION
ARG KUBECTL_VERSION
ARG KUBENT_VERSION
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

RUN wget https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_amd64 && \
    chmod +x kube-score_${KUBESCORE_VERSION}_linux_amd64 && \
    mv kube-score_${KUBESCORE_VERSION}_linux_amd64 /usr/bin/kube-score

RUN wget https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-amd64.tar.gz && \
    tar xf kubent-${KUBENT_VERSION}-linux-amd64.tar.gz && \
    mv kubent /usr/bin/kubent

RUN wget https://github.com/instrumenta/kubeval/releases/download/v${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin/kubeval

RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xf helm-v${HELM_VERSION}-linux-amd64.tar.gz && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm

RUN apk add git && \
    helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff
