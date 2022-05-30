#!/bin/sh

set -ex

echo "Starting ..." &&
    apk --update upgrade && apk add curl make tzdata unzip &&
    if ["${TARGETARCH}" = "arm64"]; then
        ZLIB_URL="http://mirror.archlinuxarm.org/aarch64/core/zlib-1%3A{$ZLIB_VERSION}-aarch64.pkg.tar.xz" &&
            echo "Done base arm64 install!"
    else
        ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A{$ZLIB_VERSION}-x86_64.pkg.tar.xz" &&
            echo "Done base amd64 install!"
    fi

echo "Installing glib..." &&
    curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub &&
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O &&
    apk add -q glibc-${GLIBC_VERSION}.apk &&
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk &&
    curl -LfsS ${ZLIB_URL} -o /tmp/libz.tar.xz &&
    mkdir /tmp/libz &&
    tar -xf /tmp/libz.tar.xz -C /tmp/libz &&
    mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib &&
    echo "Installing glib done !"

echo " Installing sonar scanner..." &&
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}.zip &&
    unzip sonarscanner.zip &&
    rm sonarscanner.zip &&
    mv sonar-scanner-${SONARSCANNER_VERSION} sonar-scanner &&
    echo "Installing sonar scanner done !"

echo "Cleaning files..." &&
    rm -rf /tmp/* /var/cache/apk/* &&
    echo "Installing CI Helper done !"
