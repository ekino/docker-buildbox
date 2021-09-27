FROM adoptopenjdk/openjdk8:jdk8u282-b08-debian-slim
LABEL maintainer="Stephane Leclercq <leclercq@ekino.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ARG CI_HELPER_VERSION

COPY run.sh .
RUN sh run.sh
