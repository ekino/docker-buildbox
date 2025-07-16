FROM alpine:3.22.1 AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG SONARSCANNER_HOME=/sonar-scanner
ARG SONARSCANNER_VERSION

ENV PATH=${SONARSCANNER_HOME}/bin:${PATH}

RUN echo "Starting ..." && \
    apk --update upgrade && apk add curl gcompat make tzdata unzip openjdk21-jre && \
    echo "Done base install!" && \
    echo "Starting Sonar Scanner" && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION} ${SONARSCANNER_HOME} && \
    echo "Done Sonar Scanner!" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
