# Step-by-Step Railway Deployment Checklist

## Before Starting

1. **Generate all secrets:**
   ```bash
   bash generate-secrets.sh > /tmp/secrets.txt
   cat /tmp/secrets.txt
   ```
   Copy output somewhere safe (you'll paste it into Railway)

2. **Have ready:**
   - GitHub repo: https://github.com/element-hq/element-docker-demo
   - A custom domain or Railway subdomain for matrix services
   - Example: `matrix-demo.railway.app` or `matrix.yourdomain.com`

---

## PROJECT 1: matrix-core

### Step 1: Create Project
- [ ] Go to https://railway.app/dashboard
- [ ] Click "New Project"
- [ ] Name: `matrix-core`
- [ ] Select "Deploy from GitHub"
- [ ] Fork/Connect: Select your own repository (YOUR_USERNAME/element-docker-demo)
- [ ] Make sure you've authorized Railway to access your GitHub account

### Step 2: Add PostgreSQL
- [ ] In project, click "+ Add"
- [ ] Select "PostgreSQL"
- [ ] Railway auto-creates database
- [ ] Click "PostgreSQL" service
- [ ] Go to "Variables" tab
- [ ] **IMPORTANT:** Copy the full connection string (looks like `postgresql://postgres:xxxxx@host:5432/railway`)
- Keep this handy for next step

### Step 3: Deploy Synapse Service
- [ ] Click "New Service" → "GitHub Repo"
- [ ] Select your repo: `YOUR_USERNAME/element-docker-demo`
- [ ] Name: `synapse`
- [ ] Go to service settings
- [ ] Set **Port:** `8008`
- [ ] Click "Variables" tab
- [ ] Add these variables:

```
SYNAPSE_SERVER_NAME=synapse-core.railway.app
SYNAPSE_PUBLIC_BASEURL=https://synapse-core.railway.app/
SYNAPSE_DB_USER=postgres
SYNAPSE_DB_PASSWORD=<from PostgreSQL Variables tab>
SYNAPSE_DB_HOST=<from PostgreSQL Variables tab - find the host part>
SYNAPSE_DB_PORT=5432
SYNAPSE_DB_NAME=synapse
SYNAPSE_MACAROON_SECRET_KEY=<from your secrets.txt file>
SYNAPSE_FORM_SECRET=<from your secrets.txt file>
SYNAPSE_REGISTRATION_SECRET=<from your secrets.txt file>
LOG_LEVEL=INFO
```

- [ ] Delete the auto-generated `/app/Dockerfile` (use element-docker-demo's)
- [ ] Click "Deploy"
- [ ] **WAIT** until status = "Running" (can take 10 mins)
- [ ] Note the public URL: `synapse-core-xxxx.railway.app`

### Step 4: Deploy MAS Service
- [ ] Click "New Service" → "GitHub Repo"
- [ ] Select your repo: `YOUR_USERNAME/element-docker-demo`
- [ ] Name: `mas`
- [ ] Go to service settings
- [ ] Set **Port:** `8080`
- [ ] Click "Variables" tab
- [ ] Add these variables:

```
MAS_PUBLIC_BASE=https://mas-core.railway.app/
MAS_DATABASE_URI=postgresql://postgres:password@host:5432/mas
MAS_MATRIX_HOMESERVER=https://synapse-core-xxxx.railway.app/
MAS_MATRIX_ENDPOINT=http://synapse:8008
MAS_CLIENT_ID=0000000000000000000SYNAPSE
MAS_CLIENT_SECRET=<from your secrets.txt file>
MAS_ENCRYPTION_KEY=<from your secrets.txt file>
MAS_SIGNING_KEY=<PASTE ENTIRE RSA KEY from secrets.txt including BEGIN/END>
MAS_MATRIX_SHARED_SECRET=<from your secrets.txt file>
MAS_EMAIL_DOMAIN=noreply.railway.app
```

- [ ] Click "Deploy"
- [ ] **WAIT** until status = "Running"
- [ ] Note the public URL: `mas-core-xxxx.railway.app`

### Step 5: Deploy nginx Service
- [ ] Click "New Service" → "GitHub Repo"
- [ ] Select your repo: `YOUR_USERNAME/element-docker-demo`
- [ ] Name: `nginx`
- [ ] Go to service settings
- [ ] Set **Port:** `80` and `443`
- [ ] Configure to proxy:
  - `/_synapse/*` → `http://synapse:8008`
  - `/_matrix/*` → `http://mas:8080`
  - `/` → Element Web (in Project 2)
- [ ] Click "Deploy"
- [ ] **WAIT** until status = "Running"

**PROJECT 1 COMPLETE!** ✅

---

## PROJECT 2: matrix-clients

### Step 1: Create Project
- [ ] Click "New Project"
- [ ] Name: `matrix-clients`
- [ ] Select "Deploy from GitHub"
- [ ] Connect: your own repo `YOUR_USERNAME/element-docker-demo`

### Step 2: Deploy Element Web Service
- [ ] Click "New Service" → "GitHub Repo"
- [ ] Select your repo: `YOUR_USERNAME/element-docker-demo`
- [ ] Name: `element-web`
- [ ] Set **Port:** `80`
- [ ] Click "Variables" tab
- [ ] Add these variables:

```
HOMESERVER_URL=https://synapse-core-xxxx.railway.app/
SERVER_NAME=synapse-core-xxxx.railway.app
ELEMENT_DEFAULT_THEME=dark
```

Replace `synapse-core-xxxx.railway.app` with the actual Synapse URL from Project 1 ⬆️

- [ ] Click "Deploy"
- [ ] **WAIT** until status = "Running"
- [ ] Note the URL: `element-web-xxxx.railway.app`

### Step 3: Deploy Element Call (Optional)
- [ ] Click "New Service" → "GitHub Repo"
- [ ] Select your repo: `YOUR_USERNAME/element-docker-demo`
- [ ] Name: `element-call`
- [ ] Set **Port:** `3000`
- [ ] Add Variables:

```
VITE_HOMESERVER_URL=https://synapse-core-xxxx.railway.app/
SFU_URL=https://livekit-xxxx.railway.app/ (if using LiveKit)
```

- [ ] Click "Deploy"

### Step 4: Deploy LiveKit (Optional)
- [ ] Skip for MVP - can add later
- [ ] Only needed if you want video calls

**PROJECT 2 COMPLETE!** ✅

---

## Testing

### 1. Test Synapse is Running
```bash
curl https://synapse-core-xxxx.railway.app/_matrix/client/versions
# Should return JSON with version info
```

### 2. Test Element Web
- [ ] Open browser: `https://element-web-xxxx.railway.app`
- [ ] You should see login page
- [ ] Click "Create Account"
- [ ] Register a test user
- [ ] Login should work

### 3. Test MAS Connection
- [ ] If OIDC is configured, try "Sign in with MAS"
- [ ] Should redirect to MAS, then back to Element

### 4. Full Flow
- [ ] Logout
- [ ] Create another account
- [ ] Login with first account
- [ ] Start a chat with second account
- [ ] Send test message

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Synapse won't start | Check logs for config errors. Ensure all {{placeholders}} are replaced. |
| MAS can't connect to Synapse | Check `MAS_MATRIX_ENDPOINT` is correct. Test: `curl http://synapse:8008/_matrix/client/versions` in MAS logs. |
| Element Web shows blank | Clear browser cache (Ctrl+Shift+Delete). Check HOMESERVER_URL in console (F12). |
| PostgreSQL connection fails | Use full connection string from Railway PostgreSQL service. Copy exact credentials. |
| 404 on element URL | Make sure service has deployed and is Running status. |

---

## After Successful Deployment

1. **Add custom domain** (optional):
   - Railway → Project → Settings → Custom Domain
   - Point DNS to `cname.railway.app`

2. **Enable federation** (optional):
   - This allows users from other homeservers to chat with yours
   - Requires proper DNS setup and `.well-known` configuration

3. **Backup your data:**
   - PostgreSQL data: `docker volume inspect`
   - Keep your `secrets.txt` safe!

4. **Monitor:**
   - Check Railway logs regularly
   - Set up alerts for service failures

---

## Done! 🎉

You've successfully deployed element-docker-demo on Railway with 2 projects:
- **Project 1:** Synapse + MAS backend
- **Project 2:** Element Web frontend + Element Call + LiveKit

Users can now:
- ✅ Register via Element Web
- ✅ Login and chat
- ✅ Make video calls (if Element Call + LiveKit running)
- ✅ Connect from other Matrix clients

**Time to deploy:** ~30-45 minutes for full stack
