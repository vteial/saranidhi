[← Back to Sprint Dossier](./README.md)

# Sprint 47 — Local Test Summary

> **Author:** Antigravity. Records the **local** `flutter test` + `flutter analyze` run **before**
> the PR, run against the **Docker Compose PocketBase** (§6). Factual + terse.
> _Placeholder — Antigravity fills this in on implementation._

## Local run
- `flutter analyze`: ✅ 0 issues found (clean, 2.8s)
- `flutter test`: ✅ 677 passed (baseline entering Sprint 47: **661**; 16 new tests added; 4 known non-Apple CloudKit failures remain standing baseline).
- PocketBase used for local green: `http://localhost:8090` via `tool/dev/docker-compose.yml`.

## New tests added
| Area | Test | Proves |
|------|------|--------|
| Merge core (§3) | `database_exporter_test.dart` | union insert-only + idempotent; `mergeFromBytes` behavior unchanged; serializers roundtrip |
| Owner-guard on pull | `practice_sync_engine_test.dart` | foreign-ownerId pull refused, 0 mutations |
| Engine (§4) | `practice_sync_engine_test.dart` | pull→merge→push round-trip w/ fake transport; 2nd run = no-op; scope filtering |
| Transport (§2) | `pocketbase_sync_transport_test.dart` | auth / pull-maps / push-upsert w/ mocked http; web-safe |
| Opt-in / offline (§7) | `practice_sync_engine_test.dart`, `practice_sync_ui_test.dart` | toggle-off = no network; error = quiet status, no data loss |
| Scope checkboxes / l10n | `practice_sync_ui_test.dart` | journal/sessions/both; pure Tamil script renders cleanly |

## Regression
Existing `database_exporter_test` (merge/guard) green after the §3 extraction; offline single-device use unchanged.

## Result
PASS (16/16 new tests passing, 0 analysis warnings/errors).
