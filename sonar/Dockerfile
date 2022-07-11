FROM openjdk:8-jdk-alpine3.9 as base
LABEL maintainer="opensource@ekino.com"
ARG SONARSCANNER_VERSION
ARG GLIBC_VERSION
ARG ZLIB_VERSION
ENV PATH=/sonar-scanner/bin:$PATH

FROM base as base-amd64
ARG ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A{$ZLIB_VERSION}-x86_64.pkg.tar.xz"

FROM base as base-arm64
ARG ZLIB_URL="http://mirror.archlinuxarm.org/aarch64/core/zlib-1%3A{$ZLIB_VERSION}-aarch64.pkg.tar.xz"

FROM base-${TARGETARCH}
COPY run.sh .
RUN sh run.sh
