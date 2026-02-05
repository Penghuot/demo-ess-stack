#!/bin/bash
set -euo pipefail

: "${MAS_PUBLIC_BASE:?Must set MAS_PUBLIC_BASE}"
: "${MAS_DATABASE_URI:?Must set MAS_DATABASE_URI}"
: "${MAS_MATRIX_HOMESERVER:?Must set MAS_MATRIX_HOMESERVER}"
: "${MAS_MATRIX_ENDPOINT:?Must set MAS_MATRIX_ENDPOINT}"
: "${MAS_CLIENT_ID:?Must set MAS_CLIENT_ID}"
: "${MAS_CLIENT_SECRET:?Must set MAS_CLIENT_SECRET}"
: "${MAS_ENCRYPTION_KEY:?Must set MAS_ENCRYPTION_KEY}"
: "${MAS_SIGNING_KEY:?Must set MAS_SIGNING_KEY (PEM, multi-line)}"
: "${MAS_EMAIL_DOMAIN:?Must set MAS_EMAIL_DOMAIN}"

# Strip optional surrounding quotes from client IDs
MAS_CLIENT_ID="${MAS_CLIENT_ID%\"}"
MAS_CLIENT_ID="${MAS_CLIENT_ID#\"}"

# Indent PEM key for YAML block
printf '%s\n' "${MAS_SIGNING_KEY}" | sed 's/^/        /' > /tmp/signing_key.txt

mkdir -p /data

# Render config.yaml from template
sed \
  -e "s#{{MAS_PUBLIC_BASE}}#${MAS_PUBLIC_BASE}#g" \
  -e "s#{{MAS_DATABASE_URI}}#${MAS_DATABASE_URI}#g" \
  -e "s#{{MAS_MATRIX_HOMESERVER}}#${MAS_MATRIX_HOMESERVER}#g" \
  -e "s#{{MAS_MATRIX_ENDPOINT}}#${MAS_MATRIX_ENDPOINT}#g" \
  -e "s#{{MAS_CLIENT_ID}}#${MAS_CLIENT_ID}#g" \
  -e "s#{{MAS_CLIENT_SECRET}}#${MAS_CLIENT_SECRET}#g" \
  -e "s#{{MAS_ENCRYPTION_KEY}}#${MAS_ENCRYPTION_KEY}#g" \
  -e "s#{{MAS_EMAIL_DOMAIN}}#${MAS_EMAIL_DOMAIN}#g" \
  /data/config.template.yaml \
| sed "/{{MAS_SIGNING_KEY_INDENTED}}/{
    r /tmp/signing_key.txt
    d
}" > /data/config.yaml

export MAS_CONFIG_PATH=/data/config.yaml

exec mas-cli server
