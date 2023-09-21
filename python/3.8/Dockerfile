FROM python:3.8.18-slim-bullseye AS base

ARG TARGETARCH

FROM base AS base-amd64
ARG ARCH="x86_64"

FROM base AS base-arm64
ARG ARCH="aarch64"

FROM base-$TARGETARCH
COPY run.sh .
RUN sh run.sh
