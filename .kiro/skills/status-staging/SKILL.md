---
name: status-staging
description: >-
  Probes Saranidhi's (PRJ-001) deployed Vercel edges — staging (main → saranidhi-staging) and prod
  (prod → saranidhi) — reporting HTTP status + latency. Mirrors `just status-staging`. Use when the
  user runs /status-staging or asks if the deployed site is up.
---

# Skill: Status Staging (`/status-staging`)

## Objective
Live-probe the deployed Vercel edges and report health. Mirrors `just status-staging`.

## Trigger Patterns
- `/status-staging` · "is staging up?", "check the deployed site", "prod status"

## Steps
```bash
just status-staging
```
Probes both edges and reports HTTP code + latency:
- **Staging:** `main` → saranidhi-staging.vercel.app
- **Production:** `prod` → saranidhi.vercel.app

## Rules
- Read-only HTTP probe — never deploys or mutates.
- A non-200 is a signal to surface, not to act on silently.
