FROM node:24-alpine3.21
LABEL maintainer="opensource@ekino.com"
LABEL org.opencontainers.image.source="https://github.com/ekino/docker-buildbox/"

# Create claude user and group
RUN addgroup claude && \
    adduser -G claude -s /bin/sh -D claude

# Install claude-code globally
RUN npm install -g @anthropic-ai/claude-code

# Switch to claude user
USER claude:claude

# Set working directory to claude's home
WORKDIR /home/claude

# Set default command
CMD ["claude", "--help"]
