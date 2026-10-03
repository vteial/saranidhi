<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/skills/README.md
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# Saranidhi Slash-Command Skills (`PRJ-001`)

cetana-labs-family skills, saranidhi-adapted. Each `<name>/SKILL.md` is the executable
contract for one slash command. Vocabulary + roles are defined in
[`collaboration-guardrails.md`](../steering/collaboration-guardrails.md) and
[`dev-workflow.md`](../../docs/process/dev-workflow.md); the DX recipes live in the
[`justfile`](../../justfile) and are documented in
[`dx-commands.md`](../../docs/process/dx-commands.md).

## Lifecycle (per unit of work)
| Skill | Surface | Role |
| :--- | :--- | :--- |
| `plan-start` | Kiro Web | Operator — open brainstorm/Scope |
| `plan-done` | Kiro Web | Operator — finalize + **merge** the Spec (merge-first) |
| `sprint-start` | Kiro Web | Operator — open the sprint container |
| `spec-run` | Antigravity | Executor — build, open PR, STOP |
| `verification-done` | Antigravity | Executor — record human verify, STOP |
| `review-pr` | Kiro Web | Operator gate (owner merges) |
| `sprint-done` | Kiro Web | Operator — close the sprint container |
| `sprint-update` | Kiro Web | Operator — post-merge docs lockstep incl. STATUS.md |

## Environment / ops DX (mirror the `just` recipes)
`env-doctor` · `setup-local` · `start-local` · `stop-local` · `validate-local` ·
`status-local` · `status-staging` · `validate-docs` · `project-status`

## Non-negotiables every lifecycle skill preserves
- **Operator (Kiro) NEVER merges or tags** — branches + PRs only; owner is sole merge/release authority.
- **Tamil bilingual gate** (RT), **CONF provenance** (RC), **2-tier CI + ≥19% coverage + integration gate** (RQ).
- **State guards:** redundant/already-done ⇒ skip + continue; missing prerequisite/gate ⇒ alert + HOLD. Never silently bypass a gate.
