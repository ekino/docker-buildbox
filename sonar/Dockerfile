FROM alpine:3.15.0
LABEL maintainer="Thomas Rabaix <rabaix@ekino.com>"

ARG SONARSCANNER_VERSION

ENV PATH=/sonar-scanner/bin:/sonar-scanner/jre/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG CI_HELPER_VERSION
ARG GLIBC_VERSION
ARG SONARSCANNER_VERSION
ARG ZLIB_VERSION
ARG TARGETARCH

COPY run.sh .
RUN sh run.sh
