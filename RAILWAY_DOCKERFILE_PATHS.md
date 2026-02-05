# Railway: How to Deploy Each Service with Custom Dockerfiles

This guide shows exactly how to deploy each service from your repo using Railway's Dockerfile Path feature.

## Why This Works

Each service folder (synapse/, mas/, element-web/, nginx/) has its own **Dockerfile**. Railway can deploy any folder by specifying the path to its Dockerfile, making it easy to deploy different services from the same repository.

---

## PROJECT 1: matrix-core

### Step 1: Add Service - Synapse

1. In Railway Project "matrix-core"
2. Click **+ Add Service** → **GitHub Repo**
3. Select: `YOUR_USERNAME/element-docker-demo`
4. Name: `synapse`
5. Go to **Settings** tab
6. Scroll down to **Dockerfile Path**
7. Enter: `synapse/Dockerfile`
8. Set **Port**: `8008`
9. Go to **Variables** tab
10. Add all SYNAPSE_* variables from QUICK_DEPLOY.md
11. Click **Deploy**

Railway will now:
- Clone your repo
- Look for `synapse/Dockerfile` (not root Dockerfile)
- Build it with Synapse configuration
- Start Synapse container

---

### Step 2: Add Service - MAS

1. Click **+ Add Service** → **GitHub Repo**
2. Select: `YOUR_USERNAME/element-docker-demo`
3. Name: `mas`
4. Go to **Settings** tab
5. Set **Dockerfile Path**: `mas/Dockerfile`
6. Set **Port**: `8080`
7. Go to **Variables** tab
8. Add all MAS_* variables from QUICK_DEPLOY.md
9. Click **Deploy**

---

### Step 3: Add Service - nginx

1. Click **+ Add Service** → **GitHub Repo**
2. Select: `YOUR_USERNAME/element-docker-demo`
3. Name: `nginx`
4. Go to **Settings** tab
5. Set **Dockerfile Path**: `nginx/Dockerfile`
6. Set **Port**: `80` and `443`
7. Go to **Variables** tab
8. (nginx doesn't need env vars, but you can add them if desired)
9. Click **Deploy**

---

### Step 4: Add PostgreSQL

1. Click **+ Add** → **PostgreSQL**
2. Railway auto-creates database
3. Go to **Variables** tab
4. Copy the full `DATABASE_URL` value
5. Add as variable to both Synapse and MAS services

---

## PROJECT 2: matrix-clients

### Step 1: Add Service - Element Web

1. In Railway Project "matrix-clients"
2. Click **+ Add Service** → **GitHub Repo**
3. Select: `YOUR_USERNAME/element-docker-demo`
4. Name: `element-web`
5. Go to **Settings** tab
6. Set **Dockerfile Path**: `element-web/Dockerfile`
7. Set **Port**: `80`
8. Go to **Variables** tab
9. Add **HOMESERVER_URL** (copy from Project 1 Synapse public URL)
10. Add **SERVER_NAME**
11. Add **ELEMENT_DEFAULT_THEME** = `dark`
12. Click **Deploy**

---

### Step 2: Add Service - Element Call (Optional)

1. Click **+ Add Service** → **GitHub Repo**
2. Select: `YOUR_USERNAME/element-docker-demo`
3. Name: `element-call`
4. Go to **Settings** tab
5. Set **Dockerfile Path**: `element-call/Dockerfile`
6. Set **Port**: `3000`
7. Go to **Variables** tab
8. Add **VITE_HOMESERVER_URL** (from Project 1)
9. Click **Deploy**

---

## Important: Finding Railway UI

The **Dockerfile Path** setting is in:

```
Service Settings
    → Build
        → Dockerfile Path
```

Example path structure for Railway:
- Synapse: `synapse/Dockerfile`
- MAS: `mas/Dockerfile`
- Element Web: `element-web/Dockerfile`
- nginx: `nginx/Dockerfile`

---

## Testing After Deploy

### Check if Services Started

1. Go each service
2. Look for **Deployment** history
3. Check if latest deployment is "Running" (green)

### Test Synapse Health

```bash
curl https://synapse-xxxx.railway.app/_matrix/client/versions
# Should return JSON with versions
```

### Test Element Web

Open in browser: `https://element-web-xxxx.railway.app`

Should see login page.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails: "Dockerfile not found" | Check Dockerfile Path syntax. Should be `synapse/Dockerfile` not `synapse` |
| Service crashes after deploy | Check Variables tab, ensure all required env vars are set |
| "Cannot find route" | Wait 2-3 minutes for deployment to complete |
| Synapse won't connect to Database | Verify DATABASE_URL is copied correctly, use `postgresql://` URL |

---

## Key Differences from Monolithic Dockerfile

**Old way:** One Dockerfile in root → all services together ❌  
**New way:** Each folder has its Dockerfile → deploy independently ✅

Your repo now supports Railway's multi-service deployment natively!

---

## Next Steps

1. ✅ Create folders with Dockerfiles (done!)
2. ✅ Push to GitHub
3. ✅ Create Railway projects
4. ✅ Add services with Dockerfile paths (follow this guide)
5. Go live!

Good luck! 🚀
