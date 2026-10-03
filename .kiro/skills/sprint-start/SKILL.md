---
name: sprint-start
description: >-
  Opens the SPRINT CONTAINER in Saranidhi (PRJ-001), the Scope phase on the Operator surface
  (Kiro Web). Creates the Current Sprint block in root SPRINT_TRACKER.md (next SPRINT-NN id, goal,
  planned items incl. carry-forwards) and syncs the STATUS.md focus line. A sprint CONTAINS MANY
  plans: within it you run /plan-start → /plan-done per feature (each producing one merged Spec).
  Pairs with /sprint-done. Use when the user runs /sprint-start or asks to start a new sprint.
---

# Skill: Sprint Kickoff (`/sprint-start`)

## Objective
Open the **sprint container** — the top-level Scope artifact. It initializes the Current Sprint
block in root `SPRINT_TRACKER.md` (id, window, goal, planned items) and is the counterpart to
`/sprint-done`. Runs on the **Operator** (Kiro Web) — no code.

### Lifecycle position (sprint ⊃ plans ⊃ Spec)
```
/sprint-start  ── opens the SPRINT container (SPRINT-NN, goal)      [once per sprint]
   └── /plan-start … /plan-done   ── a planning session per feature  [many per sprint]
          └── output: a MERGED Spec (.kiro/specs/<id>/)
                 └── /spec-run <id>  →  /verification-done  →  /review-pr  →  /sprint-done
```

## Trigger Patterns
- `/sprint-start` · `/sprint-start <goal>` · "start a new sprint", "plan the next sprint"

## Steps
### 0. State guard (phase-aware)
- **No active sprint (or prior closed) ⇒ proceed.**
- **A sprint is already active (redundant) ⇒ skip + continue:** report "SPRINT-NN is already active" and offer to refine the goal / replan items; don't create a duplicate block.
- **Prior sprint has unclosed delivered work ⇒ ALERT:** suggest `/sprint-done` first so carry-forwards compute correctly.

### 1. Determine the next sprint
1. Read root `SPRINT_TRACKER.md`; find the highest `SPRINT-NN`.
2. Next id = increment, zero-padded.
3. Set the window + goal.

### 2. Compose the Current Sprint block
- Write/replace the **Current Sprint** section: Sprint ID, window, goal, Status 🟢 Active, Lead,
  and a Sprint Items table using the status vocabulary (`✅ Ready` once a Spec is merged / `🔨 In
  Progress` / `🔍 In Verification` / `👀 In Review` / `✅ Done` / `📋 Backlog`).
- **Carry forward** incomplete items from the prior sprint.
- Assign new `TSK-xxx` ids continuing the global sequence — scan **both** `SPRINT_TRACKER.md` and `BACKLOG.md` first (no gaps/dupes).

### 3. Sync focus
- Update the Current-Focus line in root `STATUS.md` to the new sprint goal (keep the cetana 35-line schema intact).

### 4. Commit
- `docs/*` or `plan/*` branch (no Vercel deploy) → PR → owner merges. Commit `docs(governance): start <SPRINT-NN> — <theme>`.

### 5. Hand off to per-feature planning
- Remind the owner of the within-sprint flow: `/plan-start` → `/plan-done` (merges the Spec) → `/spec-run <id>` (Executor) → `/verification-done` → `/review-pr` → `/sprint-done`.

## Rules
- **Container vs. plan:** `/sprint-start` opens the sprint; individual feature Specs are authored in `/plan-start` sessions.
- Guard against duplicate `TSK` ids — scan both trackers before assigning.
- Keep `SPRINT_TRACKER.md` + `CHANGELOG.md` in lockstep; `BACKLOG.md` is the `BK-` idea source.
- **Operator / Kiro Web only** — no code, no feature branch (that's `/spec-run`). Operator never merges.
