---
name: spec-run
description: >-
  The Executor (Antigravity) one-liner that executes a merged Kiro Spec end-to-end for Saranidhi
  (PRJ-001) — the "implement" phase. Given only a spec id it syncs main, self-checks the phase
  state, runs a silent preflight, cuts the branch the Spec names, executes tasks.md, self-validates
  against the requirements.md EARS DoD (incl. the standing RT/RC/RQ criteria), opens a PR, emits the
  Human Verification Plan, and STOP-and-holds. NEVER merges, never tags. Use when the user runs
  /spec-run <spec-id>.
---

# Skill: Run a Spec (`/spec-run <spec-id>`)

## Objective
Make executing a Kiro Spec a **true one-liner** on the **Executor** (Antigravity). You supply
only the **spec id**; the skill owns everything repeatable (git sync, branch, preflight, PR
mechanics) so attention goes only to what varies: the functional change and its verification
(the Spec's `tasks.md` + EARS DoD). It ends by opening a PR and **STOP-and-holds** for the
human gate (`/review-pr`). It **never merges and never tags** — the owner is sole merge/release authority.

### Lifecycle position & merge-first
```
/plan-start* → /plan-done   →   /spec-run <id>   →   /verification-done  →  /review-pr <PR>  →  /sprint-done
  (Operator — merges Spec)       THIS SKILL             (Executor)            (Operator gate)      (Record)
```
- **Merge-first (precondition):** the Spec is merged to `main` during `/plan-done`. That's what
  lets `/spec-run` need only the id — the Spec is already on `main`. If it isn't, STOP and say
  "merge the plan first."

## Trigger Patterns
- `/spec-run <spec-id>` (e.g. `/spec-run graceful-sync-errors`)
- "run the <id> spec", "implement <spec-id>"

## Steps
### 1. Surface gate + sync main (the skill owns this)
- Confirm the surface is the **Executor (Antigravity)** with a local Flutter toolchain able to
  run `just validate-local`. If on Kiro Web (Operator), STOP: "Spec runs need the Executor — it
  runs `flutter analyze`/`test`/`build web`, which Kiro Web cannot."
- Sync `main` so the merged Spec is present:
  ```bash
  git fetch origin && git checkout main && git pull --ff-only origin main
  ```

### 2. State guard — resolve the Spec on `main` (merge-first check)
- Look for `.kiro/specs/<spec-id>/` **on `main`**.
  - **Present ⇒ proceed.**
  - **Missing, open plan PR exists ⇒ ALERT + HOLD:** "Spec `<id>` isn't on `main` yet (plan PR #NN). Merge the plan first, then re-run `/spec-run <id>`."
  - **Missing entirely ⇒ STOP** and `ls .kiro/specs/`.
- Read `requirements.md` (EARS DoD + §0 + RT/RC/RQ), `design.md`, `tasks.md` (Execution header: branch, surface, EARS target).
- Echo a one-line plan: spec id · target branch · task count.

### 3. Silent preflight (surfaced ONLY if broken)
- Run T0 / §0 pre-checks: clean tree, `just env-doctor` green, deps installed, baseline
  `just validate-local` green (except the 4 known CloudKit macOS failures).
- All green ⇒ ONE line (`✅ Preflight OK — proceeding`). Any fail ⇒ ✅/❌ table + STOP-and-hold.

### 4. Create the branch the Spec names
- Read the branch from the Execution header (e.g. `sprint/<spec-id>`; `fix/*` for a bug) — don't invent one.
  ```bash
  git checkout -b <branch-from-spec>   # or checkout if resuming
  ```
- Confirm current branch is **not** `main`/`prod`.

### 5. Execute `tasks.md` in order (the FUNCTIONAL concern)
- Work tasks sequentially; check each off as its cited requirement is satisfied. Honor per-task STOP conditions.
- The Spec's **Out of Scope** is a hard boundary.
- **TL (Tamil) and TC (CONF) are not optional** for user-facing / doctrinal work — a hardcoded
  English string or a missing CONF citation fails the DoD.
- Blocked task ⇒ STOP + report which + why; never silently skip.

### 6. Self-validate against the EARS DoD (the VERIFICATION concern)
- Walk every acceptance criterion (R1.., **RT**, **RC**, **RQ**). Run the gates:
  ```bash
  just validate-local       # analyze --fatal-infos + test + build web
  ```
- Eyeball **Tamil mode** (RT.2 — the recurring miss). Confirm coverage ≥ 19% + integration gate green (RQ.2).
- Any unmet/unverifiable criterion ⇒ resolve or STOP. A green build is necessary but not sufficient — the DoD is the bar.

### 7. Commit, open the PR, STOP (never merge, never tag)
- Governance lockstep: `CHANGELOG.md [Unreleased]` entry; `SPRINT_TRACKER.md` status → 👀 In Review.
  ```bash
  git commit -m "feat(<scope>): <spec-id> — <summary> (TSK-xxx)"
  git push -u origin <branch>
  gh pr create --base main --head <branch> --title "feat: <spec-id>" --body "<DoD rollup + Spec link>"
  ```
- Ensure CI goes green (Tier-1: analyze + domain/provider test + build web).

### 8. Emit the Human Verification Plan, then STOP
- Read §4b from the Spec's `requirements.md` and emit it inline:
  > "PR #NN is open and CI is green. **Human verification (please run these):** V1 … · VT (Tamil mode) … · VQ (gates) … — report anything that fails; I'll push fixes to *this* PR (Single-PR rule). When it passes, run **`/verification-done`**."
- **STOP-and-hold.** Do not merge, do not tag, do not jump to `/review-pr`.

## Rules
- **You supply only the spec id.** The skill owns all repeatable steps.
- **Merge-first:** the Spec must be on `main`. Missing ⇒ HOLD ("merge the plan first"); never fabricate it.
- **NEVER merge, NEVER tag, never post an approving review** — this skill implements + opens; the owner gates and merges.
- **STOP-and-hold** on: wrong surface, missing Spec, failed preflight, blocked task, and always after opening the PR + emitting the verification plan.
- **The Spec is the single source of truth** — branch, scope, tasks, verification all live in it; no inline overrides.
- **The standing RT (Tamil) / RC (CONF) / RQ (gates) criteria are part of every DoD** — a feature that skips them is not done.
- GitHub via `gh pr create` (works in this repo's environment).
