# element-docker-demo on Railway - 2 Project Deployment

## Stack Overview
element-docker-demo includes:
- PostgreSQL (database)
- Synapse (homeserver)
- Matrix Authentication Service (MAS)
- Element Web
- Element Call
- LiveKit
- nginx (reverse proxy)

**Total: 7+ services → Railway limit: 5 per project → Need: 2 projects**

## Deployment Strategy

### Project 1: Core (Database + Auth)
1. PostgreSQL
2. Synapse
3. MAS
4. nginx (reverse proxy for Synapse/MAS)

### Project 2: Clients (UI + Calls)
1. Element Web
2. Element Call
3. LiveKit (optional - can skip for MVP)

---

## Project 1 Setup: Core Stack

### Step 1: Create Project 1
- Go to Railway → New Project
- Name: `matrix-core` (or similar)

### Step 2: Add PostgreSQL
- Click "+ Add" → Select "PostgreSQL"
- Railway creates it automatically
- Copy the connection string from Variables tab

### Step 3: Deploy Synapse
Create a new service with:
- **Name**: `synapse`
- **GitHub Repo**: `element-hq/element-docker-demo`
- **Dockerfile Path**: `Dockerfile.synapse` (or create a custom one)

**Environment Variables:**
```
SYNAPSE_SERVER_NAME=your-synapse-url.railway.app
SYNAPSE_PUBLIC_BASEURL=https://your-synapse-url.railway.app
DATABASE_URL=<PostgreSQL connection string from Railway>
SYNAPSE_DB_USER=postgres
SYNAPSE_DB_PASSWORD=<from PostgreSQL>
SYNAPSE_DB_HOST=<PostgreSQL internal hostname>
SYNAPSE_DB_PORT=5432
SYNAPSE_DB_NAME=synapse
SYNAPSE_MACAROON_SECRET_KEY=$(openssl rand -hex 32)
SYNAPSE_FORM_SECRET=$(openssl rand -hex 32)
SYNAPSE_REGISTRATION_SECRET=$(openssl rand -hex 32)
LOG_LEVEL=INFO
```

### Step 4: Deploy MAS
- **Name**: `mas`
- **GitHub Repo**: `element-hq/element-docker-demo`

**Environment Variables:**
```
MAS_PUBLIC_BASE=https://your-mas-url.railway.app
MAS_DATABASE_URI=<PostgreSQL connection string>
MAS_MATRIX_HOMESERVER=https://your-synapse-url.railway.app
MAS_MATRIX_ENDPOINT=http://synapse:8008
MAS_CLIENT_ID=0000000000000000000SYNAPSE
MAS_CLIENT_SECRET=<generate: openssl rand -hex 32>
MAS_ENCRYPTION_KEY=$(openssl rand -hex 32)
MAS_SIGNING_KEY=<RSA private key - see below>
MAS_MATRIX_SHARED_SECRET=$(openssl rand -hex 32)
MAS_EMAIL_DOMAIN=noreply.railway.app
```

### Step 5: Deploy nginx
- **Name**: `nginx`
- Use custom Dockerfile that proxies to Synapse + MAS

---

## Project 2 Setup: Client Stack

### Step 1: Create Project 2
- Go to Railway → New Project  
- Name: `matrix-clients` (or similar)

### Step 2: Deploy Element Web
- **Name**: `element-web`
- **Dockerfile**: `Dockerfile.element-web`

**Environment Variables:**
```
HOMESERVER_URL=https://your-synapse-url.railway.app (from Project 1)
SERVER_NAME=your-synapse-url.railway.app
ELEMENT_DEFAULT_THEME=dark
```

### Step 3: Deploy Element Call
- **Name**: `element-call`
- **Dockerfile**: `Dockerfile.element-call`

**Environment Variables:**
```
ELEMENT_CALL_SFU_URL=https://your-livekit-url.railway.app
VITE_HOMESERVER_URL=https://your-synapse-url.railway.app (from Project 1)
```

### Step 4: Deploy LiveKit (Optional)
- Skip for MVP if you don't need video calls
- Can add later

---

## Critical: Networking Across Projects

Since services are in different projects, they **cannot** use Railway internal networking. Use **public URLs**:

```yaml
# In MAS (Project 1) config:
matrix:
  homeserver: "https://your-synapse-url.railway.app"  # Project 1 public URL
  endpoint: "http://synapse:8008"                      # Project 1 internal (same project)

# In Element Web (Project 2) config:
HOMESERVER_URL: "https://your-synapse-url.railway.app"  # Project 1 public URL
```

---

## Quick Deploy Checklist

- [ ] Generate RSA signing key for MAS:
  ```bash
  openssl genrsa -out mas_key.pem 2048
  ```
- [ ] Copy content into `MAS_SIGNING_KEY` variable

- [ ] Project 1 created: `matrix-core`
  - [ ] PostgreSQL added
  - [ ] Synapse deployed (port 8008)
  - [ ] MAS deployed (port 8080)
  - [ ] nginx deployed (port 80/443)

- [ ] Project 2 created: `matrix-clients`
  - [ ] Element Web deployed (port 80)
  - [ ] Element Call deployed (port 3000) [optional]
  - [ ] LiveKit deployed (port 7880) [optional]

- [ ] Update Element Web config with Synapse URL from Project 1
- [ ] Test at: `https://element-web-url.railway.app`

---

## Troubleshooting

1. **MAS won't connect to Synapse**
   - Check: Both use public HTTPS URLs
   - Verify: Synapse is actually running in Project 1
   - Check MAS logs: `docker logs mas`

2. **Element Web shows empty login**
   - Verify: HOMESERVER_URL is set correctly
   - Clear browser cache
   - Check: Synapse is publicly accessible

3. **PostgreSQL connection fails**
   - Use Railway's built-in PostgreSQL connection string
   - Don't hardcode IPs - use Railway environment variables

---

## Deploy Commands (if using CLI)

```bash
# Authenticate with Railway
railway login

# Project 1: Core
railway link <project-id-1>
railway service add synapse
railway service add mas
railway service add nginx

# Project 2: Clients  
railway link <project-id-2>
railway service add element-web
railway service add element-call
```

---

## Next Steps

1. Clone the repo if you haven't already:
   ```bash
   git clone https://github.com/element-hq/element-docker-demo
   cd element-docker-demo
   ```

2. Review `docker-compose.yml` to understand service dependencies

3. Follow the deployment steps above for both projects

4. Once both projects are live, test the full stack:
   - Register user via Element Web
   - Login and send test messages
   - (Optional) Test video calls via Element Call

Good luck with deployment tonight! 🚀
