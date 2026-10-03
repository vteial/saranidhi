---
name: brainstorm-save
description: >-
  Captures the current planning/brainstorm session's KEY DECISIONS as a curated entry appended to
  docs/governance/DECISION-JOURNAL.md for Saranidhi (PRJ-001) — the reasoning showcase
  (problem → options → decision → outcome), attributed to the contributor. PROMPTED, never
  auto-run, by /plan-done when the session held real decisions. Use when the user runs
  /brainstorm-save or asks to record the session's decisions/thinking.
---

# Skill: Brainstorm Save (curated decision capture)

## Objective
Distil a planning session into a **curated decision narrative** appended to
[`docs/governance/DECISION-JOURNAL.md`](../../../docs/governance/DECISION-JOURNAL.md) — the
"how we reasoned" record. `CHANGELOG.md` = *what shipped*; the Kiro Spec = *the formal
contract*; this journal = the ***thinking***. It is **signal, not a transcript** — only genuine
decisions, with honest trade-offs. Provenance: vendored from the cetana-labs family; saranidhi
owns this copy.

## Trigger Patterns
- `/brainstorm-save`
- "capture this session's decisions", "record our thinking", "save the brainstorm"

## Steps
### 1. Identify what's journal-worthy (curate, don't pad)
- Scan the session for **real decisions**: a choice between options, a direction set, a trade-off resolved, a course-correction.
- **Exclude** pure execution (routine fixes, builds, mechanical edits). No meaningful decision ⇒ say so and write **nothing** (protects the journal's credibility).

### 2. Determine the entry number & contributor
- Read the last `## Entry NNN`; new entry = `NNN+1`, zero-padded to 3.
- Contributor from `git config user.name`/`user.email` (owner = Eialarasu / `vteial`). Attribute each decision to who made the call; human-directed / AI-assisted.

### 3. Write the entry (append; never rewrite prior entries)
```markdown
---

## Entry NNN — <short session title>

**Date:** YYYY-MM-DD · **Contributor(s):** <name(s)> · **Mode:** <Operator / Executor> · **Outcome:** <Specs / PRs / releases>

### D<n> — <decision title>
- **Trigger:** <what surfaced this>
- **Options:** <options weighed>
- **Decision & rationale:** <the call + WHY, in the contributor's reasoning>  _(Contributor: <name>)_
- **Outcome:** <Kiro Spec / PR #N / TSK-xxx / CONF-nn>
```
- One `D<n>` block per decision; reference concrete artifacts (PR #N, `TSK-xxx`, `CONF-nn`, spec id).
- For **doctrinal** decisions, cite the resolved CONF (ties to the RC provenance rule).
- Optionally close with a short **Session meta** (division of labor, course-corrections, honest misses).

### 4. Governance & commit
- Faithful + credible — include course-corrections and honest misses; never inflate.
- Append on the current docs branch (or the plan's `docs/*` branch at `/plan-done`); the **owner merges**.

## Relationship to other commands
- **`/plan-done`** PROMPTS this (never auto-runs it) when the session held decisions — curation stays human-controlled (auto-running every session pollutes the journal).

## Rules
- **Curate ruthlessly** — a padded journal loses its value.
- **Attribute honestly** — name who made each call; human-directed / AI-assisted.
- **Append-only** — never edit or delete prior entries (historical record / audit integrity).
- **Operator surface** — the journal is governance, not code; the owner merges.
