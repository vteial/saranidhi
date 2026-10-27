<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/user-guide-refresh/REPORT.md
  Append-only verification log for the user-guide-refresh Spec.
-->
# User Guide Light Refresh — Verification Report

Spec: `.kiro/specs/user-guide-refresh/` · Spec ID: `user-guide-refresh` · Branch: `sprint/user-guide-refresh` → `main` · PR: [#319](https://github.com/vteial/saranidhi/pull/319).

### Preflight & Baseline (T0)
- **Preflight:** Clean tree; `just env-doctor` green; baseline `just validate-local` green except 4 accepted CloudKit macOS failures (coverage 47.2% ≥ 19%).
- **Pinned Toolchain Versions:**
  - **Flutter:** `3.47.5` (channel stable, revision `6a19cca564`, engine `af7e796e16`)
  - **Dart SDK:** `3.13.4` (stable, macos_arm64)
- **Open Questions Grounded (T0):**
  - **OQ-1:** Confirmed current bottom-nav destinations from `shell_scaffold.dart`: `homeTab` (Home / முகப்பு), `journalTab` (Journal / பதிவேடு), `prasanamTab` (Oracle / ஆரக்கிள்), `analyticsTitle` (Analytics / பகுப்பாய்வு), plus gear-icon Settings (`settingsTitle` / அமைப்புகள்). Stale "Explore" references grounded for elimination.
  - **OQ-2:** Confirmed no pre-existing `guideOracle*` key; added cleanly without collision.
  - **OQ-3:** Reused canonical Tamil vocabulary: Oracle/Prasanam (`பிரசன்னம் ஆரக்கிள்`, `ஆரக்கிள்`), Hora (`ஹோரை`), Tattva (`தத்துவம்`), Nav (`முகப்பு`, `பதிவேடு`, `ஆரக்கிள்`, `பகுப்பாய்வு`, `அமைப்புகள்`).

### Invariants Pinned First (T1 / RQ)
Pinned in `test/features/settings/presentation/user_guide_screen_test.dart` (3 tests):
- **RQ.1:** `UserGuideScreen` renders flat `CustomScrollView` / `_Section` sliver architecture with sections in defined reading order (no `GuideSection` model, no ToC, no in-guide search bar; post-2.0 epic not pulled forward).
- **RQ.2:** The bilingual reference tables (`_ReferenceSection`: Planets/Hora, Elements/Tattva, Birds/Pakshi, Nakshatras) render intact and scrollable.
- **RT:** Tamil locale renders all section titles and bodies in pure Tamil script without English leaks.

### Implementations Applied (T2–T6, TL)
- **R1 (Prasanam Oracle section):**
  - `lib/l10n/app_en.arb` & `lib/l10n/app_ta.arb`: Added `guideOracleTitle` and `guideOracleBody` describing the 4th tab consultation flow, 5 omen bands, window friction, and user-saved history.
  - `lib/features/settings/presentation/user_guide_screen.dart`: Wired `_Section(title: l10n.guideOracleTitle, body: l10n.guideOracleBody)` placed after Dashboard and before Benefits (D1, D2).
- **R2 (Nav correction):**
  - Corrected stale "Explore tab" / "'ஆராய்' தாவலை" references in `guideHowToBody` and `guideBestBody` (EN + TA) to match active bottom nav (**Home · Journal · Oracle · Analytics**) and Settings gear.
- **R3 & R4 (Journal & Dashboard features):**
  - Documented pin/star entries (`isPinned`, pinned-first order), streak milestone celebrations (7, 30, 100, 365 days), and guided breath presets (4-7-8, Box breathing) in How-to, Dashboard, and Benefits (EN + TA).
  - Documented real-time active **Hora** (planetary hour) and **Tattva** (element) readings in `guideDashboardBody` (EN + TA).
- **R5 (Practice Sync note):**
  - Added FAQ Q&A and Benefits note framing Practice Sync as an opt-in, default-OFF cross-device feature preserving offline-first and local-first privacy (D3).
- **R6 (Doc mirror):**
  - Refreshed `docs/product/user-guide.md` to match all refreshed feature descriptions; left `> **Reviewed:** v1.13.0-web` stamp untouched for release-gated bump.
- **TL (l10n generation):**
  - Regenerated `lib/l10n/generated/app_localizations*.dart` via `flutter gen-l10n`.

### Engine Firewall Gate Check (TG)
- `git diff origin/main --name-only -- lib/features/astro_engine/` → **0 files**.

### Standing Criteria (RT / RC / RQ)
- **RT (Tamil):** Every new/changed string authored in pure Tamil script in `app_ta.arb` (no transliteration, no hardcoded English). Eyeballed in Tamil mode.
- **RC (Provenance):** **n/a** — purely descriptive content of shipped features; no engine calculation, birth-bird formula, or astrological scoring modified.
- **RQ (Quality Gates):** `just validate-local` green: analyze clean (0 fatal-infos issues), test suite green (504 passed, 4 accepted CloudKit macOS failures), coverage 48.5% ≥ 19%, web build compiles.

### Human Verification Plan (§4b)
1. **In-App Guide (EN):** Open Settings → About → User Guide. Confirm Oracle section present, nav references correct, journal/dashboard/sync content present.
2. **Tamil Mode (RT):** Switch to Tamil mode (`ta`). Confirm every section renders in pure Tamil script (no English leak).
3. **Reference Tables & Architecture (RQ.1, RQ.2):** Scroll through the screen. Confirm flat scrolling list and all 4 bilingual reference tables render.
4. **Automated Verification:** `just validate-local` green (±4 CloudKit); 0 astro-engine files in diff.

### Verification Log — 2026-10-27 (PR #319)

| Plan step | Result | Finding / correction |
| :--- | :---: | :--- |
| V1 In-App Guide EN (R1–R5) | ✅ | Oracle section present after Dashboard; nav references Home · Journal · Oracle · Analytics; journal presets, pin/star, streak celebrations, Hora/Tattva, and Practice Sync present. Attested by owner. |
| V2 Tamil Mode (RT) | ✅ | Pure Tamil script verified on all new/changed sections (பிரசன்னம் ஆரக்கிள், முகப்பு, பதிவேடு, ஆரக்கிள், பகுப்பாய்வு, ஹோரை, தத்துவம், பயிற்சி ஒத்திசைவு); zero English leaks. Attested by owner. |
| V3 Architecture & Reference Tables (RQ.1, RQ.2) | ✅ | Flat `CustomScrollView` intact; no ToC/search epic crept in; all 4 reference tables render. Attested by owner. |
| V4 Quality Gates (RQ) | ✅ | `just validate-local` 100% green: analyze clean (0 issues), 504 tests green (±4 accepted CloudKit baseline), coverage 48.5% ≥ 19%, web build compiles. |
| VT Engine Firewall (TG) | ✅ | 0 files touched under `lib/features/astro_engine/`. |

- **Iterations:** 1 (implementation verified cleanly as-is).
- **Verdict:** PASS — human functional verification complete.
- **Verified by:** owner (Human) · **Surface:** Executor (Antigravity)
- **Provenance note:** Local validation gates and mechanical checks verified by Executor; functional verification attested by owner via `/verification-done`.

#### Evidence summary (the 4 questions — requirements §4c)
- **What am I accepting?** Content refresh of the in-app User Guide and mirror doc covering v2.0 features (Prasanam Oracle, current nav, journal pin/presets, streak milestones, Hora/Tattva, Practice Sync) in bilingual EN + pure Tamil script.
- **What could it affect?** In-app User Guide screen display, ARB translation files, and doc mirror. Astro engine firewall strictly maintained with **0** files touched under `lib/features/astro_engine/` (TG).
- **Why believe it works?** Pinned regression suite `user_guide_screen_test.dart` passes (3/3), full test suite passes (504 tests, ±4 CloudKit), analyzer has 0 fatal-infos issues, and coverage is 48.5% (≥ 19%).
- **What remains unresolved?** None. The structured-model (`GuideSection`/ToC/search) epic is explicitly deferred post-2.0.
