FROM node:17-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    yarn

RUN echo "Linking the Chrome executable with all the known/used names" && \
    ln -s /usr/bin/chromium-browser /usr/bin/google-chrome && \
    ln -s /usr/bin/chromium-browser /usr/bin/google-chrome-stable && \
    ln -s /usr/bin/chromium-browser /usr/bin/google-chrome-unstable && \
    rm -rf /tmp/* /var/cache/apk/*

RUN mkdir /percy

WORKDIR /percy

COPY ["package.json", "./"]

RUN npm install

ENV PATH="/percy/node_modules/.bin:${PATH}"
