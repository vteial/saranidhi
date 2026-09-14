---
inclusion: always
---

# Saranidhi — Collaboration & Workflow Guardrails

> Auto-loads into every session. This file holds the **process doctrine** — how we
> work, who has authority, and the non-negotiable gates. For **code/architecture**
> rules see [`saranidhi-spec.md`](./saranidhi-spec.md); for product, `.kiro/product.md`.
> The full narrative lives in [`AI_COLLABORATION_FRAMEWORK.md`](../../AI_COLLABORATION_FRAMEWORK.md)
> and [`docs/process/dev-workflow.md`](../../docs/process/dev-workflow.md) — this is the terse must-obey summary.

## 1. Authority — the single most important rule

- **The human owner is the SOLE merge & release authority.** Kiro NEVER merges to
  `main`/`prod`, NEVER runs `git merge`, NEVER pushes to `main`/`prod`, and NEVER
  creates tags or GitHub Releases. Kiro pushes branches and **opens PRs** only.
- Every write operation (plan, sprint, docs, release) goes through a **PR the owner
  merges** — no exceptions.

## 2. The two-tool division of labor

- **Kiro Web (this agent + owner):** planning, docs, specs, PR **review**, release
  workflow, corpus/CONF work, and code/PRs. **Kiro Web CANNOT run `flutter test` /
  `flutter analyze` locally** — so it must never author-and-ship correctness-critical
  Dart on CI alone.
- **Antigravity IDE (owner's Mac):** actual Dart **implementation** with a local green
  test run before the PR, plus QA-Verify (executes smoke tests on the deployed build,
  records results, logs bugs; never edits source).

## 3. Correctness-critical code → spec → coding-setup → review

For any change touching calculation/engine logic (birth-bird, swara/nostril clock,
Oracle/Aruḍam scoring, DB migrations):
1. **Kiro Web authors a precise sprint spec** (exact files, logic, edge cases, tests,
   migration behavior, DoD) in the sprint dossier `docs/process/sprints/sprint-N-*/`.
2. **Antigravity implements + runs the local suite GREEN** (except the known 4 CloudKit
   macOS failures) **before** opening the PR — CI-only is NOT sufficient (v1.2.1 lesson).
3. **Kiro Web reviews the REAL DIFF** (never the summary — summaries have been wrong
   before) and approves; owner merges.
- Low-risk pure-docs/l10n work may be done directly in Kiro Web.

## 4. Non-negotiable pre-PR gates

- **Local green baseline** for correctness-critical code (see §3).
- **Tamil-mode gate:** every user-facing string is bilingual EN + **pure Tamil script**
  (no transliteration, no hardcoded English). Eyeball Tamil mode before the PR. This is
  the recurring miss (v1.8.1) — check partially-localized widgets especially.
- **Regression gate:** state explicitly what must stay UNCHANGED and pin it with tests,
  especially in extraction/refactor sprints (that's where behavior silently drifts).
- **Provenance:** every doctrinal rule/feature cites its corpus practice + resolved
  `CONF-nn` (Sara Kalai) / `CONF-PP-nn` (Panja Pakshi). The owner's lineage decision in
  the CONF tracker IS "source truth" when sources conflict.

## 5. Protocols (current names — the `{domain}-{action}` convention)

`/plan` · `/sprint-start` · `/sprint-finish` · `/sprint-update` · `/release-start` ·
`/release-finish` · `/release-update`. (Old names `/start-sprint`, `/finish-sprint`,
`/project-update`, `/release-complete` are **deprecated** — do not use.)

- **All of these produce a PR the owner merges** (never a direct push to main).
- **Docs division of responsibility** (one job per doc, no duplication):
  `project-valuation-report.md` = investment/delivery (hours per phase + one-row-per-sprint
  table); `project-evaluation.md` = quality/defects (Resolved Defects + QC baseline);
  `sprint-tracker.md` + `CHANGELOG.md` = per-feature inventory; `git log` = commits.

## 6. Release lifecycle (two-phase, owner-gated)

`/release-start` (branch `release/vX.Y.Z`, **bump pubspec** first commit, author the
rich-release dossier folder `docs/testing/releases/vX.Y.Z/` with smoke-test + release-notes
+ docs-audit + qa-verify-prompt, **pre-fill the deterministic preview URL AND the PR # so
the owner handoff is a one-liner**) → owner runs the smoke on the **PR's Vercel preview**
(NOT staging — staging deploys from `main`) → `/release-finish` (open the **main→prod**
promotion PR; never skip it) → owner merges + tags `vX.Y.Z-**web**` (the `-web` suffix is
the convention; distinguishes the future `-mobile` track) → `/release-update` (CHANGELOG
date, smoke-index row, bump the `> Reviewed:` stamp on all durable docs, flip tracker to
✅ 🚀, refresh README/valuation current-state).

- **Docs-freshness gate:** each durable doc carries `> **Reviewed:** vX.Y.Z-web`. A stamp
  older than current prod is a red flag. Owner ticks `docs-audit-*.md` at release; stamps
  bump at `/release-update` (release-gated, NOT sprint-gated).
- **QA-Verify preview auth:** the preview is behind Vercel Deployment Protection — the
  QA-Verify prompt uses `VERCEL_AUTOMATION_BYPASS_SECRET` from local `.env` (gitignored)
  as `?x-vercel-protection-bypass=<secret>&x-vercel-set-bypass-cookie=true`.
- **Bug found in QA → fix on the SAME release branch → re-verify that scenario.** A
  minor, pre-existing, cosmetic bug may ship as an owner-accepted, backlogged known defect.

## 7. Deployment quota (Vercel Hobby 100/day)

- A **skipped `ignoreCommand` build still counts** as a deployment; the repo has **two**
  Vercel projects. The real lever is `vercel.json` **`git.deploymentEnabled`**, which
  denies `docs/**` + `plan/**` (never deploy → never count). **Keep that deny-list in
  sync with the branch-naming convention** below.

## 8. Branch naming (drives the deploy allow/deny + release flow)

- **Code branches (get a Vercel preview):** `sprint/*`, `release/*`, `fix/*`.
- **Docs/planning branches (NO deploy):** `docs/*`, `plan/*`.
- The branch selected at session start may not be `main`; when it isn't, commit/push to it
  and open the PR from it — do not create a new branch unless asked.

## 9. Delegation

- Google **Jules is retired** for this project (hangs + SDK mismatch; can't do interactive
  visual QA). Do not reopen. Coding delegation goes to the Antigravity IDE setup.
