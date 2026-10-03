---
name: project-status
description: >-
  Emits Saranidhi's (PRJ-001) executive status by reading root STATUS.md — the project row the
  owner's personal cetana-labs portfolio dashboard consumes. Use when the user runs /project-status
  or asks for an executive update / portfolio status.
---

# Skill: Project Status Broadcast (`/project-status`)

## Objective
Produce a mobile-friendly, executive-ready status for saranidhi by reading the authoritative root
`STATUS.md` (PRJ-001, cetana 35-line schema). This is the project's contribution to the owner's
**personal cetana-labs portfolio dashboard**, which reads each project's root `STATUS.md`.

## Trigger Patterns
- `/project-status` · "executive update", "portfolio status", "share status"

## Steps
1. Read root `STATUS.md` — the single source of truth (do NOT recompute metrics from git/chat; the dashboard reads this file, so the broadcast must match it).
2. Emit the digest from its sections: Health badge, Project ID (PRJ-001), Dev Environment (💻 Local), Last Updated, Latest Deliveries & Business Wins, Current Focus & Next Milestone.
3. If `Last Updated` is older than ~14 days, append a cadence reminder (run `/sprint-update`).

## Presentation (mobile/WhatsApp-safe)
- `*bold*` for headings (no `**`), `_italic_` for dates, ASCII dividers (`━━━`), **no markdown tables**.

## Rules
- **STATUS.md is the source of truth** — never fabricate or recompute; a stale STATUS.md is fixed by `/sprint-update`, not by the broadcast inventing numbers.
- Read-only.
- Keep STATUS.md at the cetana 35-line schema so the portfolio scraper parses it.
