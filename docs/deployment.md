[← Back to Root](../README.md)

# Saranidhi — Production Deployment Guide

## Architecture

```
Feature branch → PR → main (staging) → /release PR → prod (production)
                  ↓                         ↓                    ↓
        Preview URL (fresh)    saranidhi-staging.vercel.app    saranidhi.vercel.app
```

| Environment | Branch | Platform | URL | Trigger | Data |
|-------------|--------|----------|-----|---------|------|
| **Production** | `prod` | Vercel | [saranidhi.vercel.app](https://saranidhi.vercel.app) | `/release` PR merge | Existing user data |
| **Staging** | `main` | Vercel (2nd project) | [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) | Auto (on merge to main) | Existing user data |
| **Preview** | PR branches | Vercel | Auto-generated per PR | Auto (on PR open/update) | Clean/fresh data |

---

## How It Works

Vercel is connected to the `vteial/saranidhi` GitHub repository and:

1. **On every push to `prod`:** Builds Flutter web and deploys to `saranidhi.vercel.app` (production)
2. **On every push to `main`:** Builds and deploys to a staging preview URL
3. **On every PR:** Creates a unique preview URL for visual QA before merge

---

## Initial Setup (One-Time)

### Configure Vercel Production Branch

1. Go to [Vercel Dashboard](https://vercel.com/) → saranidhi project
2. **Settings** → **Git**
3. Change **Production Branch** from `main` to `prod`
4. Save

### Create the `prod` Branch

```bash
git checkout main
git pull origin main
git checkout -b prod
git push origin prod
```

This triggers the first production deployment from the `prod` branch.

---

## Deployment Workflow

### Standard Flow (with staging gate)

```
feature branch → PR → main (staging) → smoke test PR → main → release PR → prod (production)
```

1. Feature work on branches → PR targeting `main`
2. Vercel creates preview deployment for the PR (visual QA)
3. CI passes (analyze + test + build) on GitHub Actions
4. Owner reviews on preview URL + merges PR to `main`
5. Vercel auto-deploys `main` to **staging** (preview only, not public production)
6. Verify on staging
7. When ready for release: `/release-start` → smoke test on staging
8. Smoke test results committed via PR → merged to `main`
9. `/release-complete` → PR from `main` → `prod`
10. Owner merges release PR → Vercel deploys to **production**
11. Owner creates GitHub Release (tag `vX.Y.Z-web`)

### Promoting to Production

**Two-phase release protocol:**

```
Phase 1: /release-start
  → Smoke test branch + PR (targeting main)
  → User tests on staging, commits results
  → User merges smoke test PR

Phase 2: /release-complete
  → Kiro creates PR: main → prod (with release notes)
  → User merges → Vercel deploys production
  → User creates GitHub Release (tags the version)
```

**Never promote directly via CLI** (`git merge main` on prod). Always use the PR-based flow for auditability.

### Promotion Checklist

Before promoting to production (`/release-complete`):

- [ ] Smoke test PR merged to `main` (all sections PASS)
- [ ] CI pipeline passes (GitHub Actions: analyze, test, coverage, build)
- [ ] No open blocker issues
- [ ] Privacy policy accessible at `/privacy.html`
- [ ] Release notes prepared (What's New, Fixes, Sprints)

---

## Rollback

### Via Vercel Dashboard

1. Go to [Vercel Dashboard](https://vercel.com/) → saranidhi project
2. Click **Deployments** tab
3. Find the previous working deployment
4. Click **⋯** → **Promote to Production**
5. Takes effect immediately

### Via Git Revert

```bash
git checkout main
git revert HEAD
git push origin main
```

Vercel auto-deploys the reverted state.

---

## Custom Domain (Future)

When ready to add a custom domain:

1. Go to Vercel Dashboard → saranidhi → **Settings** → **Domains**
2. Add your domain (e.g., `saranidhi.app`)
3. Configure DNS (Vercel provides instructions)
4. SSL is automatic

---

## Monitoring

### Vercel Analytics (Built-in)

- Dashboard → saranidhi → **Analytics**
- Shows: visits, performance (Web Vitals), geographic distribution
- **Speed Insights:** Core Web Vitals (LCP, FID, CLS)
- No tracking code needed for basic metrics

### Privacy Note

Vercel's built-in analytics are privacy-friendly — no cookies, no personal data collection, compliant with GDPR.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails on Vercel | Check build logs in Vercel dashboard; ensure Flutter stable channel works |
| Old version still showing | Vercel CDN cache — wait 1-2 minutes; check Deployments tab |
| Preview URL not generated | Ensure Vercel GitHub integration is active for the repo |
| 404 on sub-routes | Flutter web uses hash routing by default — URLs work correctly |
| Privacy page 404 | Ensure `web/privacy.html` exists (static files in `web/` are included in build output) |

---

[← Back to Root](../README.md)
