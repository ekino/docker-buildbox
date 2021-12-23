FROM docker:20.10.17-dind
LABEL maintainer="Rémi Marseille <marseille@ekino.com>"

ARG GLIBC_VERSION
ARG PIP_VERSION
ARG TASKFILE_VERSION
ARG TRIVY_VERSION
ENV PYTHON_PIP_VERSION ${PIP_VERSION}
ARG TARGETARCH

COPY requirements.txt run.sh ./
RUN sh run.sh
