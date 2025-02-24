FROM alpine:3.21.3 as base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG SONARSCANNER_HOME=/sonar-scanner
ARG SONARSCANNER_VERSION

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SONARSCANNER_HOME}/jre/lib/server \
    LD_PRELOAD=/lib/libgcompat.so.0 \
    PATH=${SONARSCANNER_HOME}/bin:${SONARSCANNER_HOME}/jre/bin:${PATH}

FROM base as base-amd64
ARG SONARSCANNER_ARCH="linux-x64"

FROM base as base-arm64
ARG SONARSCANNER_ARCH="linux-aarch64"

FROM base-$TARGETARCH
RUN echo "Starting ..." && \
    apk --update upgrade && apk add curl gcompat make tzdata unzip && \
    echo "Done base install!" && \
    echo "Starting Sonar Scanner" && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}-${SONARSCANNER_ARCH}.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION}-${SONARSCANNER_ARCH} ${SONARSCANNER_HOME} && \
    echo "Done Sonar Scanner!" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
