# Deploy from Your Own Repository

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Name: `element-docker-demo` (or your preferred name)
3. Keep all defaults
4. Click "Create repository"
5. **DO NOT** initialize with README (we have our own)

---

## Step 2: Push Your Local Repo to GitHub

In your terminal, from your `the-best-repo` folder:

```bash
cd d:\Internship2\ess\ test\the-best-repo

# Remove old origin if it exists
git remote remove origin

# Add your new GitHub repo as origin
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/element-docker-demo.git

# Rename branch to main if needed
git branch -M main

# Push everything to GitHub
git push -u origin main
```

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username.

---

## Step 3: Verify on GitHub

1. Go to https://github.com/YOUR_GITHUB_USERNAME/element-docker-demo
2. You should see all your files there
3. Copy the repo URL: `https://github.com/YOUR_GITHUB_USERNAME/element-docker-demo`

---

## Step 4: Update Railway Deployment

Now use your own repo instead of element-hq/element-docker-demo:

### In PROJECT 1 (matrix-core):
- Instead of: `element-hq/element-docker-demo`
- Use: `YOUR_USERNAME/element-docker-demo`

### In PROJECT 2 (matrix-clients):
- Same: `YOUR_USERNAME/element-docker-demo`

---

## Step 5: Configure Railway to Deploy from Your Repo

When adding services in Railway:

1. Click "New Service" → "GitHub Repo"
2. Authorize Railway to access your GitHub (first time only)
3. Select your repo: `YOUR_USERNAME/element-docker-demo`
4. Railway auto-detects Dockerfile and deploys

---

## Common Issues

| Issue | Solution |
|-------|----------|
| "Repository not found" | Make sure repo is public on GitHub, or give Railway permission |
| Dockerfile not found | Check it's in root of your repo |
| Permission denied on GitHub push | Generate personal access token: https://github.com/settings/tokens |
| Want to keep synced with element-hq? | Run: `git remote add upstream https://github.com/element-hq/element-docker-demo.git` |

---

## Push Updates Later

After making changes locally:

```bash
git add .
git commit -m "Your changes"
git push origin main
```

Railway will auto-redeploy when it detects changes on main branch.

---

## To Sync with Official Updates (Optional)

If you want to pull latest changes from element-hq:

```bash
git fetch upstream
git rebase upstream/main
git push origin main
```

This keeps your fork updated with official changes.
