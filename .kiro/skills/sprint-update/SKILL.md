---
name: sprint-update
description: >-
  AFTER merge, synchronizes Saranidhi's (PRJ-001) durable docs on a separate docs/ branch, the
  Operator surface (Kiro Web). Updates the valuation report, evaluation, testing plan, User Guide /
  calc-methodology for capability changes, and root STATUS.md — the docs lockstep that keeps the
  owner's personal cetana portfolio dashboard current. Use when the user runs /sprint-update after a PR merges.
---

# Skill: Sprint Update (post-merge docs lockstep)

## Objective
After a feature PR has **merged to `main`**, bring the durable docs into sync on a separate
`docs/*` branch — the lockstep that keeps the record (and the owner's portfolio dashboard)
truthful. Runs on the **Operator** (Kiro Web).

## Trigger Patterns
- `/sprint-update` · "update the docs after merge", "run the docs lockstep"

## Steps
### 1. State guard (phase-aware)
- **A PR has merged since the last update ⇒ proceed.**
- **Nothing merged (redundant) ⇒ skip + continue:** "No merge since the last `/sprint-update`."

### 2. Update the durable docs (one job per doc — no duplication)
- `project-valuation-report.md` — investment/delivery: hours (AI estimate +20% buffer) + the one-row-per-sprint table.
- `project-evaluation.md` — quality/defects: Resolved Defects + QC baseline.
- `docs/testing/` testing plan — new/changed test coverage.
- **User Guide / calc-methodology** — ONLY for a capability change (new feature, changed calc). Cite the CONF where doctrine changed.
- Root **`STATUS.md`** (PRJ-001) — `Last Updated`, deliveries, focus. Keep the cetana 35-line schema. **This is the portfolio-dashboard integration contract — never let it go stale.**
- Root `SPRINT_TRACKER.md` — flip the merged item to ✅ Done; `CHANGELOG.md` entry confirmed present.

### 3. Doc hygiene (owner preference)
- Every touched durable doc carries its canonical `~/...` self-path header + a per-section `Last verified` / `Reviewed:` date. Bump the stamp.

### 4. Open the docs PR
```bash
just validate-docs
git checkout -b docs/update-<SPRINT-NN>
git add <touched docs> STATUS.md SPRINT_TRACKER.md
git commit -m "docs: lockstep update after <SPRINT-NN> merge"
git push -u origin docs/update-<SPRINT-NN>
gh pr create --base main --head docs/update-<SPRINT-NN> --title "docs: lockstep update <SPRINT-NN>" --body "<summary>"
```
- `docs/*` branch → **no Vercel deploy**. The **owner merges**.

## Rules
- **Runs AFTER merge** on a **separate `docs/` branch** — never mixed with the feature PR.
- **One job per doc** — valuation = investment, evaluation = quality, tracker/CHANGELOG = inventory. No duplication.
- **STATUS.md is in the lockstep** — the dashboard goes stale if it's skipped.
- Doc-freshness stamp bumps are release-gated for the `> Reviewed:` prod stamp (that's `/release-update`); `/sprint-update` keeps the content current.
- **Operator / Kiro Web only** — Operator never merges or tags.
