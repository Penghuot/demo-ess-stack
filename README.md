# complete-matrix-stack

A complete Matrix 2.0 stack deployable to Railway, featuring Synapse, Matrix Authentication Service (MAS), Element Web, and Element Call.

## Services Included

- **Synapse** - Matrix homeserver (Matrix 1.0/2.0 compatible)
- **MAS** - Matrix Authentication Service (OAuth/OIDC)
- **Element Web** - Web client
- **Element Call** - Built-in video calling
- **nginx** - Reverse proxy/load balancer
- **PostgreSQL** - Database (provided by Railway)

## Quick Start Guides

- **[STEP_BY_STEP.md](STEP_BY_STEP.md)** - Complete checklist with screenshots (start here!)
- **[FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md)** - How services are organized and deployed
- **[QUICK_DEPLOY.md](QUICK_DEPLOY.md)** - Quick reference with all variables
- **[generate-secrets.sh](generate-secrets.sh)** - Generate secure secrets
- **[PUSH_TO_GITHUB.md](PUSH_TO_GITHUB.md)** - How to deploy from your own repo
- **[RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)** - Detailed architecture overview

## Folder Structure

Each service has its own Dockerfile and configuration:

```
synapse/          - Synapse homeserver
mas/              - Matrix Authentication Service
element-web/      - Web client
element-call/     - Video calling
nginx/            - Reverse proxy
```

## 30-Second Deploy

1. **Generate secrets:** `bash generate-secrets.sh > secrets.txt`
2. **Push to GitHub:** `git push origin main`
3. **Create 2 Railway projects:** `matrix-core` and `matrix-clients`
4. **Project 1 (4 services):** PostgreSQL, Synapse, MAS, nginx
5. **Project 2 (2 services):** Element Web, Element Call
6. **Set environment variables** from `secrets.txt`
7. **Done!** Access at `https://element-web-xxxxx.railway.app`

## To Deploy from Your Repo

```bash
# 1. Push to GitHub
git remote add origin https://github.com/YOUR_USERNAME/element-docker-demo
git push -u origin main

# 2. In Railway:
#    - New Project → Deploy from GitHub
#    - Select your repo
#    - For each service, specify Dockerfile path:
#      - Synapse: synapse/Dockerfile
#      - MAS: mas/Dockerfile
#      - nginx: nginx/Dockerfile
#      - Element Web: element-web/Dockerfile
```

## Environment Variables Needed

See **QUICK_DEPLOY.md** for complete list, but main ones:

**Project 1:**
- `SYNAPSE_SERVER_NAME` - Your homeserver domain
- `SYNAPSE_PUBLIC_BASEURL` - Public Synapse URL
- `DATABASE_URL` - PostgreSQL connection (from Railway)
- MAS and crypto keys

**Project 2:**
- `HOMESERVER_URL` - Reference Project 1 Synapse
- `SERVER_NAME` - Same as Project 1

## Testing Your Deployment

1. Open Element Web: `https://element-web-xxxxx.railway.app`
2. Create account
3. Login and send test message
4. (Optional) Make video call via Element Call

## Support Resources

- [Matrix Spec](https://spec.matrix.org/)
- [Synapse Docs](https://matrix-org.github.io/synapse/)
- [Element Web Docs](https://github.com/element-hq/element-web)
- [MAS Docs](https://github.com/element-hq/matrix-authentication-service)

## Notes

- This is a **complete demo stack** - not a production setup
- For production, see [Element Server Suite](https://element.io/server-suite)
- All services auto-restart on Railway
- Database is PostgreSQL (not SQLite)
- Supports federation with other Matrix servers
- HTTPS via Railway auto-certs

---

**Ready to deploy?** Start with [STEP_BY_STEP.md](STEP_BY_STEP.md) ✨
