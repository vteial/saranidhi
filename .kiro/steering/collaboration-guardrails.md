---
inclusion: always
---

# Saranidhi — Collaboration & Workflow Guardrails

> Auto-loads into every session. This file holds the **process doctrine** — how we
> work, who has authority, and the non-negotiable gates. For **code/architecture**
> rules see [`saranidhi-spec.md`](./saranidhi-spec.md); for product, `.kiro/product.md`.
> The full narrative lives in [`AI_COLLABORATION_FRAMEWORK.md`](../../AI_COLLABORATION_FRAMEWORK.md)
> and [`docs/process/dev-workflow.md`](../../docs/process/dev-workflow.md) — this is the terse must-obey summary.
> **Vocabulary note (cetana-labs family, adopted 2026-10-03 — see
> [`docs/process/PROCESS_MIGRATION.md`](../../docs/process/PROCESS_MIGRATION.md)).**
> Roles are **Operator** (Kiro) · **Executor** (Antigravity) · **Human** (owner).
> Lifecycle commands are `/plan-start · /plan-done · /sprint-start · /spec-run ·
> /verification-done · /review-pr · /sprint-done · /sprint-update · /release-*`.
> This is firm-wide so one process carries across every project.

## 1. Authority — the single most important rule

- **The Human owner is the SOLE merge & release authority.** The Operator (Kiro) NEVER
  merges to `main`/`prod`, NEVER runs `git merge`, NEVER pushes to `main`/`prod`, and
  NEVER creates tags or GitHub Releases. The Operator pushes branches and **opens PRs** only.
- **Two Human gates** per unit of work: (1) approve the **Spec merge** (`/plan-done`,
  merge-first), and (2) approve the final **squash-merge** (`/review-pr` → merge).
- Every write operation (plan, sprint, docs, release) goes through a **PR the owner
  merges** — no exceptions.

## 2. The three surfaces (roles & division of labor)

- **Operator — Kiro (Web/IDE, this agent + owner):** brainstorm, plan, author **Kiro
  Specs** (`.kiro/specs/<id>/`), PR **review**, governance, release workflow, corpus/CONF
  work. **Kiro Web CANNOT run `flutter test` / `flutter analyze` locally** — so it must
  never author-and-ship correctness-critical Dart on CI alone. Never merges; STOP-and-holds.
- **Executor — Antigravity (owner's Mac):** `/spec-run <id>` → implement on the `feat/`
  branch, run `flutter analyze`+`test` GREEN before the PR, open the PR, emit the Human
  Verification Plan, **STOP**; plus QA-Verify (smoke tests on the deployed build, records
  results, logs bugs; never edits source). Both are Executor sub-modes.
- **Human — the owner:** sets direction, both gates, sole merge + tag, doctrinal adjudicator.

## 3. Correctness-critical code → Spec → /spec-run → /review-pr

For any change touching calculation/engine logic (birth-bird, swara/nostril clock,
Oracle/Aruḍam scoring, DB migrations):
1. **Operator authors a precise Kiro Spec** (`requirements.md` EARS DoD — including the
   standing **Tamil bilingual** + **CONF provenance** criteria — `design.md`, `tasks.md`;
   exact files, logic, edge cases, tests, migration behavior) and **`/plan-done` merges
   it to `main`** (merge-first), so the dossier `docs/process/sprints/sprint-N-*/` records it.
2. **Executor runs `/spec-run <id>`**: implements + runs the local suite GREEN (except the
   known 4 CloudKit macOS failures) **before** opening the PR — CI-only is NOT sufficient
   (v1.2.1 lesson).
3. **Operator runs `/review-pr`** against the REAL DIFF (never the summary — summaries have
   been wrong before); recommends; **owner merges**.
- Low-risk pure-docs/l10n work may be done directly by the Operator (lead-paired, lighter contract).

> **State guards:** every lifecycle command is phase-aware — redundant/already-done ⇒
> skip + continue; missing prerequisite or gate ⇒ alert + HOLD. A wrong-order command may
> skip busywork but can **never** silently bypass a gate.

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

## 5. Protocols (cetana-labs family vocabulary — the `{phase|domain}-{action}` convention)

**Lifecycle (per unit of work):** `/plan-start` · `/plan-done` (merges the Spec,
merge-first) · `/sprint-start` · `/spec-run <id>` (Executor) · `/verification-done`
(Executor) · `/review-pr <PR>` (gate) · `/sprint-done` · `/sprint-update`.
**Release:** `/release-start` · `/release-finish` · `/release-update`.

> Old Saranidhi names (`/plan`, `/sprint-finish`, `/delegate`) and the earlier
> `/start-sprint`/`/finish-sprint`/`/project-update`/`/release-complete` are **deprecated**
> — do not use. Mapping lives in [`PROCESS_MIGRATION.md`](../../docs/process/PROCESS_MIGRATION.md) §4.

**Environment / ops DX (cetana family, realized as `just` recipes + mirror slash):**
`just setup-local` · `env-doctor` · `start-local` · `stop-local` · `validate-local` ·
`status-local` · `status-staging` · `validate-docs`; `/project-status` for the broadcast.

- **All lifecycle/release commands produce a PR the owner merges** (never a direct push to main).
- **Docs division of responsibility** (one job per doc, no duplication):
  `project-valuation-report.md` = investment/delivery (hours per phase + one-row-per-sprint
  table); `project-evaluation.md` = quality/defects (Resolved Defects + QC baseline);
  root `SPRINT_TRACKER.md` + `CHANGELOG.md` = per-feature inventory; `BACKLOG.md` = ideas;
  `git log` = commits.

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

- Coding delegation goes to the **Executor (Antigravity)** via `/spec-run <id>` against a
  merge-first Kiro Spec — never a loose prose brief.
- Google **Jules is retired** for this project (hangs + SDK mismatch; can't do interactive
  visual QA). Do not reopen.
