FROM eclipse-temurin:11.0.19_7-jdk-jammy as base
LABEL maintainer="opensource@ekino.com"
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

FROM base as base-amd64
ARG AWSCLI_ARCH="linux-x86_64"

FROM base as base-arm64
ARG AWSCLI_ARCH="linux-aarch64"

FROM base-${TARGETARCH}
COPY run.sh .
RUN sh run.sh
