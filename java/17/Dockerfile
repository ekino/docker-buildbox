FROM eclipse-temurin:17_35-jdk-focal
LABEL maintainer="Stephane Leclercq <leclercq@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION
ARG TARGETARCH

COPY run.sh .
RUN sh run.sh
