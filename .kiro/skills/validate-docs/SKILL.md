---
name: validate-docs
description: >-
  Audits Saranidhi (PRJ-001) docs — broken links/anchors + per-section freshness stamps
  (`Last verified` / `> Reviewed:`). Mirrors `just validate-docs`. Use when the user runs
  /validate-docs or before a /sprint-update / /sprint-done / release docs PR.
---

# Skill: Validate Docs (`/validate-docs`)

## Objective
Catch broken links/anchors and stale freshness stamps across the docs tree before a docs PR.
Mirrors `just validate-docs`.

## Trigger Patterns
- `/validate-docs` · "audit the docs", "check doc links", "docs freshness"

## Steps
```bash
just validate-docs
```
Reports: broken intra-repo links/anchors, and durable docs whose `Last verified` / `> Reviewed:`
stamp is older than current prod (a red flag — stamps bump at `/release-update`).

## Rules
- The pre-flight gate before `/sprint-update`, `/sprint-done`, and the release docs PRs.
- Read-only audit — reports; it does not rewrite stamps (that's the lockstep skills' job).
- Honor the owner's doc convention: every durable doc carries its canonical `~/...` self-path + per-section verified dates.
