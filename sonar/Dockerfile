FROM alpine:3.16.0
LABEL maintainer="opensource@ekino.com"

ARG SONARSCANNER_VERSION

ENV PATH=/sonar-scanner/bin:/sonar-scanner/jre/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG GLIBC_VERSION
ARG SONARSCANNER_VERSION
ARG ZLIB_VERSION
ARG TARGETARCH

COPY run.sh .
RUN sh run.sh
