FROM eclipse-temurin:11.0.14.1_1-jdk-focal
LABEL maintainer="opensource@ekino.com"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION

COPY run.sh .
RUN sh run.sh
