FROM gitlab/dind
MAINTAINER Hugo Briand <briand@ekino.com>

RUN echo "Install AWS Cli" && \
    apt-get update -q && \
    apt-get install -qy \
      build-essential \
      python-pip \
      groff-base && \
    pip install awscli && \
    echo "Done installing AWS Cli" && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/0.0.1/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done installing CI Helper" && \

    echo "Clean up" && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    echo "Done cleaning up"
