---
name: stop-local
description: >-
  Stops the Saranidhi (PRJ-001) local dev server. Mirrors `just stop-local`. Use when the user runs
  /stop-local or wants to shut down the running dev server.
---

# Skill: Stop Local (`/stop-local`)

## Objective
Stop the running Flutter web dev server. Mirrors `just stop-local`.

## Trigger Patterns
- `/stop-local` · "stop the dev server", "shut down local"

## Steps
```bash
just stop-local
```

## Rules
- No backing services to tear down — only the dev server process.
- Safe/idempotent — a no-op when nothing is running.
