---
name: status-local
description: >-
  Reports whether the Saranidhi (PRJ-001) local dev server is up. Mirrors `just status-local`. Use
  when the user runs /status-local or asks if the app is running locally.
---

# Skill: Status Local (`/status-local`)

## Objective
Report whether the local dev server is currently serving. Mirrors `just status-local`.

## Trigger Patterns
- `/status-local` · "is the app running?", "local status"

## Steps
```bash
just status-local
```
Reports ONLINE (with the port) or OFFLINE.

## Rules
- Read-only — never starts/stops anything.
