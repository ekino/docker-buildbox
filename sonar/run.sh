#!/bin/sh

set -ex

echo "Starting ..."

apk --update upgrade && apk add curl make tzdata unzip && \
    echo "Done base install!" && \

if [ "${TARGETARCH}" = "arm64" ]; then
    ZLIB_URL="http://mirror.archlinuxarm.org/aarch64/core/zlib-1%3A{$ZLIB_VERSION}-aarch64.pkg.tar.xz"
else
    ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A{$ZLIB_VERSION}-x86_64.pkg.tar.xz"
fi

echo "Starting Sonar Scanner"
    curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    apk add -q glibc-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk && \
    curl -LfsS ${ZLIB_URL} -o /tmp/libz.tar.xz && \
    mkdir /tmp/libz && \
    tar -xf /tmp/libz.tar.xz -C /tmp/libz && \
    mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION}-linux sonar-scanner && \
    echo "Done Sonar Scanner!"

echo "Install CI Helper"
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper"

echo "Cleaning files!"
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
