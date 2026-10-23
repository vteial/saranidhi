<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/pakshi-scoring-corpus-alignment/REPORT.md
  Verification log for the pakshi-scoring-corpus-alignment Spec.
-->
# Pakshi Scoring — Corpus Alignment — Verification Report

Spec: `.kiro/specs/pakshi-scoring-corpus-alignment/` · Spec ID: `pakshi-scoring-corpus-alignment` · Branch `fix/pakshi-scoring-corpus-alignment` → `main` (PR #304).
Class: Correctness-critical (Oracle/Aruḍam scoring alignment).
Provenance: Grounded in the primary Tamil source *"பஞ்ச பட்சி ஆருடம்"* (Thirumathi Kottumozhi Sathya, Pollachi) under **CONF-PP-007**.

---

## 1. Seam Read & Source Re-transcription (T0)

- **Source verification:** Verified pages 12, 17, 18, and 22 directly from the primary PDF (*"பஞ்ச பட்சி ஆருடம்"*, Kottumozhi Sathya).
  - **Page 12 (Activity Window Percentages):** Arasu (Ruling) 100% success (`100% வெற்றியும்`), Oon (Eating) 80% success (`80% வெற்றியும்`), Nadai (Walking) 40% mixed/dragging success (`40% இழுபறியில் வெற்றியும்`), Thuyil (Sleeping) 80% failure (`80% தோல்வியும்`), Saavu (Dying) 90% failure (`90% தோல்வியும்`).
  - **Page 22 (Shukla / Valarpirai Adhikara blocks):** Vulture: Sun-day, Tue-day, Fri-night; Owl: Mon-day, Wed-day, Sat-night; Crow: Thu-day, Sun-night, Tue-night; Rooster: Fri-day, Mon-night, Wed-night; Peacock: Sat-day, Thu-night.
  - **Page 17 (Krishna / Theipirai Adhikara blocks):** Vulture: Fri-day, Sun-night; Owl: Thu-day, Wed-night; Crow: Wed-day, Thu-night; Rooster: Sun-day, Tue-day, Mon-night; Peacock: Mon-day, Sat-day.
  - **Page 18 (Padu-Pakshi downtime days — day & night):** Shukla: Vulture Thu/Sat, Owl Sun/Fri, Crow Mon, Rooster Tue, Peacock Wed; Krishna: Vulture Tue, Owl Mon, Crow Sun/Thu, Rooster Sat, Peacock Wed/Fri.
- Corroborates the 2025 Panja Pakshi Workshop Day 2 transcript (`docs/research/transcripts/panja-pakshi-2025/pp-class-02.md` @ 02:41–23:45).

---

## 2. EARS Definition of Done Verification

| Requirement | Result | Evidence / Finding |
| :--- | :---: | :--- |
| **R1.1** (Ordering & failure sign) | ✅ PASS | `IntegratedArudamEngine.getBaseBirdScore` returns Ruling (100) ≫ Eating (80) ≫ Walking (50 = neutral midpoint) > Sleeping (20) > Dying (5). Failure states (Sleeping, Dying) are below the 50 neutral midpoint. |
| **R1.2** (Doc comment citation) | ✅ PASS | Code documentation cites CONF-PP-007 / Kottumozhi Sathya p. 12 with explicit percentages (100 / 80 / 40-mixed / 80-fail / 90-fail). |
| **R1.3** (Pure function) | ✅ PASS | `getBaseBirdScore` remains a pure function of `PakshiState` with zero side effects. |
| **R2.1** (Adhikara & Padu helper) | ✅ PASS | New `PakshiAdhikara` pure helper in `lib/features/astro_engine/domain/pakshi_adhikara.dart` exposes `isAdhikara`, `isPadu`, and `statusFor`. |
| **R2.2** (Data-driven const tables) | ✅ PASS | Backed by four const lookup maps (`_shuklaAdhikara`, `_krishnaAdhikara`, `_shuklaPadu`, `_krishnaPadu`), zero scattered conditionals. |
| **R2.3** (Status & modifier available) | ✅ PASS | `PakshiAdhikara.scoreModifier` provides 1.15 for Adhikara, 0.5 for Padu, and 1.0 for normal. Wired into `OracleCompositeEngine.evaluate` via optional `bird` parameter. |
| **R3.1** (State tables byte-unchanged) | ✅ PASS | `git diff main...HEAD -- lib/features/astro_engine/domain/pakshi_calculator.dart` is clean (empty diff). |
| **R3.2** (Sequence invariant pinned) | ✅ PASS | `test/features/astro_engine/pakshi_sequence_regression_test.dart` asserts all 28 table instances across all 7 weekdays and both moon phases match pinned ruling sequences and SHA-256 digest `4c97e1eedc031e4b74cb61b6f27fc29819e6635855c72802b0cb6fdbc104f29b`. |
| **R4.1** (Golden scoring shift) | ✅ PASS | `test/features/astro_engine/oracle_scoring_golden_test.dart` records pre-change and post-change scores for a fixed input suite (9 tests green). `test/golden/astro_golden.json` regenerated via `tool/regen_golden.dart`. |
| **R4.2** (Floor-lock invariant) | ✅ PASS | Rahu Kaal and Emakandam inauspicious window floor-lock (score=10, band=sunya) verified invariant across day and night. |
| **RT** (Tamil bilingual standing) | N/A | No new user-facing UI strings surfaced this spec; helper is internal domain logic. |
| **RC** (CONF provenance standing) | ✅ PASS | All weights, modifiers, and tables cite CONF-PP-007 and Kottumozhi Sathya pp. 12, 14, 17, 18, 22. |
| **RQ** (Regression gate standing) | ✅ PASS | Per-yama sequence UNCHANGED; Ruling & Eating classifications preserved; only Walking/Sleeping/Dying weights shifted. `just validate-local` green on all 4 gates. |

---

## 3. Regression & Characterization Statement (TR / RQ)

- **Per-yama state sequence tables are 100% UNCHANGED:** Verified by zero diff in `pakshi_calculator.dart` and the 28-instance regression test with SHA-256 state hashing.
- **Ruling and Eating state classifications are PRESERVED:** Day-time Oracle queries where bird state is Ruling or Eating maintain their identical favorable scores and band classifications (Siddha / Vardhana).
- **Walking, Sleeping, and Dying weights shifted to reflect authentic failure/dragging semantics:**
  - Walking: base shifted from 60 to 50 (neutral midpoint, representing 40% mixed / dragging success).
  - Sleeping: base shifted from 30 to 20 (adverse, representing 80% failure).
  - Dying: base shifted from 10 to 5 (severe adverse, representing 90% failure).
- **Rahu Kaal & Emakandam Floor-Locks:** 100% invariant at score=10 (`OracleBand.sunya`).

---

## 4. Quality Gates Execution Log (RQ)

```
validate-local — pre-PR quality gates (mirrors CI)

Gate 1 — dart analyze --fatal-infos:
  ✅ analyze clean (zero issues)

Gate 2+3 — flutter test --coverage (>= 19%):
  ✅ tests green except the 4 known CloudKit macOS failures (exact baseline — accepted)
  ✅ coverage 42.9% (>= 19%)

Gate 4 — flutter build web:
  ✅ web build compiles

✔ all gates green — safe to open the PR
```

---

## 5. Verification Sign-Off

- **Executor:** Antigravity IDE
- **PR:** https://github.com/vteial/saranidhi/pull/304
- **Verification Status:** PASS (`/verification-done` verified by Human owner).
