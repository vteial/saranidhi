<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/l10n-polish-sweep/REPORT.md
  Append-only verification log for the l10n-polish-sweep Spec.
-->
# Localization Polish Sweep — Verification Report

Spec: `.kiro/specs/l10n-polish-sweep/` · Spec ID: `l10n-polish-sweep` · Branch: `fix/l10n-polish-sweep` → `main`.

### Preflight & Baseline (T0)
- **Preflight:** Clean tree; `just env-doctor` green; baseline `just validate-local` green except 4 accepted CloudKit macOS failures (coverage 47.0% ≥ 19%).
- **Pinned Toolchain Versions (P2 — toolchain-rot lesson):**
  - **Flutter:** `3.47.5` (channel stable, revision `6a19cca564`, engine `af7e796e16`)
  - **Dart SDK:** `3.13.4` (stable, macos_arm64)
- **Seam & Open Question Resolutions (T0):**
  - **OQ-1:** Notification scheduler callers (`notification_providers.dart`) already read `final appLocale = ref.read(localeProvider).code;` and pass `languageCode: appLocale` into `NotificationScheduler.refreshSchedule` / `generateForToday`. Resolved cleanly at consumer without Flutter context dependency.
  - **OQ-2:** Confirmed `yamaPrefix` (`யாம`) and `yamaShortPrefix` (`யா`) in `lib/l10n/app_ta.arb` are verified pure Tamil script.
  - **OQ-3:** `unpinEntry` mapped to `பின் அகற்று` ("un-pin"), cleanly eliminating semantic collision with `delete` (`நீக்கு`).

### Invariants Pinned First (T1 / RQ)
Pinned in `test/features/l10n_polish_sweep/l10n_polish_sweep_invariants_test.dart` (5 tests):
- **RQ.a:** `delete` remains `நீக்கு` in Tamil; genuine delete strings (`deleteEntryMessage`, `prasanamDeleteConfirm`, `clearAllDataConfirmMessage`) are intact and distinct from `unpinEntry`.
- **RQ.b:** Yama fallback notification titles contain the 1-based yama number (1..5) and compose localized prefix cleanly (`'Saranidhi — Yama 1'` in English, `'Saranidhi — யாம 1'` in Tamil).
- **RQ.c (R2.4 guard):** AI-wisdom payload `WisdomContext.toMap()['activeYama']` strictly maintains its stable English token (`'Yama 1'`) across all locales to preserve LLM prompt determinism.

### Implementations Applied (T2, T3, T4)
- **R1 (BUG-POLISH-01):**
  - `lib/l10n/app_ta.arb:408`: Updated `unpinEntry` from `நீக்கு` → `பின் அகற்று`.
  - Regenerated `lib/l10n/generated/app_localizations_ta.dart`.
  - English `unpinEntry` left unchanged as `Unpin`.
- **R2 (BUG-v1.11.1-03):**
  - `lib/features/notifications/domain/notification_scheduler.dart`: Updated `_buildTitle`, `generateForToday`, and `refreshSchedule` to support `languageCode` and optional `yamaPrefix`. Fallback title composes localized prefix (`யாம` in Tamil, `Yama` in English, or caller-provided `yamaPrefix`) with `yama.index + 1`.
  - Engine firewall strictly respected: `yama_calculator.dart` untouched.
  - LLM payload untouched: `wisdom_context.dart:52` left as stable English `activeYama?.label`.
- **R3 (315 carry-over):**
  - `test/features/performance_pass/performance_pass_invariants_test.dart`: Tightened reduced-motion-ON tests for `ShimmerLoading` (asserts gradient stops pinned at `[0.2, 0.5, 0.8]` and no ticking callbacks), `SamaVrittiPacer` (asserts 2D scale pinned at `0.5`, phase at Inhale, second at `1`, and no ticking callbacks), and `QuickSyncPacer` (activates via tap, asserts 2D scale pinned at `1.0`, text `Breathe with the circle`, and no ticking callbacks).

### Engine Firewall Gate Check (TG)
- `git diff --name-only main... | grep -E 'astro_engine|pakshi_calculator|swara|oracle|arudam|nakshatra'` → **0 files**.

### Standing Criteria (RT / RC / RQ)
- **RT (Tamil):** Value-check only. Zero new ARB keys added. The single changed Tamil value (`பின் அகற்று`) is pure Tamil script (no transliteration). Eyeballed `yamaPrefix` (`யாம`) and `yamaShortPrefix` (`யா`).
- **RC (Provenance):** N/A — no doctrinal calculation, birth-bird formula, or astrological rule modified.
- **RQ (Quality Gates):** `just validate-local` green: analyze clean (0 fatal-infos issues), test suite green (501 passed, 4 accepted CloudKit macOS failures), coverage 47.0% ≥ 19%, web build compiles.

### Human Verification Plan (§4b)
1. **Tamil Journal Unpin Tooltip:**
   - Open Journal tab in Tamil mode (`ta`).
   - Pin an entry (star icon turns filled).
   - Long-press / hover over the star icon: verify tooltip displays `பின் அகற்று` (distinct from `நீக்கு` on the delete action).
2. **Yama Transition Notification Title:**
   - In Tamil mode, trigger / schedule a yama transition notification without birth bird context: verify title displays `Saranidhi — யாம <N>`.
   - In English mode, verify title displays `Saranidhi — Yama <N>`.
3. **AI Wisdom Context Payload:**
   - Verify AI prompt payload retains `'activeYama': 'Yama <N>'` in English regardless of app language.
