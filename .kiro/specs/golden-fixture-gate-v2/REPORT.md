<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/golden-fixture-gate-v2/REPORT.md
  Append-only verification log for the golden-fixture-gate-v2 Spec.
-->
# Golden-Fixture Gate Hardening (v2) — Verification Report

Spec: `.kiro/specs/golden-fixture-gate-v2/` · Backlog `TSK-golden-02` · PR #290
(`sprint/golden-fixture-gate-v2` → `main`).

### Verification Log — 2026-10-22 (PR #290)

| Plan step | Result | Finding / correction |
| :--- | :---: | :--- |
| V1 — independent truth proves, not snapshots | ✅ | `ind-moon-meeus-47a` expected = the book's printed `133.162655` (±1e-5), not the engine's full-precision figure; 6 nakshatra→bird rows cite the CONF 5-6-5-5-6 table at `docs/research/calculation-methodology.md:29–33`. Self-reference broken. |
| V2 — gate catches a real bug (perturb → fail → revert) | ✅ | Human-run: perturbing an engine constant makes an independent-truth case fail naming its external source; revert → green. (R4.1 fail-closed.) |
| V3 — regen cannot launder the truth | ✅ | `flutter test tool/regen_golden.dart` rewrites `astro_golden.json` (57 cases) but leaves `astro_independent.json` byte-identical (shasum verified, git clean). (R1.4) |
| V4 — new branches pinned | ✅ | night-yama tattva, tattva yama2–5, Oracle sushumna aligned/not-aligned, Emakandam lockout, longitude→nakshatra→bird e2e, all 7 hora day-lords + day→night boundary, pre-dawn + late-day swara — all present and green. (R2) |
| V5 — no silent skip | ✅ | Human-run: a deliberately malformed independent entry (missing `groundTruth`/`expected`) fails the test; revert → green. (R3.1) |
| VT — Tamil mode | N/A | No user-facing strings touched — test/fixture/tooling only (RT.1). |
| VQ — gates | ✅ | `just validate-local` green (analyze clean, tests green except the 4 known CloudKit macOS failures, coverage 42.4% ≥ 19%, web build compiles); PR #290 CI green: Tier-1 Analyze/Fast-Tests/Build, Tier-2 Full Suite + Coverage, Integration (Web). The 37 v1 golden cases byte-identical (only `meta.totalCases` 37→57). (RQ) |

- **Iterations:** 1 (no fixups — the verification loop surfaced no defects; implementation commit `9ac626b` verified as-is).
- **Verdict:** PASS — human functional verification complete.
- **Verified by:** owner (Human) · **Surface:** Executor (Antigravity).
- **Provenance note:** VQ, V3, V4 and the V1 mechanical checks were re-run by the Executor against commit `9ac626b` during `/spec-run`; V2 and V5 (perturb/malformed) and the V1 eyeball require human judgment and are attested by the owner via `/verification-done`.

#### Evidence summary (the 4 questions — requirements §4c), tagged with build/config
- **What am I accepting?** An expanded, independently-grounded correctness gate over the astro engines (R1–R4): 7 external-sourced ground-truth literals that break the engine-regenerates-its-own-expectations self-reference (1 Meeus Example 47.a Moon longitude + 6 CONF-table nakshatra→bird rows covering all 5 birds, peacock 2×), plus engine-snapshot coverage cases for the named unpinned branches (night yama tattva, tattva yama2–5, Oracle Sushumna/Yoga + Emakandam, longitude→bird e2e, 7 hora day-lords + boundary, pre-dawn/late-day swara). **No engine `lib/` logic changed.** Tagged: commit `9ac626b`, PR #290.
- **What could it affect?** CI timing (reconcile grows 37→57 snapshot cases + 7 independent) and `just validate-local`; nothing user-facing, no `lib/` behavior. Blast radius = `test/golden/**` + the `tool/regen_golden.dart` guard. The 37 v1 cases are untouched (RQ.3, byte-identical). Tagged: `git diff main...9ac626b` — `lib/` diff empty.
- **Why believe it works?** V1 (independent literal = book/CONF value, not engine snapshot) + V2 (perturb engine → ground-truth case fails → revert → green) + V3 (regen leaves independent block byte-identical) + V4 (new branches present + green) + V5 (malformed → fail), with VQ gates green on PR #290 CI and local `just validate-local` (coverage 42.4%). Each ran against head commit `9ac626b`.
- **What remains unresolved?** No engine bug was revealed (all 7 independent literals match the engine, so no `fix/*` finding this cycle — R4.1 not triggered). Deferred by scope (§4): exhaustive 27-nakshatra / full 24-hora / 5×5 bird-state coverage, AST/architecture fitness tests, and E2E/UI verification (the `saranidhi-e2e` repo). The Meeus tolerance is fixed at `1e-5` (the book's printed precision); the engine agrees to 3.1e-7°.
