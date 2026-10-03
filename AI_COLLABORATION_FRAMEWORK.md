<!--
  Canonical path: ~/dev-home/personal/saranidhi/AI_COLLABORATION_FRAMEWORK.md
  RETIRED 2026-10-03 (v1.13.0-web). This file is a redirect stub kept so inbound links
  and the audit trail survive — it is intentionally NOT git-rm'd.
-->
# AI Collaboration Framework — RETIRED

> **Retired 2026-10-03 (v1.13.0-web).** This 470-line narrative had outlived its purpose:
> its role model + lifecycle were duplicated (and had gone stale) against the authoritative
> process docs, and its BA/Architect/QA-Design persona cast was an obsolete seat model.
> The content now lives, current and non-duplicated, in the places below.

## Where it went

| What you wanted here | Now lives in |
| :--- | :--- |
| Roles, authority, two gates, lifecycle, tool→role mapping, state guards | [`.kiro/steering/collaboration-guardrails.md`](.kiro/steering/collaboration-guardrails.md) — the must-obey summary |
| The step-by-step sprint/release workflow (universal Flows 3 & 4) | [`docs/process/dev-workflow.md`](docs/process/dev-workflow.md) |
| **Flows 1 & 2 — Knowledge Capture + CONF Resolution** (saranidhi-only doctrine) | [`docs/process/doctrine-flows.md`](docs/process/doctrine-flows.md) |
| Vocabulary migration record + role/tool decisions | [`docs/process/PROCESS_MIGRATION.md`](docs/process/PROCESS_MIGRATION.md) |
| Executable slash commands | [`.kiro/skills/`](.kiro/skills/) · Kiro Specs: [`.kiro/specs/`](.kiro/specs/) |

## Methodology provenance (not a dependency)

Saranidhi runs the **cetana-labs family methodology**, vendored in and owned here —
**cetana-labs** (LAB-000) and **nexus-pulse** (LAB-003) are the firm's live reference
implementations and the inspiration, cited as **provenance only**. Saranidhi is
self-contained: it adapts the best ideas from the firm and the outside world but never
depends on an external repo at runtime, and self-cleans outdated docs via the
`just validate-docs` gate.

<!-- Reviewed: v1.13.0-web -->
