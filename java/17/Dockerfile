FROM eclipse-temurin:17.0.2_8-jdk-focal
LABEL maintainer="ekino"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION

COPY run.sh .
RUN sh run.sh
