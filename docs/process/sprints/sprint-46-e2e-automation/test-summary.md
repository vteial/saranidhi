[← Back to Sprint Dossier](./README.md)

# Sprint 46 — Run / Evidence Summary

> **Author:** Antigravity. Records the harness run against the **deployed preview** (`https://saranidhi-git-release-v1121-eialarasus-projects.vercel.app/`). Factual + terse.

## Environment

- **Preview URL tested:** `https://saranidhi-git-release-v1121-eialarasus-projects.vercel.app/`
- **About version verified (pre-flight):** `v1.12.1 (1)` verified via AboutCard in Step 0
- **Playwright / Node versions:** Playwright `@playwright/test` v1.58.2 / Node v24.12.0 (macOS / Chromium 145.0)

## Run result

| Scenario | Result | Evidence (screenshot attachment) | Wall-clock |
|----------|:------:|----------------------------------|:----------:|
| Step 0 Pre-flight readiness | ✅ PASS | `STEP_0___Pre-flight_readiness_gate__Reachability___Version__step0_about_card_scrolled_*.png` | 18.8s |
| S1 import-before-onboarding | ✅ PASS | `S1___New-device_import_BEFORE_onboarding_adopts_source_Practice_ID_s1_settings_profile_card_*.png` | 13.7s |
| S2 in-place refresh (BUG-v1.12.0-01) | ✅ PASS | `S2___Practice_ID_refreshes_in_place_after_Restore_Merge__BUG-v1_12_0-01__s2_inplace_refreshed_profile_*.png` | 11.3s |
| S3 filename prefix | ✅ PASS | `S3___Export_filename_carries_Practice_ID_prefix_s3_export_download_intercepted_*.png` | 8.6s |
| S4 onboarding happy-path | ✅ PASS | `S4___Onboarding_happy-path_mints_UUID_v4_Practice_ID_s4_settings_minted_pid_*.png` | 14.6s |
| S5 merge/owner-guard regression | ✅ PASS | `S5___Merge_Restore___owner-guard_regression__s5_1_same_pid_merge_dialog_*.png`, `s5_2_mismatch_refused_dialog_*.png` | 15.0s |
| S6 bilingual EN/TA copy & dialog | ✅ PASS | `S6___Bilingual__EN_TA__intro_copy_and_merge_dialog_s6_tamil_merge_dialog_*.png` | 6.4s |

- **Consecutive clean runs:** 2 consecutive clean runs (both 100% green without retries)
- **Retries configured:** `retries: 1` in `playwright.config.ts` (0 retries triggered on final runs)

## ⏱ Measured runtime (the real number — NOT the aspirational ~2 min)

- **Full suite wall-clock (green):** **1.4 minutes (84 seconds)** across all 7 scenarios (Step 0 + S1–S6)
- **Per-scenario breakdown (Run 2):**
  - Step 0: 18.8s
  - S1: 13.7s
  - S2: 11.3s
  - S3: 8.6s
  - S4: 14.6s
  - S5: 15.0s
  - S6: 6.4s
- **vs. manual v1.12.1 baseline (~1h48m active):** **~77x speedup** (from 108 minutes manual execution down to 1.4 minutes automated).

## Flakiness notes

- **Flutter CanvasKit SelectableText Accessibility:** In `ProfileCard`, Practice ID is painted directly to canvas via `SelectableText`. Accessing it via the semantic "Copy Practice ID" button (`ClipboardData`) provides 100% deterministic assertion without relying on OCR or pixel heuristics.
- **Fixture Schema Precision:** Drift's `BreathSessions` table enforces non-null fields (`nostril`, `inhaleLengthMs`, `holdAfterInhaleMs`, `exhaleLengthMs`, `holdAfterExhaleMs`, `completedCycles`). Incomplete fixture schemas caused Dart `TypeError` during restore before data providers were invalidated; complete fixture payloads resolved this completely.
- **CanvasKit Viewport Bounds:** Certain buttons (`Export All Data`, `Merge from file`, `Restore (overwrite everything)`) render below the 844px mobile viewport. Semantic auto-scrolling (`page.mouse.wheel`) brings target elements into viewport before clicking.

## Result

**PASS** — All 7 scenarios automated, verified, and passing consecutively with per-step screenshot evidence against deployed preview.
