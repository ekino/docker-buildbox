FROM python:3.12.1-slim-bullseye AS base

ARG TARGETARCH
ARG POETRY_VERSION
ARG POETRY_HOME

FROM base AS base-amd64
ARG ARCH="x86_64"

FROM base AS base-arm64
ARG ARCH="aarch64"

FROM base-$TARGETARCH
COPY run.sh .
RUN sh run.sh
