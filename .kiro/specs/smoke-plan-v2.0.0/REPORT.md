<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/smoke-plan-v2.0.0/REPORT.md
  Append-only verification log for the smoke-plan-v2.0.0 Spec.
-->
# v2.0.0 Smoke-Test Plan — Verification Report

Spec: `.kiro/specs/smoke-plan-v2.0.0/` · Spec ID: `smoke-plan-v2.0.0` · Branch: `sprint/smoke-plan-v2.0.0` → `main` · PR: [#322](https://github.com/vteial/saranidhi/pull/322).

### Preflight & Baseline (T0)
- **Preflight:** Clean tree; `just env-doctor` green; baseline `just validate-local` green except 4 accepted CloudKit macOS failures (coverage 48.6% ≥ 19%).
- **Pinned Toolchain Versions:**
  - **Flutter:** `3.47.5` (channel stable, revision `6a19cca564`, engine `af7e796e16`)
  - **Dart SDK:** `3.13.4` (stable, macos_arm64)
- **Open Questions Grounded (T0):**
  - **OQ-1:** Created `docs/testing/releases/v2.0.0/` rich-release folder; smoke plan authored at `docs/testing/releases/v2.0.0/smoke-test.md`.
  - **OQ-2:** Confirmed `docs/testing/smoke-test-results.md` index; deferred adding v2.0.0 row until the release smoke is executed by owner during `/release-finish` / `/release-update`.

### Implementations Applied (T1–T4)
- **R1 & R6 — Pre-flight & Environment (T1):**
  - Authored pre-flight block asserting Vercel preview reachability with `VERCEL_AUTOMATION_BYPASS_SECRET`, exact version match `Saranidhi v2.0.0`, release PR CI green, and Fly PocketBase health (`curl https://saranidhi-pb.fly.dev/api/health` → 200).
- **R2 — New-Feature Scenarios (T2):**
  - **S1 (UX Wiring):** WhatsNew gate (once, post-onboarding), journal pin/star affordance (pinned-first block, chronological sorting), guided PresetSelector (target guidance without overwriting manual capture), and StreakCelebration milestone trigger (7, 30, 100, 365 days).
  - **S2 (Perf & Reduced-Motion):** Startup off critical path (timezone and notification init deferred to post-first-frame callback), run-once on-open side-effects (route changes do not repeat sync/location/migration), and reduced-motion static end-states (`SamaVrittiPacer`, `QuickSyncPacer`, `ShimmerLoading`, `PrasanamScreen` breathing circle, and `StreakCelebration`).
  - **S3 (Localization Polish Sweep):** Tamil unpin disambiguation (`பின் அகற்று` ≠ delete `நீக்கு`, `BUG-POLISH-01`) and yama transition notification title formatting (`Saranidhi — யாம N`, `BUG-v1.11.1-03`).
  - **S4 (Prasanam Oracle):** Oracle consultation reading in 4th tab resolving to 5 guidance bands, window friction banner, and user-initiated "Save to History".
  - **S5 (Engine Adhikara/Padu & Null-Bird No-Op):** Adhikara (×1.15) and Padu-Pakshi (×0.5) modifiers in Oracle and Home ambient card citing CONF-PP-007; byte-identical null-bird no-op (×1.0); Rahu Kaal and Emakandam inauspicious floor-locks (score=10) taking precedence.
  - **S6 (Practice Sync Auto-on-Open):** Consent gate (zero network when disabled), auto-on-open on cold launch & 5-minute resume when authed, silent non-blocking error handling, cross-device round-trip, and idempotent re-sync.
- **R3 & R4 — Standing Regression & Bilingual Sweep (T3):**
  - **S7 (Standing Regression):** Dual-path onboarding, core dashboard widgets (Birth Bird, Rahu/Yamagandam, 10-Yama, Horas, Tattvas), breath timer and journal, Analytics, Settings export/import with owner-guard, and offline-first integrity.
  - **S8 (Bilingual Sweep - RT Gate):** Pure Tamil script verification across all new v2.0 surfaces (Oracle, WhatsNew, preset selector guidance, streak celebration overlay, journal pin affordance, and User Guide).
- **R5 — Result Table & Release Doctrine (T4):**
  - Authored empty result table with rows S1–S8.
  - Added known-defect handling doctrine distinguishing minor cosmetic backlogged defects from blocking functional defects requiring in-branch remediation.

### Engine Firewall Gate Check (TG)
- `git diff origin/main --name-only -- lib/features/astro_engine/` → **0 files**.
- Scope check: Only `docs/testing/releases/v2.0.0/smoke-test.md`, `.kiro/specs/smoke-plan-v2.0.0/tasks.md`, and `.kiro/specs/smoke-plan-v2.0.0/REPORT.md` modified. Zero code/engine changes.

### Standing Criteria (RT / RC / RQ)
- **RT (Tamil):** S8 defines the authoritative Tamil gate for v2.0.0 release verification, specifying pure Tamil script across all new UI surfaces.
- **RC (Provenance):** S5 grounds the Adhikara and Padu-Pakshi verification against Kottumozhi Sathya pp. 14, 17, 18, 22 under CONF-PP-007 and explicitly pins the null-bird no-op invariant.
- **RQ (Quality Gates):** `just validate-docs` green; `just validate-local` baseline clean (analyze clean, tests green ±4 CloudKit baseline, coverage 48.6% ≥ 19%, web build succeeds).

### Human Verification Plan (§4b)
1. **Dossier & Scenario Structure:** Open `docs/testing/releases/v2.0.0/smoke-test.md` and confirm pre-flight, scenarios S1–S8, result table, and known-defect release doctrine are complete.
2. **Feature Coverage Completeness:** Confirm every feature listed in `CHANGELOG.md [Unreleased]` is covered by a specific scenario in S1–S6 without omission.
3. **Docs Validation & Scope:** Confirm `just validate-docs` is green and git diff contains zero code or engine modifications.

### Verification Log — 2026-10-27 (PR #322)

| Plan step | Result | Finding / correction |
| :--- | :---: | :--- |
| V1 Dossier & Scenario Structure (R1, R2, R5, R6) | ✅ | `docs/testing/releases/v2.0.0/smoke-test.md` authored with pre-flight, scenarios S1–S8, empty result table, and known-defect release doctrine. Attested by owner. |
| V2 Feature Coverage Completeness (R2, R3, R4) | ✅ | All accumulated v2.0 features in `CHANGELOG.md [Unreleased]` (widgets, perf, reduced-motion, l10n, Oracle, engine Adhikara/Padu, sync) covered across S1–S8 without gap. Attested by owner. |
| V3 Quality Gates & Scope (RQ, RC, RT) | ✅ | `just validate-docs` clean; `just validate-local` 100% green (analyze clean, tests green ±4 accepted CloudKit baseline, coverage 48.6% ≥ 19%, web build compiles); exactly 0 code/engine files in diff. |

- **Iterations:** 1 (smoke-test plan verified as complete).
- **Verdict:** PASS — human functional verification complete.
- **Verified by:** owner (Human) · **Surface:** Executor (Antigravity)
- **Provenance note:** Local validation gates and mechanical checks verified by Executor; functional verification attested by owner via `/verification-done`.

#### Evidence summary (the 4 questions — requirements §4c)
- **What am I accepting?** The comprehensive release smoke-test plan for the v2.0.0 major release (`docs/testing/releases/v2.0.0/smoke-test.md`), characterizing all shipped changes since v1.13.0 and the full standing regression surface.
- **What could it affect?** Release verification procedure for the upcoming v2.0.0 release. Zero production runtime code, engine calculation, or database schema touched.
- **Why believe it works?** The plan follows the established house format (`v1.13.0/smoke-test.md`), `just validate-docs` passes, baseline tests pass (±4 CloudKit), and coverage remains at 48.6% (≥ 19%).
- **What remains unresolved?** Execution of the smoke test itself occurs during the release lifecycle (`/release-start` / `/release-finish`) on the release PR's deployed Vercel preview.
