FROM ruby:2.6.10-alpine
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

RUN echo "Starting ..." && \
    apk add --update curl git make openssh-client rsync tzdata && \
    echo "Done base install!" && \

    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \

    echo "Done!"
