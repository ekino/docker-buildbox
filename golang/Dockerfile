FROM golang:1.11
LABEL maintainer="Raphaël Benitte <raphael.benitte@ekino.com>"

ARG GLIDE_VERSION
ARG CI_HELPER_VERSION
ARG MODD_VERSION

RUN echo "Starting...\n" && \

    echo "Installing AWS CLI..." && \
    apt-get update -q && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Successfully installed AWS CLI\n" && \

    echo "Installing CI Helper..." && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Successfully installed CI Helper\n" && \

    echo "Installing glide..." && \
    mkdir -p /tmp/glide && \
    curl -sSL https://github.com/Masterminds/glide/releases/download/${GLIDE_VERSION}/glide-${GLIDE_VERSION}-linux-amd64.tar.gz -o /tmp/glide/glide-${GLIDE_VERSION}-linux-amd64.tar.gz && \
    tar xf /tmp/glide/glide-${GLIDE_VERSION}-linux-amd64.tar.gz -C /tmp/glide && \
    mv /tmp/glide/linux-amd64/glide /usr/bin && \
    chmod 755 /usr/bin/glide && \
    rm -rf /tmp/glide && \
    echo "Successfully installed glide\n" && \

    echo "Installing gin helper..." && \
    go get github.com/codegangsta/gin && \
    echo "Successfully installed gin helper\n" && \

    echo "Installing Modd..." && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd  && \
    chmod 755 /usr/bin/modd && \
    echo "Successfully installed Modd\n" && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \

    echo "Done!"
