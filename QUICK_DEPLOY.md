# Railway Deployment Guide - element-docker-demo

## Quick Summary

| Project | Services | Purpose |
|---------|----------|---------|
| **matrix-core** | PostgreSQL, Synapse, MAS, nginx | Backend/Auth |
| **matrix-clients** | Element Web, Element Call, LiveKit | Frontend/UI |

---

## Project 1: matrix-core

### Variables for Railway

```env
# PostgreSQL (Railway creates this automatically)
DATABASE_URL=postgresql://user:pass@host:5432/postgres

# Synapse Service
SYNAPSE_SERVER_NAME=your-matrix-domain.com
SYNAPSE_PUBLIC_BASEURL=https://your-matrix-domain.com/
SYNAPSE_DB_USER=postgres
SYNAPSE_DB_PASSWORD=<copy from PostgreSQL service>
SYNAPSE_DB_HOST=<copy from PostgreSQL service internal host>
SYNAPSE_DB_PORT=5432
SYNAPSE_DB_NAME=synapse
SYNAPSE_MACAROON_SECRET_KEY=<run: openssl rand -hex 32>
SYNAPSE_FORM_SECRET=<run: openssl rand -hex 32>
SYNAPSE_REGISTRATION_SECRET=<run: openssl rand -hex 32>
LOG_LEVEL=INFO

# MAS Service  
MAS_PUBLIC_BASE=https://your-mas-domain.com/
MAS_DATABASE_URI=<same as DATABASE_URL but different DB: postgresql://user:pass@host:5432/mas>
MAS_MATRIX_HOMESERVER=https://your-matrix-domain.com/
MAS_MATRIX_ENDPOINT=http://synapse.railway.internal:8008
MAS_CLIENT_ID=0000000000000000000SYNAPSE
MAS_CLIENT_SECRET=<run: openssl rand -hex 32>
MAS_ENCRYPTION_KEY=<run: openssl rand -hex 32>
MAS_SIGNING_KEY=<paste RSA private key - see instructions below>
MAS_MATRIX_SHARED_SECRET=<run: openssl rand -hex 32>
MAS_EMAIL_DOMAIN=noreply.railway.app
```

### Generate RSA Signing Key for MAS

```bash
# Run locally
openssl genrsa -out mas_signing_key.pem 2048

# Read the output
cat mas_signing_key.pem

# Copy the ENTIRE output (including -----BEGIN and -----END lines) 
# into MAS_SIGNING_KEY variable in Railway
```

---

## Project 2: matrix-clients

### Variables for Railway

```env
# Element Web
HOMESERVER_URL=https://your-matrix-domain.com/
SERVER_NAME=your-matrix-domain.com
ELEMENT_DEFAULT_THEME=dark

# Element Call (optional)
VITE_HOMESERVER_URL=https://your-matrix-domain.com/
SFU_URL=https://your-livekit-domain.com/

# LiveKit (optional)
LIVEKIT_API_KEY=<generate>
LIVEKIT_API_SECRET=<generate>
LIVEKIT_URL=ws://livekit:7880
```

---

## Deployment Order

1. **Project 1 First:**
   - Add PostgreSQL
   - Deploy Synapse (wait for healthy)
   - Deploy MAS (wait for healthy)
   - Deploy nginx (routes to Synapse/MAS)

2. **Project 2 Second:**
   - Deploy Element Web (reference Project 1 URLs)
   - Deploy Element Call (reference Project 1 URLs)
   - Deploy LiveKit (optional)

3. **Test:**
   - Go to Element Web URL
   - Register user
   - Login and verify connection to Synapse in Project 1

---

## Key Points

✅ **Same Project Services:** Use `http://service-name.railway.internal:port`  
✅ **Cross-Project Services:** Use `https://service-url.railway.app`  
✅ **Generate All Secrets:** `openssl rand -hex 32`  
✅ **RSA Key:** Must be full PEM format (includes BEGIN/END lines)  
✅ **Wait for Deploy:** Check if each service is "Running" before adding next

---

## Common Issues

| Issue | Solution |
|-------|----------|
| MAS can't find Synapse | Check `MAS_MATRIX_ENDPOINT` is correct internal hostname |
| Element Web shows blank | Clear cache, verify `HOMESERVER_URL` is public HTTPS |
| PostgreSQL connection fails | Use Railway's `DATABASE_URL` not manual connection string |
| Services won't start | Check all required variables are set (no {{placeholders}}) |

---

## Useful Commands

```bash
# Generate random 32-char hex secrets
openssl rand -hex 32

# Generate RSA key
openssl genrsa -out key.pem 2048

# Test Synapse health
curl -s https://your-synapse-url//_matrix/client/versions | jq

# Test MAS health
curl -s https://your-mas-url/.well-known/openid-configuration | jq
```

Good luck! 🚀
