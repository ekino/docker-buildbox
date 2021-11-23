FROM node:17-slim

RUN apt-get update \
    && apt-get install -y wget gnupg build-essential python3 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y \
        google-chrome-stable \
        fonts-ipafont-gothic \
        fonts-wqy-zenhei \
        fonts-thai-tlwg \
        fonts-kacst \
        fonts-freefont-ttf \
        libxss1 \
        libxshmfence-dev \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /percy

WORKDIR /percy

COPY ["package.json", "./"]

RUN npm install

ENV PATH="/percy/node_modules/.bin:${PATH}"
