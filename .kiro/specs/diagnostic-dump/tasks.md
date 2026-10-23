# Saranidhi Diagnostic Dump — Tasks (/spec-run build plan)

> **Execution:** Executor (Antigravity) runs `/spec-run diagnostic-dump` after the owner merges this
> Spec. Branch `sprint/diagnostic-dump` off `main`. Run `just validate-local` green before the PR.
> All tasks unchecked — this is the forward plan.

- [ ] **T0 — Seam read (no writes).** Confirm the exact read-only engine entrypoints for all 10 yamas
      (day `PakshiDayResult.stateTable`; the night Y6–Y10 state accessor — OQ-1), sunrise/sunset,
      lunar phase, nakshatra, weekday. Confirm `package:args` availability (OQ-2). **If any field
      requires a non-trivial `lib/` change, STOP and report** — the dump must be a pure reader.
- [ ] **T1 — Script skeleton.** Create `tool/dump_diagnostic.dart` with `main`, arg parsing,
      `--help`, and validation (R1.4, R3.3). Invalid/missing args → stderr + non-zero exit.
- [ ] **T2 — Day path.** Wire Y1–Y5 ruling bird + subject-bird state from `PakshiDayResult`;
      sunrise/sunset, weekday, lunar phase, nakshatra per day (R1.1–R1.3).
- [ ] **T3 — Night path.** Wire Y6–Y10 via `calculateNight` → `NightYamaResult` and the night state
      accessor confirmed in T0 (R1.1–R1.2).
- [ ] **T4 — Serializers.** `--format json` (deterministic, sorted keys — R2.2) and `--format md`
      (GitHub table). `--out` optional file write; stdout default; no write otherwise (R2.3, R3.1).
- [ ] **T5 — Unit test.** `test/tool/dump_diagnostic_test.dart`: 70-record shape, all R1 fields,
      determinism (byte-identical twice), invalid-bird rejection.
- [ ] **TV — Self-verify.** Run the VERIFICATION commands from `requirements.md`; capture a 7-day
      `--format md` sample in the REPORT. `git diff main...HEAD -- lib/ test/golden/` empty (R4.1);
      golden suite green (R4.2).
- [ ] **TR — RT (Tamil):** record **N/A** (developer CLI, no user-facing strings) in the REPORT.
- [ ] **TC — RC (CONF):** REPORT notes the subject-bird default (Owl) traces to CONF-PP-001/002;
      no new doctrine asserted.
- [ ] **TG — Lockstep:** CHANGELOG `[Unreleased]` entry + SPRINT_TRACKER row for the dump.
- [ ] **TP — PR + Human Verification Plan.** Open the PR (Executor opens; owner merges). Emit the
      Human Verification Plan. **STOP** for `/review-pr`. Never merge.

## Flagged, NOT in this build
- `integrated_arudam_engine.dart` **CONF-018 miscitation** — out of scope; its own unit.
- Readiness-penalty tuning — the epic's last task; needs the measured 7-day data.
