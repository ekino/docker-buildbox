FROM gitlab/dind
MAINTAINER Hugo Briand <briand@ekino.com>

ARG CI_HELPER_VERSION
ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION

RUN echo "Install AWS Cli" && \
    apt-get update -q && \
    apt-get install -qy \
      build-essential \
      python-pip \
      groff-base && \
    pip install awscli && \
    echo "Done installing AWS Cli" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done installing CI Helper" && \

    echo "Update Docker" && \
    apt-get -y remove docker docker-engine docker.io && \
    apt-get -qy install apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" && \
    apt-get -q update && \
    apt-get -qy install docker-ce=${DOCKER_VERSION} && \
    docker --version && \

    echo "Update Docker Compose" && \
    rm -f /usr/local/bin/docker-compose && \
    curl -sSL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version && \

    echo "Clean up" && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    echo "Done cleaning up"
