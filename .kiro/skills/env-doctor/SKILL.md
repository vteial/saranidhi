---
name: env-doctor
description: >-
  Audits the Saranidhi (PRJ-001) local toolchain — flutter doctor, Dart SDK, Chrome (web build),
  pnpm/node — the "is my machine set up?" command. Mirrors `just env-doctor`. Diagnoses the
  ENVIRONMENT only; work-correctness is /validate-local. Use when the user runs /env-doctor or a
  tool/binary seems missing.
---

# Skill: Environment Doctor (`/env-doctor`)

## Objective
Confirm the local toolchain is correctly set up to build/verify saranidhi, before any work.
Mirrors `just env-doctor`. This is the **environment** boundary — it does NOT run the quality
gates (that's `/validate-local`).

## Trigger Patterns
- `/env-doctor` · "is my machine set up?", "flutter doctor", "why can't I build?"

## Steps
```bash
just env-doctor
```
Reports: `flutter` on PATH + `flutter doctor` summary, Dart SDK, Chrome (web target), pnpm/node,
`just` itself. Flags anything missing with the fix (per `~/my-works/PERSONAL_MACHINE_GUIDE.md`:
Homebrew-managed, `flutter 3.47.5` cask, pnpm@10.27.0 / Node ≥22, `uv` for Python).

## Rules
- **Environment only** — if a binary is missing, point the user here and stop; don't diagnose the environment inside `/validate-local`.
- Advisory/read-only — never installs or mutates the toolchain without the user asking.
- Distinguish a genuine gap from an agent-sandbox artifact (EPERM on scratch, TCC-protected paths) — re-run from a neutral CWD or defer to the user's own shell before reporting breakage.
