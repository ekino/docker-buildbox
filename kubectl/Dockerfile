FROM alpine:3.16.2 as base
LABEL maintainer="opensource@ekino.com"
ARG HELM_DIFF_VERSION
ARG HELM_VERSION
ARG KUBECTL_VERSION
ARG KUBENT_VERSION
ARG KUBESCORE_VERSION
ARG KUBEVAL_VERSION
ARG KUSTOMIZATION_VERSION
ARG TRIVY_VERSION
ENV PATH="${PATH}:/usr/bin"

FROM base as base-amd64
ARG KUBECTL_ARCH="linux/amd64"
ARG AWSCLI_ARCH="linux-x86_64"
ARG KUSTOMIZATION_ARCH="linux_amd64"
ARG KUBESCORE_ARCH="linux_amd64"
ARG KUBENT_ARCH="linux-amd64"
ARG KUBEVAL_ARCH="linux_amd64"
ARG HELM_ARCH="linux-amd64"
ARG TRIVY_ARCH="Linux-64bit"

FROM base as base-arm64
ARG KUBECTL_ARCH="linux/arm64"
ARG AWSCLI_ARCH="linux-aarch64"
ARG KUSTOMIZATION_ARCH="linux_arm64"
ARG KUBESCORE_ARCH="linux_arm64"
ARG KUBENT_ARCH="linux-arm64"
ARG KUBEVAL_ARCH="linux_arm64"
ARG HELM_ARCH="linux-arm64"
ARG TRIVY_ARCH="Linux-ARM64"

FROM base-${TARGETARCH}
RUN apk add ca-certificates curl bash wget groff less ncurses unzip && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/${KUBECTL_ARCH}/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl
# install glibc & aws compatibility for alpine
ENV GLIBC_VER=2.31-r0
# install glibc compatibility for alpine
RUN apk --no-cache add \
        binutils \
        curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
        glibc-i18n-${GLIBC_VER}.apk \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && curl https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/current/dist/aws_completer \
        /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/current/dist/awscli/examples \
        glibc-*.apk \
    && find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete \
    && apk --no-cache del \
        binutils \
        curl \
    && rm -rf /var/cache/apk/*
RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZATION_VERSION}/kustomize_v${KUSTOMIZATION_VERSION}_${KUSTOMIZATION_ARCH}.tar.gz && \
    tar -xf kustomize_v${KUSTOMIZATION_VERSION}_${KUSTOMIZATION_ARCH}.tar.gz && \
    mv ./kustomize /usr/bin/kustomize
RUN wget https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_${KUBESCORE_ARCH} && \
    chmod +x kube-score_${KUBESCORE_VERSION}_${KUBESCORE_ARCH}  && \
    mv kube-score_${KUBESCORE_VERSION}_${KUBESCORE_ARCH} /usr/bin/kube-score
RUN wget https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-${KUBENT_ARCH}.tar.gz && \
    tar xf kubent-${KUBENT_VERSION}-${KUBENT_ARCH}.tar.gz && \
    mv kubent /usr/bin/kubent
RUN wget https://github.com/jenkins-x-plugins/kubeval/releases/download/v${KUBEVAL_VERSION}/kubeval_${KUBEVAL_VERSION}_${KUBEVAL_ARCH}.tar.gz && \
    tar xf kubeval_${KUBEVAL_VERSION}_${KUBEVAL_ARCH}.tar.gz && \
    mv kubeval /usr/local/bin/kubeval
RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && \
    tar xf helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && rm helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz && \
    mv ${HELM_ARCH}/helm /usr/local/bin/helm
RUN wget https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    tar xf trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz && \
    mv trivy /usr/bin/trivy
RUN apk add git && \
    helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff
