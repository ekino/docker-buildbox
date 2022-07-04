FROM eclipse-temurin:17.0.3_7-jdk-focal as base
LABEL maintainer="opensource@ekino.com"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

FROM base as base-amd64
ARG AWSCLI_ARCH="x86_64"

FROM base as base-arm64
ARG AWSCLI_ARCH="aarch64"

FROM base-${TARGETARCH}
ARG AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip"
COPY run.sh .
RUN sh run.sh
