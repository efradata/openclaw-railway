#!/usr/bin/env bash
set -e

mkdir -p /data /data/workspace

if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  ORIGIN="https://${RAILWAY_PUBLIC_DOMAIN}"
  echo "Setting OpenClaw allowed origin: ${ORIGIN}"

  openclaw config set --json \
    gateway.controlUi.allowedOrigins \
    "[\"${ORIGIN}\"]"
fi

exec openclaw gateway run \
  --bind lan \
  --port "${PORT:-8080}" \
  --auth token \
  --token "${OPENCLAW_GATEWAY_TOKEN}" \
  --allow-unconfigured