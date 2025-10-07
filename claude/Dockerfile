FROM node:24-alpine3.21
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

RUN apk update && apk add --no-cache git curl bash jq

# Install GitLab CLI (glab)
ARG TARGETARCH
RUN case "$TARGETARCH" in \
    amd64) ARCH="linux_amd64" ;; \
    arm64) ARCH="linux_arm64" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    GLAB_VERSION=$(curl -s "https://gitlab.com/api/v4/projects/34675721/releases" | jq -r '.[0].tag_name' | sed 's/^v//') && \
    curl -L "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_${ARCH}.tar.gz" | tar -xz -C /tmp && \
    mv /tmp/bin/glab /usr/local/bin/glab && \
    chmod +x /usr/local/bin/glab && \
    rm -rf /tmp/bin

# Create claude user and group
RUN addgroup claude && \
    adduser -G claude -s /bin/sh -D claude

# Install claude-code globally
RUN npm install -g @anthropic-ai/claude-code

# Switch to claude user
USER claude:claude

# Set working directory to claude's home
WORKDIR /home/claude
