---
name: validate-local
description: >-
  Runs the full local pre-flight for Saranidhi (PRJ-001) — flutter analyze --fatal-infos +
  flutter test --coverage (≥19%) + flutter build web — the single "is everything green locally?"
  command and the local mirror of Tier-1/Tier-2 CI. Mirrors `just validate-local`. Use when the user
  runs /validate-local or asks to validate before commit/PR.
---

# Skill: Local Pre-Flight Validation (`/validate-local`)

## Objective
One command that runs every check CI would run, so a change is known green before committing or
opening a PR. Mirrors `just validate-local` — the local mirror of `ci.yml` (Tier-1) + the coverage
gate (Tier-2).

## Trigger Patterns
- `/validate-local` · "validate locally", "run all checks", "pre-flight before PR"

## Steps
```bash
just validate-local
```
Runs, in order:
1. `flutter analyze --fatal-infos` — **zero** issues (errors, warnings, AND infos; `very_good_analysis`).
2. `flutter test --coverage` — all tests green **except the 4 known CloudKit macOS failures**; coverage **≥ 19%** (`THRESHOLD=19`).
3. `flutter build web` — the web build must succeed.

Report a PASS/FAIL line per step; only report "green" when all pass (exit 0 per step, not an assumption).

## Rules
- The pre-flight gate before opening any PR (the "green except 4 CloudKit" baseline).
- **Scope boundary:** this validates *work correctness*. If the toolchain isn't set up (flutter/pnpm missing), don't diagnose the environment here — point the user to **`/env-doctor`** and stop.
- The web **integration gate** (`flutter drive`) is a CI gate (Tier-2, blocking as of Sprint 36); run it there, not necessarily in every local pass.
