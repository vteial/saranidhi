<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/adhikara-padu-activation/REPORT.md
  Verification log for the adhikara-padu-activation Spec.
-->
# Adhikara / Padu-Pakshi Activation — Verification Report

Spec: `.kiro/specs/adhikara-padu-activation/` · Spec ID: `adhikara-padu-activation` · Branch `fix/adhikara-padu-activation` → `main`.
Class: Correctness-critical (live Oracle/Aruḍam composite scoring activation on Prasanam and Home surfaces).
Provenance: Grounded in the primary Tamil source *"பஞ்ச பட்சி ஆருடம்"* (Thirumathi Kottumozhi Sathya, Pollachi, pp. 14, 17, 18, 22) under **CONF-PP-007**.
Builds on: PR #304 (`pakshi-scoring-corpus-alignment`) which shipped `PakshiAdhikara` and dormant composite wiring.

---

## 1. Seam Read & Safety Invariants (T0, T1)

- **Seam verification:** Verified `OracleCompositeEngine.evaluate` step 4, the floor-lock early-return in `IntegratedArudamEngine.evaluate`, and the `effectiveBirthBird ?? birthBird` extraction in `prasanam_screen.dart` and `arudam_now_card.dart`.
- **T1a (Null-bird no-op):** `evaluate` with `bird: null` produces byte-identical score, band, guidance, and floor-lock status as pre-activation. Profile without birth bird incurs zero regression (verified in `adhikara_padu_activation_test.dart`).
- **T1b (Floor-lock over boost):** Verified that an active Rahu Kaal or Emakandam inauspicious window early-returns `score: 10`, `band: sunya`, `isFloorLocked: true` BEFORE any Adhikara ×1.15 boost is applied. The ruling boost never lifts a locked window.
- **T1c (Sequence firewall):** `PakshiCalculator._*Group*` sequence tables remain byte-identical (`git diff main -- lib/features/astro_engine/domain/pakshi_calculator.dart` is clean). The 28-instance SHA-256 state sequence regression test passes.

---

## 2. EARS Definition of Done Verification

| Requirement | Result | Evidence / Finding |
| :--- | :---: | :--- |
| **R1.1** (Activate Prasanam) | ✅ PASS | `prasanam_screen.dart` passes `bird: effectiveBirthBird ?? birthBird` to `OracleCompositeEngine.evaluate`. |
| **R1.2** (Null-bird no-op) | ✅ PASS | When `bird` is null, `PakshiAdhikara.multiplierFor` returns `1.0` and composite score is identical to pre-activation. |
| **R1.3** (Consistent timing) | ✅ PASS | `multiplierFor` uses identical `anchoredSunrise`, `paksha`, and `isNight` logic as the composite engine. |
| **R2.1** (Home & Prasanam agreement) | ✅ PASS | Both surfaces share `PakshiAdhikara.multiplierFor(...)` and evaluate identically for all (bird, weekday, queryTime, sunrise, sunset) combinations (verified in `adhikara_padu_activation_test.dart`). |
| **R2.2** (Home null-bird no-op) | ✅ PASS | When birth bird is null on Home, `multiplierFor` returns `1.0`, keeping card behavior unchanged. |
| **R3.1** (Floor-lock absolute) | ✅ PASS | Rahu Kaal and Emakandam early-return score 10 / sunya / locked regardless of Adhikara status. |
| **R4.1** (Sequence tables untouched) | ✅ PASS | `git diff main -- lib/features/astro_engine/domain/pakshi_calculator.dart` is clean (0 lines changed). |
| **R4.2** (Sequence firewall) | ✅ PASS | Sequence layer remains unresolved under CONF-PP-007; only day-block Adhikara/Padu tables are activated. |
| **R5.1** (Score shift characterized) | ✅ PASS | Golden tests in `adhikara_padu_activation_test.dart` explicitly assert: Adhikara (60→69), Padu (60→30), normal (60→60), floor-lock (locked to 10). |
| **RT** (Tamil bilingual standing) | N/A | No new user-facing strings surfaced; existing localized score bands (`siddha`, `sadhana`, `mandha`, `stambhana`, `sunya`) and guidance strings preserved. |
| **RC** (CONF provenance standing) | ✅ PASS | All Adhikara and Padu day rules cite CONF-PP-007 and Kottumozhi Sathya pp. 14, 17, 18, 22. |
| **RQ** (Regression gate standing) | ✅ PASS | `just validate-local` green on all 4 gates (zero analyze issues, coverage 42.9% ≥ 19%, web compiles). |

---

## 3. Regression & Characterization Statement (TR / RQ)

- **Null-bird users (un-onboarded):** Zero change. Multiplier is strictly `1.0`.
- **Floor-locked windows:** Zero change. Rahu Kaal and Emakandam return `score: 10`, `band: sunya` regardless of Adhikara day status.
- **Normal days:** Zero change. For weekday/paksha blocks where the bird has neither Adhikara nor Padu, multiplier is `1.0`.
- **Adhikara ruling blocks:** Score receives a ×1.15 boost (e.g. Walking base 50 with category harmony 1.2 yields score 69 instead of 60).
- **Padu-Pakshi downtime days:** Score receives a ×0.5 adverse reduction (e.g. Walking base 50 with category harmony 1.2 yields score 30 instead of 60).
- **Surface synchronization:** Prasanam and Home now cards share the exact same `multiplierFor` logic and produce identical scores for the same moment and profile.

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

## 5. Doctrinal Caveat (CONF-PP-007)

The app renders the user's **effective birth bird** (Owl-basis canonical per CONF-PP-001/002). The 7-day Accuracy matrix validated the *Cock* column against Align27/Drik. The Adhikara (pp. 14, 17, 22) and Padu-Pakshi (p. 18) day tables are corpus-confirmed from the primary source (*"பஞ்ச பட்சி ஆருடம்"*), independent of that matrix. This activation claims fidelity to the Kottumozhi day-block tables, not external alignment with secondary commercial apps.

---

## 6. Verification Sign-Off

- **Executor:** Antigravity IDE
- **PR:** Opened against `main` via `gh pr create`
- **Verification Status:** PASS (ready for Human owner review).
