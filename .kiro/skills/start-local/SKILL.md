---
name: start-local
description: >-
  Runs the Saranidhi (PRJ-001) dev server — flutter run -d chrome. Mirrors `just start-local`.
  Saranidhi is local-first with no backing services, so this is just the Flutter web dev server.
  Use when the user runs /start-local or wants to run the app locally.
---

# Skill: Start Local (`/start-local`)

## Objective
Run the app locally for development/verification. Mirrors `just start-local`. Saranidhi is
**local-first, zero-backend** — no Postgres/PocketBase to stand up, so this is simply the
Flutter web dev server.

## Trigger Patterns
- `/start-local` · "run the app", "start the dev server"

## Steps
```bash
just start-local      # flutter run -d chrome
```
- Pair with `/status-local` to check whether a server is already up, and `/stop-local` to kill it.

## Rules
- No backing services — the verb exists for family parity; the body is Flutter-shaped.
- Web uses Drift WASM SQLite (fallback worker mode) — no COOP/COEP headers, no `canvasKitVariant: "chromium"`.
