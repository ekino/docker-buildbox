FROM eclipse-temurin:8u302-b08-jdk-focal
LABEL maintainer="Stephane Leclercq <leclercq@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION

COPY run.sh .
RUN sh run.sh
