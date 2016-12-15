#!/usr/bin/env bash

IMAGE=${LANGUAGE}${VERSION}

if [ "${LANGUAGE}" == "php" ]; then
    docker run --rm ${IMAGE} php --version || exit 1;
    docker run --rm ${IMAGE} composer --version || exit 1;
fi

if [ "${LANGUAGE}" == "java" ]; then
    docker run --rm ${IMAGE} java -version || exit 1;
    docker run --rm ${IMAGE} mvn --version || exit 1;
fi

if [ "${LANGUAGE}" == "node" ]; then
    docker run --rm ${IMAGE} node --version || exit 1;
    docker run --rm ${IMAGE} npm --version  || exit 1;
    docker run --rm ${IMAGE} sass --version || exit 1;
fi
