#!/bin/sh

set -ex

apk add ca-certificates curl bash wget groff less ncurses unzip &&
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl &&
    chmod +x ./kubectl &&
    mv ./kubectl /usr/bin/kubectl

echo "install glibc compatibility for alpine" &&
    apk --no-cache add \
        binutils \
        curl &&
    curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub &&
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk &&
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk &&
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk &&
    apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
        glibc-i18n-${GLIBC_VER}.apk &&
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 &&
    curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip &&
    unzip awscliv2.zip &&
    aws/install &&
    rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/current/dist/aws_completer \
        /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/current/dist/awscli/examples \
        glibc-*.apk &&
    find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete &&
    apk --no-cache del \
        binutils \
        curl &&
    rm -rf /var/cache/apk/*

echo "installing kustomize..." &&
    wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZATION_VERSION}/kustomize_v${KUSTOMIZATION_VERSION}_linux_amd64.tar.gz &&
    tar -xf kustomize_v${KUSTOMIZATION_VERSION}_linux_amd64.tar.gz &&
    mv ./kustomize /usr/bin/kustomize

echo "installing kube-score..." &&
    wget https://github.com/zegl/kube-score/releases/download/v${KUBESCORE_VERSION}/kube-score_${KUBESCORE_VERSION}_linux_amd64 &&
    chmod +x kube-score_${KUBESCORE_VERSION}_linux_amd64 &&
    mv kube-score_${KUBESCORE_VERSION}_linux_amd64 /usr/bin/kube-score

echo "installing kubent..." &&
    wget https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-amd64.tar.gz &&
    tar xf kubent-${KUBENT_VERSION}-linux-amd64.tar.gz &&
    mv kubent /usr/bin/kubent

echo "installing trivy..." &&
    wget https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz &&
    tar xf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz &&
    mv trivy /usr/bin/trivy

echo "installing helm-diff..." &&
    apk add git &&
    helm plugin install --version $HELM_DIFF_VERSION https://github.com/databus23/helm-diff
