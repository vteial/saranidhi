[← Back to Sprint Dossier](./README.md)

# Sprint 39 — Local Test Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> **When:** after the local `flutter analyze` + `flutter test` run, before the PR.
> This is the audit record of the local gate result.

## Environment

- Flutter: `3.47.3` · Dart: `3.13.3` · Platform: macOS (Darwin 25.1.0)

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart`
> (CloudKit "on non-Apple platform" cases that only fail because `Platform.isMacOS`
> locally; they PASS on CI Ubuntu). The gate = "green **except those same 4**."

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ☑ no issues found |
| Full test | `flutter test` | 573 pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ☑ compiles (`Built build/web` in 26.9s) |

**Regression check (behavior-preserving gate):** confirm the pre-existing
`integrated_arudam_engine_test.dart` assertions
(`score/momentScore/readinessMultiplier/band/isFloorLocked/guidance`) and all
`arudam_now_card_test.dart` cases pass **unchanged** (only additions) → ☑; and the
collapsed card renders identically to pre-sprint → ☑.

## New / updated tests this sprint

- Engine: `reasons` per case — aligned/misaligned/stale-omits-readiness/Sushumna/floor-lock single-reason + `conf` strings. (5 new tests in `integrated_arudam_engine_test.dart`, 16 total passed).
- Card: "Why?" collapsed-by-default → tap-expand → doctrinal prose + `CONF-` citation; floor-lock explanation (no Moment/You split); misaligned "dampened, not blocked" line. (4 new tests in `arudam_now_card_test.dart`, 10 total passed).
- Tamil-mode eyeball / locale-override assertion for the "Why?" label (`ஏன்?`) + reason line in pure Tamil script (`renders Why section in Tamil script under ta locale` test passes).

## Notes

- Clean noise-free test subset: `flutter test test/features/astro_engine/ test/features/widgets/arudam_now_card_test.dart` passes with 257/257 tests.
- Baseline of 564 passing tests increased to 573 passing tests (+9 tests added, 0 regressions).
