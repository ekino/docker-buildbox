FROM alpine:3.24.1 AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG SONARSCANNER_HOME=/sonar-scanner
ARG VERSION

ENV PATH=${SONARSCANNER_HOME}/bin:${PATH}

# Tool versions, resolved from the GitHub API by image_builder.py
ARG SONARSCANNER_VERSION
RUN echo "Starting ..." && \
    apk --update upgrade && apk add curl gcompat make tzdata unzip openjdk21-jre jq && \
    echo "Done base install!" && \
    echo "Starting Sonar Scanner" && \
    : "${SONARSCANNER_VERSION:?must be passed as a build arg, resolved by image_builder.py}" && \
    echo "Using SonarScanner version: ${SONARSCANNER_VERSION}" && \
    curl -f --retry 3 --retry-delay 2 -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION} ${SONARSCANNER_HOME} && \
    echo "Done Sonar Scanner!" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
