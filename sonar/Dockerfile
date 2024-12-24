FROM alpine:3.22.1 AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ARG SONARSCANNER_HOME=/sonar-scanner

ENV PATH=${SONARSCANNER_HOME}/bin:${PATH}

COPY config.yml /tmp/config.yml

RUN echo "Starting ..." && \
    apk --update upgrade && apk add curl gcompat make tzdata unzip openjdk21-jre yq && \
    echo "Done base install!" && \
    echo "Starting Sonar Scanner" && \
    VERSION_PREFIX=$(yq eval '.versions | keys | .[0]' /tmp/config.yml) && \
    SONARSCANNER_VERSION=$(curl -s https://api.github.com/repos/SonarSource/sonar-scanner-cli/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | grep "^${VERSION_PREFIX}\." | head -1) && \
    curl -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION} ${SONARSCANNER_HOME} && \
    echo "Done Sonar Scanner!" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
