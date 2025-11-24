FROM debian:trixie-slim AS base
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    NVM_DIR=/root/.nvm \
    PATH=/root/.nvm/versions/node/current/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ARG VERSION

FROM base AS base-amd64
ARG AWSCLI_ARCH="linux-x86_64"

FROM base AS base-arm64
ARG AWSCLI_ARCH="linux-aarch64"

FROM base-$TARGETARCH
RUN echo "Starting ..." && \
    apt-get -qq clean && apt-get -qq update && \
    apt-get -qq -y install libssl-dev curl git imagemagick make gnupg \
    libmcrypt-dev libreadline-dev ruby-full openssh-client ocaml libelf-dev bzip2 gcc g++ jq && \
    gem install rb-inotify:'~> 0.9.10' sass --verbose && \
    gem install scss_lint:'~> 0.57.1' --verbose && \
    echo "Done base install!" && \
    echo "Install Taskfile" && \
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d && \
    echo "Done Install Taskfile" && \
    echo "Starting Javascript..." && \
    echo "Fetching latest NVM version..." && \
    LATEST_NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name' | sed 's/^v//') && \
    echo "Using NVM version: ${LATEST_NVM_VERSION}" && \
    echo "Fetching latest Node.js version for major version ${VERSION}..." && \
    LATEST_NODE_VERSION=$(curl -s https://api.github.com/repos/nodejs/node/releases | jq -r --arg major "v${VERSION}" '[.[] | select(.tag_name | startswith($major)) | .tag_name] | sort_by(. | ltrimstr("v") | split(".") | map(tonumber)) | reverse | .[0]' | sed 's/^v//') && \
    echo "Using Node.js version: ${LATEST_NODE_VERSION}" && \
    git clone https://github.com/nvm-sh/nvm.git /root/.nvm && cd /root/.nvm && git checkout v${LATEST_NVM_VERSION} && \
    . /root/.nvm/nvm.sh && \
    nvm install ${LATEST_NODE_VERSION} && nvm alias default ${LATEST_NODE_VERSION} && \
    ln -s /root/.nvm/versions/node/v${LATEST_NODE_VERSION} /root/.nvm/versions/node/current && \
    echo "Fetching latest NPM version..." && \
    LATEST_NPM_VERSION=$(curl -s https://api.github.com/repos/npm/cli/releases/latest | jq -r '.tag_name' | sed 's/^v//') && \
    echo "Using NPM version: ${LATEST_NPM_VERSION}" && \
    npm install -g npm@${LATEST_NPM_VERSION} && \
    curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn --no-install-recommends && \
    echo "Done JS!" && \
    echo "Starting AWS" && \
    curl https://awscli.amazonaws.com/awscli-exe-${AWSCLI_ARCH}.zip -o awscliv2.zip && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip && rm -rf aws && \
    echo "Done installing AWS" && \
    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* && \
    apt-get -qq -y remove --purge emacsen-common fakeroot file firebird3.0-common firebird3.0-common-doc \
    firebird3.0-server firebird3.0-server-core man-db manpages manpages-dev \
    default-mysql-client mysql-common default-mysql-server default-mysql-server-core odbcinst odbcinst1debian2 \
    patch po-debconf psmisc xauth xtrans-dev xz-utils zlib1g-dev && \
    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB && \
    echo "Done!"
