FROM node:24-alpine3.22
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

RUN apk update && apk add --no-cache git curl bash jq python3 make g++

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

# Create reviewtools user and group
RUN addgroup reviewtools && \
    adduser -G reviewtools -s /bin/sh -D reviewtools

# Install claude-code, codex, and gemini globally
RUN npm install -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli

# Copy skills to user's .claude/skills directory
COPY --chown=reviewtools:reviewtools skills/ /home/reviewtools/.claude/skills/

# Switch to reviewtools user
USER reviewtools:reviewtools

# Set working directory
WORKDIR /home/reviewtools
