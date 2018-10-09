# Based on: https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker
FROM node:10-slim
LABEL maintainer="Guillaume AMAT <guillaume.amat@ekino.com>"


ARG CI_HELPER_VERSION
ARG MODD_VERSION


# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y \
    && rm -rf /src/*.deb


RUN apt-get -qq clean && apt-get -qq update && \
    apt-get -qq -y install make && \

    echo "Install CI Helper" && \
    curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/linux-amd64-gitlab-ci-helper -o /usr/bin/ci-helper && \
    chmod 755 /usr/bin/ci-helper && \
    echo "Done install CI Helper" && \

    echo "Install Modd" && \
    curl -sSL https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar -xOvzf - modd-${MODD_VERSION}-linux64/modd > /usr/bin/modd  && \
    chmod 755 /usr/bin/modd && \
    echo "Done Install Modd" && \

    echo "Starting AWS" && \
    apt-get -qq -y install python-pip groff-base && \
    pip install -q -U awscli && \
    echo "Done AWS!" && \

    echo "Adding an up to date mime-types definition file" && \
    curl -sSL https://salsa.debian.org/debian/mime-support/raw/master/mime.types -o /etc/mime.types && \

    apt-get -qq -y autoremove && \
    apt-get -qq clean && apt-get -qq purge && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old && \
    rm -rf /usr/share/doc /usr/share/locale/[a-df-z]* /usr/share/locale/e[a-lo-z]* /usr/share/locale/en@* /usr/share/locale/en_GB


RUN npm i puppeteer
