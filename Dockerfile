FROM node:22-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@latest

ENV OPENCLAW_STATE_DIR=/data/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV NODE_ENV=production

RUN mkdir -p /data/.openclaw /data/workspace

EXPOSE 8080

CMD ["sh", "-c", "openclaw gateway run --bind lan --port ${PORT:-8080} --auth token --token ${OPENCLAW_GATEWAY_TOKEN} --allow-unconfigured"]