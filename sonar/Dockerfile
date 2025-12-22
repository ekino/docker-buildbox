FROM alpine:3.23.2 AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG SONARSCANNER_HOME=/sonar-scanner
ARG VERSION

ENV PATH=${SONARSCANNER_HOME}/bin:${PATH}

RUN echo "Starting ..." && \
    apk --update upgrade && apk add curl gcompat make tzdata unzip openjdk21-jre jq && \
    echo "Done base install!" && \
    echo "Starting Sonar Scanner" && \
    echo "Fetching latest version for major version ${VERSION}..." && \
    SONARSCANNER_VERSION=$(curl -s https://api.github.com/repos/SonarSource/sonar-scanner-cli/releases | \
        jq -r --arg major "${VERSION}" \
        '[.[] | select(.tag_name | startswith($major)) | .tag_name] | sort_by(. | split(".") | map(tonumber)) | last') && \
    echo "Using SonarScanner version: ${SONARSCANNER_VERSION}" && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION} ${SONARSCANNER_HOME} && \
    echo "Done Sonar Scanner!" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
