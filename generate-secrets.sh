#!/usr/bin/env bash

# Generate all secrets needed for element-docker-demo on Railway
# Run this script and copy-paste the output into your Railway variables

echo "=== element-docker-demo Railway Secrets Generator ==="
echo ""
echo "Copy these values into your Railway projects (Project 1 & 2)"
echo ""

# Project 1: Core Stack Secrets
echo "// ============================================"
echo "// PROJECT 1: matrix-core"
echo "// ============================================"
echo ""

echo "# Synapse Secrets (use these in Synapse service)"
echo "SYNAPSE_MACAROON_SECRET_KEY=$(openssl rand -hex 32)"
echo "SYNAPSE_FORM_SECRET=$(openssl rand -hex 32)"
echo "SYNAPSE_REGISTRATION_SECRET=$(openssl rand -hex 32)"
echo ""

echo "# MAS Secrets (use these in MAS service)"
echo "MAS_CLIENT_SECRET=$(openssl rand -hex 32)"
echo "MAS_ENCRYPTION_KEY=$(openssl rand -hex 32)"
echo "MAS_MATRIX_SHARED_SECRET=$(openssl rand -hex 32)"
echo ""

echo "# MAS Signing Key (RSA - IMPORTANT: copy entire block including BEGIN/END lines)"
echo "# Replace this entire block in MAS_SIGNING_KEY variable:"
openssl genrsa -out /tmp/mas_key.pem 2048 2>/dev/null
echo "MAS_SIGNING_KEY="
cat /tmp/mas_key.pem
rm /tmp/mas_key.pem
echo ""

echo "// ============================================"
echo "// PROJECT 2: matrix-clients"
echo "// ============================================"
echo ""

echo "# No additional secrets needed for Element Web/Call"
echo "# Just reference the Synapse URL from Project 1:"
echo "HOMESERVER_URL=https://synapse-<random>.up.railway.app"
echo "SERVER_NAME=synapse-<random>.up.railway.app"
echo ""

echo "// ============================================"
echo "// SAVE THESE BEFORE CLOSING THIS SCRIPT"
echo "// ============================================"
echo ""
echo "To use:"
echo "1. Run this script: bash generate-secrets.sh"
echo "2. Copy all output"
echo "3. Paste into Railway Project 1 variables"
echo "4. Set Project 2 variables with Synapse URL"
