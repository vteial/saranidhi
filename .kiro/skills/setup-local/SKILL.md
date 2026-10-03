---
name: setup-local
description: >-
  One-shot onboarding for Saranidhi (PRJ-001) — installs Flutter deps and runs build_runner so a
  fresh clone can build and test. Mirrors `just setup-local`. Use when the user runs /setup-local or
  sets up the repo on a new machine.
---

# Skill: Local Setup (`/setup-local`)

## Objective
Take a fresh clone to a buildable/testable state in one command. Mirrors `just setup-local`.

## Trigger Patterns
- `/setup-local` · "set up the repo", "onboard this machine", "fresh clone setup"

## Steps
```bash
just setup-local
```
Runs: `flutter pub get`, then `dart run build_runner build --delete-conflicting-outputs`
(regenerates `*.g.dart` / `*.freezed.dart`, which are gitignored), and regenerates the l10n
(`lib/l10n/generated/`). Finishes by suggesting `just validate-local`.

## Rules
- Assumes the toolchain is present — if not, it points at `/env-doctor` first.
- Generated files are git-excluded by design; `setup-local` is what materializes them locally.
- Idempotent — safe to re-run after a dependency or ARB change.
