[← Back to Root](../../README.md)

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
| **Preview** | **code** branches (`sprint/*`, `release/*`, `fix/*`) | Vercel (prod project) | Auto-generated per PR | Auto (docs/plan branches excluded — see Deployment Budget) | Clean/fresh data |

---

## How It Works

Vercel is connected to the `vteial/saranidhi` GitHub repository and:

1. **On every push to `prod`:** Builds Flutter web and deploys to `saranidhi.vercel.app` (production)
2. **On every push to `main`:** Builds and deploys to a staging preview URL
3. **On a push to a _code_ branch** (`sprint/*`, `release/*`, `fix/*`): Creates a unique preview URL for visual QA before merge
4. **On a push to a _docs_ branch** (`docs/*`, `plan/*`): **No deployment** — see the Deployment Budget below

---

## Deployment Budget & Quota Strategy

> **Why this section exists:** on 2026-09-12 a release-branch preview build **failed on the
> Vercel Hobby 100-deployments/day cap**. Root cause was structural, not a fluke — see below.

### The three facts that drive the strategy

1. **A skipped build still counts as a deployment.** Our [`scripts/vercel_ignore_build.sh`](../../scripts/vercel_ignore_build.sh)
   `ignoreCommand` saves **build minutes** on docs-only commits, but Vercel still spins up a
   (canceled) **deployment** to evaluate the skip — and **canceled/skipped deployments count
   toward the daily quota.** So the ignore script never protected the deployment budget.
   *(Vercel: skipped/canceled Ignored-Build-Step deployments are counted — [community](https://community.vercel.com/t/monorepo-initiates-deployment-even-if-skip-built-is-enabled/27233), [discussion #5716](https://github.com/vercel/vercel/discussions/5716). Content rephrased for licensing.)*
2. **Two Vercel projects double every push.** The repo is connected to **two** projects —
   `saranidhi` (prod) and `saranidhi-staging`. Historically *both* emitted a deployment on
   every branch push, so one push ≈ **2** deployments.
3. **The release lifecycle is push-dense.** One feature ≈ 7 branch pushes (`/plan` →
   `/sprint-start` → `/sprint-finish` → `/sprint-update` → `/release-start` →
   main→prod → `/release-update`), most of them **docs-only**. Two back-to-back cycles in a
   day, × 2 projects, is how ~28+ deployments appeared and tripped the cap.

### The strategy — deploy only what needs a preview

The real quota lever is **`git.deploymentEnabled`** in `vercel.json` (a branch whose value is
`false` is **never deployed → never counts**), plus a dashboard toggle on the staging project.
Our branch-naming convention already separates **code** branches (`sprint/*`, `release/*`,
`fix/*` — need a preview) from **docs** branches (`docs/*`, `plan/*` — never need one).

| Lever | Where | Effect |
|-------|-------|--------|
| **`git.deploymentEnabled` deny-list** | [`vercel.json`](../../vercel.json) (committed) | `docs/**` + `plan/**` → **no deployment** on the **prod** project. Docs/plan pushes (the majority) stop consuming quota. Unspecified branches stay `true` (fail-safe — a new code-branch family still previews). |
| **Staging = `main` only** | Vercel dashboard, `saranidhi-staging` project → **Settings → Environments → Preview → turn off Branch Tracking** | The staging project stops emitting per-branch previews. It deploys only `main` (its actual job). Removes the redundant second deployment per push. |
| **`ignoreCommand`** (existing) | [`scripts/vercel_ignore_build.sh`](../../scripts/vercel_ignore_build.sh) | Still useful — saves **build minutes** on any docs-only commit that *does* reach a deployed branch (e.g. a docs-only commit on `main`). Complementary to the above, not a replacement. |

**Net effect:** a docs/plan push = **0 deployments**; a code-branch push = **1** (prod-project
preview only). The pre-merge smoke gate is unchanged — it runs on the **prod-project PR
preview** of the `release/*` branch, which is exactly what we still deploy.

### What must be set in the Vercel dashboard (one-time, not in-repo)

- [ ] **`saranidhi-staging` project → Settings → Environments → Preview → Branch Tracking = OFF** (deploy only `main`).
- [ ] Confirm the **`saranidhi` (prod)** project honors `vercel.json`'s `git.deploymentEnabled` (it does by default for the repo-connected project).
- [ ] Optional: if any branch family beyond `docs/*` / `plan/*` should never deploy, add it to `deploymentEnabled` in `vercel.json`.

> **Rule of thumb going forward:** if a branch will never be smoke-tested or previewed
> (anything docs/planning), it should not deploy. Keep the `deploymentEnabled` deny-list in
> sync with the branch-naming convention in [`dev-workflow.md`](../process/dev-workflow.md).

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

[← Back to Root](../../README.md)
