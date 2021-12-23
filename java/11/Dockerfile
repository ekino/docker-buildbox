FROM eclipse-temurin:11.0.12_7-jdk-focal
LABEL maintainer="Stephane Leclercq <leclercq@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION
ARG TARGETARCH

COPY run.sh .
RUN sh run.sh
