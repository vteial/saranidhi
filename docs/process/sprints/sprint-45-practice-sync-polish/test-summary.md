[← Back to Sprint Dossier](./README.md)

# Sprint 45 — Local Test Summary

> **Author:** Antigravity IDE coding setup. Records the **local** `flutter test` + `flutter analyze`
> run **before** the PR (Kiro Web cannot run Flutter locally). Factual + terse.
> _Placeholder — Antigravity fills this in on implementation._

## Local run

- `flutter analyze`: _pending_
- `flutter test`: _pending_ (baseline entering Sprint 45: **649** tests; known 4 CloudKit-on-macOS
  failures are the standing baseline, not regressions).

## New tests added

| Task | Test | What it proves |
|------|------|----------------|
| 45.1 | _tbd_ | Intro Import link → merge adopts file ownerId + flips onboarding-complete; Get-Started path unaffected |
| 45.2 | _tbd_ | Profile card refreshes ownerId after `profileProvider` invalidation (no manual reload) |
| 45.3 | _tbd_ | Filename builder: ownerId → prefixed; null/empty → unprefixed; <8-char → no RangeError |

## Regression

_Onboarding happy-path + existing merge/restore/guard tests — confirm still green._

## Result

_PASS / FAIL summary here._
