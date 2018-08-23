FROM node:{{NODE_VERSION}}
LABEL maintainer="Sebastien Augereau <sebastien.augereau@ekino.com>"

ARG CI_HELPER_VERSION
ARG SONARSCANNER_VERSION
ARG GLIBC_VERSION

ENV PATH=/sonar-scanner/bin:/sonar-scanner/jre/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN echo "Starting ..." && \
    apk --update upgrade && apk add --no-cache curl unzip  && \

    echo "Done base install!" && \

    echo "Starting Sonar Scanner" && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O && \
    apk add -q glibc-${GLIBC_VERSION}.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk && \
    curl --insecure -o ./sonarscanner.zip -L https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONARSCANNER_VERSION}-linux sonar-scanner && \
    echo "Done Sonar Scanner!" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "Done!"
