FROM node:22-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    bash \
    procps \
    python3 \
    jq \
    less \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@latest

RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    ln -s /root/.local/bin/uv /usr/local/bin/uv

ENV OPENCLAW_STATE_DIR=/data
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV NODE_ENV=production

RUN mkdir -p /data /data/workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
