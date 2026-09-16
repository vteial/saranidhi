[← Back to Sprint Dossier](./README.md)

# Sprint 47 — Local Test Summary

> **Author:** Antigravity. Records the **local** `flutter test` + `flutter analyze` run **before**
> the PR, run against the **Docker Compose PocketBase** (§6). Factual + terse.
> _Placeholder — Antigravity fills this in on implementation._

## Local run
- `flutter analyze`: _pending_
- `flutter test`: _pending_ (baseline entering Sprint 47: **661** tests; 4 known CloudKit-on-macOS failures are the standing baseline, not regressions).
- PocketBase used for local green: `http://localhost:8090` via `tool/dev/docker-compose.yml`.

## New tests added
| Area | Test | Proves |
|------|------|--------|
| Merge core (§3) | _tbd_ | union insert-only + idempotent; `mergeFromBytes` behavior unchanged |
| Owner-guard on pull | _tbd_ | foreign-ownerId pull refused, 0 mutations |
| Engine (§4) | _tbd_ | pull→merge→push round-trip w/ mocked transport; 2nd run = no-op |
| Transport (§2) | _tbd_ | auth / pull-maps / push-upsert w/ mocked http; web-safe |
| Opt-in / offline (§7) | _tbd_ | toggle-off = no network; error = quiet status, no data loss |
| Scope checkboxes / l10n | _tbd_ | journal/sessions/both; EN/TA parity |

## Regression
_Existing `database_exporter_test` (merge/guard) green after the §3 extraction; offline single-device use unchanged._

## Result
_PASS / FAIL summary here._
