---
name: plan-start
description: >-
  Opens a planning/brainstorm session within the current sprint for Saranidhi (PRJ-001), the
  Scope phase on the Operator surface (Kiro Web). Frames a topic for brainstorming, backlog
  prep, and authoring a Kiro Spec. OPTIONAL and IMPLICIT — any free-form topic is treated as a
  plan-start. Produces no code. Use when the user runs /plan-start or begins brainstorming a feature.
---

# Skill: Plan Start (Brainstorm / Scope opener)

## Objective
Open the **brainstorm / Scope** phase for one feature or topic — set direction, weigh options,
prep the backlog, and (for correctness-critical work) author a **Kiro Spec** at
`.kiro/specs/<id>/`. Runs on the **Operator** surface (Kiro Web) and produces **no code** —
its output is a plan that `/plan-done` later merges to `main`.

### Granularity — nested under the sprint
```
/sprint-start  ── opens the SPRINT container          [once per sprint]
   └── /plan-start …/plan-done   ── a PLANNING session, per feature   [many per sprint]
          └── output: a MERGED Spec (.kiro/specs/<id>/)
                 └── /spec-run <id>  →  /verification-done  →  /review-pr  →  /sprint-done
```

## Trigger Patterns
- `/plan-start [topic]`
- **Implicit:** any free-form brainstorming request ("let's design…", "how should we approach…").

## Steps
### 1. State guard (phase-aware)
- **Already PLANNING (redundant) ⇒ skip + continue:** fold the new topic in; don't re-open.
- **No active sprint (missing prerequisite) ⇒ ALERT (soft):** steer to `/sprint-start` first, or confirm unscoped planning.
- **Mid-build / in-review ⇒ ALERT:** confirm the context-switch, then proceed.

### 2. Frame the planning session
- State the topic, the sprint it sits under, and the surface (Kiro Web / Operator).
- Identify the output artifact: a **Kiro Spec** (`cp -r .kiro/specs/_template .kiro/specs/<id>/`)
  and/or backlog rows (`TSK-`/`BK-` in `SPRINT_TRACKER.md` / `BACKLOG.md`).
- Brainstorm options + trade-offs; the human sets direction (human-directed, AI-assisted).
- For doctrinal work, surface the corpus practice + the CONF to resolve (RC).

### 3. Hand off to close
- When decisions are made and the Spec drafted, close with **`/plan-done`** — which merges
  the Spec to `main` (merge-first), the thing that makes `/spec-run <id>` a clean one-liner.

## Rules
- **Operator / Kiro Web only** — no code, no branch, no build. Stateful execution is `/spec-run` (Executor).
- **Optional/implicit** — never block a free-form brainstorm waiting for the command.
- **Nested under a sprint** — steer to `/sprint-start` if none is active.
- **State-guard:** redundant ⇒ skip+continue; missing prerequisite ⇒ alert.
