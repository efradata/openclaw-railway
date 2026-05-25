#!/usr/bin/env bash
set -e

mkdir -p /data /data/workspace

if [ -z "${OPENCLAW_GATEWAY_TOKEN:-}" ]; then
  echo "ERROR: OPENCLAW_GATEWAY_TOKEN is not set. Define a fixed secure token in Railway variables." >&2
  exit 1
fi

if [ "${OPENCLAW_GATEWAY_TOKEN}" = '${{secret()}}' ]; then
  echo "ERROR: OPENCLAW_GATEWAY_TOKEN must be a fixed value, not the literal \${{secret()}} placeholder." >&2
  exit 1
fi

if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  ORIGIN="https://${RAILWAY_PUBLIC_DOMAIN}"
  echo "Setting OpenClaw allowed origin: ${ORIGIN}"

  openclaw config set --json \
    gateway.controlUi.allowedOrigins \
    "[\"${ORIGIN}\"]"
fi

if [ "${CLEAN_OPENCLAW_CODEX_PLUGIN:-false}" = "true" ]; then
  echo "Cleaning stale @openclaw/codex plugin from /data..."
  rm -rf /data/npm/node_modules/@openclaw/codex
  rm -f /data/npm/package-lock.json
fi

exec openclaw gateway run \
  --bind lan \
  --port "${PORT:-8080}" \
  --auth token \
  --token "${OPENCLAW_GATEWAY_TOKEN}" \
  --allow-unconfigured
