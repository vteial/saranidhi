[← Back to Root](../README.md)

# Saranidhi — Production Deployment Guide

## Architecture

```
GitHub (main) ──PR──► GitHub (prod) ──push──► GitHub Actions ──build──► Cloudflare Pages
                                                                              │
                                                                    saranidhi.pages.dev
```

| Environment | Branch | Platform | URL | Trigger |
|-------------|--------|----------|-----|---------|
| **Staging** | `main` | Vercel | saranidhi.vercel.app | Auto (on merge) |
| **Production** | `prod` | Cloudflare Pages | saranidhi.pages.dev | Auto (on push to prod) |

---

## Initial Setup (One-Time)

### 1. Create Cloudflare Pages Project

1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Go to **Workers & Pages** → **Create** → **Pages**
3. Select **Direct Upload** (we deploy via GitHub Actions, not Cloudflare's git integration)
4. Project name: `saranidhi`
5. This creates the project — first actual deployment will come from GitHub Actions

### 2. Generate Cloudflare API Token

1. Go to **My Profile** → **API Tokens** → **Create Token**
2. Use template: **Edit Cloudflare Workers** (includes Pages permissions)
3. OR create custom token with permissions:
   - Account → Cloudflare Pages → Edit
   - Account → Account Settings → Read
4. Copy the token

### 3. Get Cloudflare Account ID

1. Go to any domain's **Overview** page in Cloudflare Dashboard
2. Scroll down to the right sidebar → **Account ID** (32-character hex string)
3. Copy the Account ID

### 4. Add GitHub Secrets

In the GitHub repo (`vteial/saranidhi`):

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add these repository secrets:

| Secret Name | Value |
|-------------|-------|
| `CLOUDFLARE_API_TOKEN` | The API token from step 2 |
| `CLOUDFLARE_ACCOUNT_ID` | The Account ID from step 3 |

### 5. Create the `prod` Branch

```bash
git checkout main
git pull origin main
git checkout -b prod
git push origin prod
```

This triggers the first production deployment via GitHub Actions.

---

## Deployment Workflow

### Automatic (Recommended)

1. Development happens on feature branches → merged to `main`
2. `main` auto-deploys to Vercel (staging) for QA
3. When ready for production: merge `main` → `prod`
4. Push to `prod` triggers `.github/workflows/deploy-production.yml`
5. Workflow: analyze → test → build → deploy to Cloudflare → verify

### Manual Trigger

1. Go to **Actions** → **Deploy to Production** workflow
2. Click **Run workflow**
3. Type `deploy` in the confirmation field
4. Click **Run workflow**

---

## Deployment Checklist

Before promoting `main` → `prod`:

- [ ] All CI checks pass on `main`
- [ ] Vercel staging (saranidhi.vercel.app) verified visually
- [ ] Smoke test results: all sections PASS (see `docs/smoke-test-results.md`)
- [ ] No open blocker issues
- [ ] Privacy policy accessible at `/privacy.html`

---

## Rollback

### Quick Rollback (Cloudflare Dashboard)

1. Go to **Workers & Pages** → **saranidhi** → **Deployments**
2. Find the previous working deployment
3. Click **⋯** → **Rollback to this deployment**
4. Takes effect immediately (~30 seconds)

### Git Rollback

```bash
git checkout prod
git revert HEAD
git push origin prod
```

This triggers a new deployment with the reverted code.

---

## Custom Domain (Future)

When ready to add a custom domain:

1. Go to **Workers & Pages** → **saranidhi** → **Custom domains**
2. Click **Set up a custom domain**
3. Enter your domain (e.g., `saranidhi.app`)
4. Cloudflare will auto-configure DNS if the domain is on Cloudflare
5. SSL certificate is provisioned automatically

---

## Monitoring

### Cloudflare Analytics (Built-in)

- **Workers & Pages** → **saranidhi** → **Analytics**
- Shows: requests, bandwidth, response codes, geographic distribution
- No tracking code needed — analytics are server-side

### Health Check

The deploy workflow includes automatic verification:
- Checks HTTP 200 on `saranidhi.pages.dev`
- Checks HTTP 200 on `saranidhi.pages.dev/privacy.html`

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Deploy workflow fails at "Deploy to Cloudflare Pages" | Check `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` secrets are set correctly |
| 404 on saranidhi.pages.dev | Verify Cloudflare Pages project name is `saranidhi` (case-sensitive) |
| Build fails | Check Flutter version — workflow uses `stable` channel |
| Wrangler authentication error | Regenerate API token with correct permissions |
| Old version still showing | Cloudflare CDN cache — wait 5 minutes or purge cache in dashboard |

---

[← Back to Root](../README.md)
