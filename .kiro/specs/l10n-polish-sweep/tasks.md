<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/l10n-polish-sweep/tasks.md
  Spec: l10n-polish-sweep — Tasks
  Authored: 2026-10-27 (Operator /plan-start).
-->
# l10n Polish Sweep — Tasks

> Executor contract: implement on `fix/l10n-polish-sweep`, run the local suite
> GREEN (except the 4 accepted CloudKit macOS failures) BEFORE the PR, emit the
> Human Verification Plan, STOP. Pin exact Flutter/Dart versions in the REPORT
> (toolchain-rot lesson). Never merge.

## T0 — Preflight & seam re-read
- Clean tree; `just env-doctor` green; baseline `just validate-local` green (±4 CloudKit).
- Re-read the three seams (they may have shifted since 2026-10-27): `app_ta.arb:408`, `notification_scheduler.dart:203`, the 3 pacer tests.
- **Resolve OQ-1** firsthand: does the notification title builder's call site have an `l10n`/locale handle? Record the answer before coding R2.
- **Resolve OQ-2**: confirm `yamaPrefix`/`yamaShortPrefix` Tamil values are pure Tamil.

## T1 — Pin regression invariants FIRST (RQ)
Before any change, add/confirm tests that pin:
- **RQ.a** `delete` still maps to `நீக்கு` in Tamil (unchanged by R1).
- **RQ.b** the yama notification title still contains the yama number and fires with correct content (only the prefix source changes).
- **RQ.c** `wisdom_context.toMap()['activeYama']` keeps its current English-key shape (R2.4 guard — proves the AI payload was NOT localized).

## T2 — R1: unpin Tamil word
- Change `app_ta.arb` `unpinEntry` → `பின் அகற்று` (or `பின் நீக்கு` per OQ-3). Touch nothing else.
- Regenerate `app_localizations*.dart`. Confirm `delete` still `நீக்கு`.

## T3 — R2: localize yama notification title
- At `notification_scheduler.dart:203`, replace `'Saranidhi — ${yama.label}'` with a title composed from `l10n.yamaPrefix` + the yama number (thread `l10n`/prefix per OQ-1).
- Leave `wisdom_context.dart:52` **unchanged** (R2.4).
- **Do NOT touch** `yama_calculator.dart` (R2.3 firewall).

## T4 — R3: tighten animation tests
- For `ShimmerLoading`, `SamaVrittiPacer`, `QuickSyncPacer` reduced-motion-ON tests, add a controller-state assertion (not-animating / pinned static value). Activate `QuickSyncPacer` first.
- Keep the OFF-path assertions intact.

## T5 — Verify
- `just validate-local` green (±4 CloudKit), coverage ≥ 19%.
- **RT value-check**: `பின் அகற்று` pure Tamil; `yamaPrefix`/`yamaShortPrefix` Tamil pure. Eyeball Tamil mode on the journal unpin tooltip + a yama notification.
- **RC**: state n/a in REPORT (no doctrinal calc touched).

## TG — Engine firewall (hard gate)
- `git diff --name-only main... | grep -E 'astro_engine|pakshi_calculator|swara|oracle|arudam|nakshatra'` → **0 files**. Record in REPORT.

## TP — Lockstep + PR
- CHANGELOG entry + flip the two BACKLOG rows (`BUG-POLISH-01`, `BUG-v1.11.1-03`) to resolved; note the 315 test-tighten carry-over addressed.
- Open PR `fix/l10n-polish-sweep` → `main`, emit the Human Verification Plan, STOP.
