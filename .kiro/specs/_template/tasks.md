<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/_template/tasks.md
  Saranidhi Kiro Spec — TASKS template (the ordered /spec-run build plan, run by the Executor).
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# <Feature Title> — Tasks (`/spec-run` build plan)

## Execution header
- **Kickoff:** `/spec-run <spec-id>`
- **Surface:** Executor (Antigravity) + local web build / PR preview for verification
- **Branch to create:** `sprint/<spec-id>` (off up-to-date `main`; `fix/*` for a bug)
- **EARS target (DoD):** `requirements.md` §3 R1..Rn + the STANDING RT / RC / RQ criteria;
  verify against §4b (V1.., VT, VQ)
- **Merge-first:** this Spec must be on `main` before kickoff (satisfied by `/plan-done`)

> Ordered plan for `/spec-run` (Executor / Antigravity). Executes the tasks, self-validates
> against the `requirements.md` EARS DoD, opens a PR into `main`, emits the Human Verification
> Plan (§4b), and **STOPs in verification**. **Never merges, never tags.**

- [ ] **T0 — Preflight (gate — STOP on any ❌)**
  - Confirm P1–P5: on `sprint/<spec-id>` off up-to-date `main`, clean tree; `just env-doctor`
    green; baseline `just validate-local` green (except the 4 CloudKit macOS failures).

- [ ] **T1 — <first functional task> (R1)**
  - <concrete change; cite the file(s) in scope>.

- [ ] **T2 — <next task> (R2)**
  - <...>

- [ ] **TL — Localization (RT)**
  - Add EN + pure-Tamil ARB keys for every new string; regenerate `lib/l10n/generated/`;
    eyeball Tamil mode (RT.1–RT.3). No hardcoded English, no transliteration.

- [ ] **TC — CONF provenance (RC — doctrinal work only)**
  - Cite corpus practice + resolved CONF in §1 and the PR body; reference the owner's
    lineage decision by id where sources conflict.

- [ ] **TG — Governance lockstep**
  - `CHANGELOG.md` `[Unreleased]` entry for the task id. `SPRINT_TRACKER.md` status coherent
    (→ 👀 In Review on the PR; ✅ Done in the post-merge tidy). STATUS.md untouched here
    (it is updated at `/sprint-update` / `/release-update`, not per-task).

- [ ] **TQ — Quality gates + no-regression (RQ)**
  - `just validate-local` green; coverage ≥ 19%; integration gate green; the §2 "unchanged"
    behaviors pinned by a test (RQ.3).

- [ ] **TP — Commit, open PR, emit Human Verification Plan, STOP**
  - Commit `feat(<scope>): <spec-id> — <summary> (TSK-xxx)`; `git push -u origin sprint/<spec-id>`;
    `gh pr create --base main --head sprint/<spec-id> ...`. CI green. Emit §4b (V1.., VT, VQ).
    STOP in verification. **Never merge, never tag.**

- [ ] **TV — After human verification passes: `/verification-done`**
  - Human runs §4b (esp. VT Tamil mode). Fixes ride the SAME PR (Single-PR rule).
    On pass → `/verification-done` → `/review-pr` (Operator gate) → owner merges.
