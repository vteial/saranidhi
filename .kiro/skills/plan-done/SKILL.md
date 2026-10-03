---
name: plan-done
description: >-
  Closes a planning/brainstorm session for Saranidhi (PRJ-001) by finalizing the Kiro Spec and
  MERGING it to main as a docs PR — the merge-first rule that lets /spec-run <id> be a clean
  Executor one-liner. The Operator (Kiro) opens the PR; the owner merges. Use when the user runs
  /plan-done or says planning is finished.
---

# Skill: Plan Done (close Scope, merge the Spec)

## Objective
Close the **brainstorm / Scope** phase for a topic by finalizing its Kiro Spec and **getting it
merged to `main` as a docs PR**. This merge is the **merge-first rule**: once the Spec is on
`main`, `/spec-run <spec-id>` needs only the id (no manual branch/path hand-off). Runs on the
**Operator** surface (Kiro Web).

## Trigger Patterns
- `/plan-done`
- "planning is done", "finalize the spec", "we're ready to build this"

## Steps
### 1. State guard (phase-aware)
- **In PLANNING with a drafted Spec ⇒ proceed.**
- **Nothing drafted (missing prerequisite) ⇒ ALERT + HOLD:** "Nothing to close — no Spec drafted. Brainstorm first (`/plan-start`)."
- **Already merged (redundant) ⇒ skip + continue:** "Spec `<id>` is already on `main` — ready for `/spec-run <id>`."

### 2. Finalize the Spec
- Ensure `.kiro/specs/<id>/` is complete + self-describing: `requirements.md` (EARS DoD + §0
  preconditions + the STANDING **RT / RC / RQ** criteria), `design.md`, `tasks.md` (ordered plan
  + Execution header: kickoff `/spec-run <id>`, surface = Executor, branch `sprint/<id>`, EARS target).
- A Spec missing these is not ready — `/spec-run` would STOP.
- Confirm backlog rows (`TSK-`/`BK-`) are consistent (governance lockstep).

### 3. Merge as a docs PR (the merge-first step)
- Branch `docs/<slug>` (a `docs/*` branch — **no Vercel deploy**, zero quota).
  ```bash
  git checkout main && git pull --ff-only origin main
  git checkout -b docs/<slug>
  git add .kiro/specs/<id>/ SPRINT_TRACKER.md BACKLOG.md
  git commit -m "docs(spec): author <id> (merge-first)"
  git push -u origin docs/<slug>
  gh pr create --base main --head docs/<slug> --title "docs(spec): <id>" --body "<DoD rollup + link>"
  ```
- The **owner merges** (Operator never merges). After merge, `.kiro/specs/<id>/` is on `main`.
- Confirm: "Spec `<id>` is ready to merge in PR #NN. After you merge, kick off: `/spec-run <id>`."

## Rules
- **Operator / Kiro Web only** — the output is a Spec PR, not code.
- **Merge-first is the point** — the Spec must reach `main` here. Don't hand off to `/spec-run` while it's unmerged.
- **The Spec must be self-describing before merge** (Execution header + §0 + EARS DoD incl. RT/RC/RQ).
- **Operator NEVER merges** — opens the PR; the owner merges.
- **State-guard:** nothing-planned ⇒ HOLD; already-merged ⇒ skip+continue.
