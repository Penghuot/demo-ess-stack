# Folder Structure for Railway Deployment

Each service now has its own folder with a complete Dockerfile, making it easy to deploy independently from Railway.

```
the-best-repo/
├── synapse/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── homeserver.template.yaml
├── mas/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── config.template.yaml
├── element-web/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── config.template.json
├── element-call/
│   └── Dockerfile
├── nginx/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── default.conf
├── STEP_BY_STEP.md
├── QUICK_DEPLOY.md
├── generate-secrets.sh
├── PUSH_TO_GITHUB.md
└── RAILWAY_DEPLOYMENT.md
```

---

## How Railway Deploys Each Service

### Method 1: Specify Different Dockerfiles (Recommended)

1. Push entire repo to GitHub
2. In Railway Project:
   - Create Service 1 (Synapse): 
     - GitHub Repo: `YOUR_USERNAME/element-docker-demo`
     - Dockerfile Path: `synapse/Dockerfile`
   - Create Service 2 (MAS):
     - GitHub Repo: `YOUR_USERNAME/element-docker-demo`
     - Dockerfile Path: `mas/Dockerfile`
   - Create Service 3 (Element Web):
     - GitHub Repo: `YOUR_USERNAME/element-docker-demo`
     - Dockerfile Path: `element-web/Dockerfile`
   - Create Service 4 (nginx):
     - GitHub Repo: `YOUR_USERNAME/element-docker-demo`
     - Dockerfile Path: `nginx/Dockerfile`

### Method 2: Multiple Repositories (Alternative)

If you prefer, create separate repos:
- `https://github.com/YOUR_USERNAME/matrix-synapse`
- `https://github.com/YOUR_USERNAME/matrix-mas`
- `https://github.com/YOUR_USERNAME/element-web`
- `https://github.com/YOUR_USERNAME/matrix-nginx`

Then deploy each with its own root `Dockerfile`.

---

## Updated Railway Configuration

### Project 1 (matrix-core)

**Service 1: Synapse**
```
GitHub Repo: YOUR_USERNAME/element-docker-demo
Dockerfile Path: synapse/Dockerfile
Port: 8008
Environment: (see QUICK_DEPLOY.md)
```

**Service 2: MAS**
```
GitHub Repo: YOUR_USERNAME/element-docker-demo
Dockerfile Path: mas/Dockerfile
Port: 8080
Environment: (see QUICK_DEPLOY.md)
```

**Service 3: nginx**
```
GitHub Repo: YOUR_USERNAME/element-docker-demo
Dockerfile Path: nginx/Dockerfile
Port: 80, 443
Environment: (none needed)
```

**Service 4: PostgreSQL** (Railway auto-provision)

---

### Project 2 (matrix-clients)

**Service 1: Element Web**
```
GitHub Repo: YOUR_USERNAME/element-docker-demo
Dockerfile Path: element-web/Dockerfile
Port: 80
Environment: 
  - HOMESERVER_URL
  - SERVER_NAME
  - ELEMENT_DEFAULT_THEME
```

**Service 2: Element Call**
```
GitHub Repo: YOUR_USERNAME/element-docker-demo
Dockerfile Path: element-call/Dockerfile
Port: 3000
Environment: (optional)
```

---

## To Deploy

1. **Push to GitHub:**
   ```bash
   cd the-best-repo
   git add .
   git commit -m "Add Dockerfiles for each service"
   git push origin main
   ```

2. **In Railway Project 1:**
   - New Service → GitHub
   - Select `YOUR_USERNAME/element-docker-demo`
   - Set Dockerfile Path to `synapse/Dockerfile`
   - Set Environment Variables
   - Deploy

   (Repeat for MAS, nginx)

3. **In Railway Project 2:**
   - New Service → GitHub
   - Set Dockerfile Path to `element-web/Dockerfile`
   - Set Environment Variables
   - Deploy

   (Repeat for Element Call if needed)

---

## File Organization Benefits

✅ **Easy to manage:** Each service is self-contained  
✅ **Railway deployment:** Just specify the right Dockerfile path  
✅ **GitHub organized:** All services in one repo  
✅ **No conflicts:** Each Dockerfile is independent  
✅ **Easy to scale:** Add more services anytime  

All configuration files are **templated** and environment variables are substituted at startup.
