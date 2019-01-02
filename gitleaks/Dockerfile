FROM zricethezav/gitleaks:v1.22.0

ARG CI_HELPER_VERSION

RUN echo "Install curl" && \
    apk add --no-cache curl && \
    echo "Done install curl" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Done!"