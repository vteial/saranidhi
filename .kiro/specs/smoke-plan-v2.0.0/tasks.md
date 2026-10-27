# Tasks — v2.0.0 Smoke-Test Plan (`smoke-plan-v2.0.0`)

> This Spec authors a release QA document. Low-risk pure-docs — may be done directly by the Operator
> (lead-paired, lighter contract), OR handed to the Executor via `/spec-run`. No code, no engine.

## T0 — Preflight & ground the open questions
- [x] Re-read `docs/testing/releases/v1.13.0/smoke-test.md` for house format (pre-flight → scenarios →
      result table).
- [x] Re-read the `[Unreleased]` CHANGELOG block firsthand — it is the authoritative v2.0 feature
      manifest the scenarios must cover.
- [x] **OQ-1:** create `docs/testing/releases/v2.0.0/` (rich-release folder); the smoke lives at
      `.../v2.0.0/smoke-test.md`.
- [x] **OQ-2:** confirm the smoke-results index; DEFER adding the v2.0.0 row (result unknown until run).

## T1 — Author the pre-flight block (R1, R6)
- [x] Reachability (bypass URL HTTP 200), exact `Saranidhi v2.0.0` version assertion (abort on
      mismatch), CI-green on PR head, Fly backend health curl (note cold-start).
- [x] State the environment: release PR Vercel **preview** (NOT staging) + `VERCEL_AUTOMATION_BYPASS_SECRET`
      query param + live Fly PocketBase.

## T2 — Author the new-feature scenarios (R2)
- [x] S1 WhatsNew (once, post-onboarding) + pin/star (pinned-first) + streak milestone + preset guidance.
- [x] S2 perf (fast cold paint) + reduced-motion a11y (static end-states on pacers/shimmer/overlay).
- [x] S3 l10n (unpin `பின் அகற்று` ≠ delete `நீக்கு`; yama notif `Saranidhi — யாம N`).
- [x] S4 Prasanam Oracle (reading → band; window banner; user-initiated save).
- [x] S5 engine — Adhikara/Padu boost+penalty for onboarded bird; **null-bird no-op (×1.0)**;
      Rahu/Emakandam floor-locks override (cite CONF-PP-007 — RC).
- [x] S6 Practice Sync — opt-in gate (zero network off) + auto-on-open (once cold / 5-min resume, only
      when authed) + cross-device round-trip + idempotent re-sync.

## T3 — Author the standing regression + bilingual scenarios (R3, R4)
- [x] S7 regression sweep — onboarding dual-path, dashboard (bird/Rahu/10-yama/Hora/Tattva), journal,
      Analytics, Settings export/import (Merge-Restore + owner-guard), offline-first with sync OFF.
- [x] S8 bilingual EN/TA sweep over the new v2.0 surfaces (Oracle, WhatsNew, preset, streak, pin) —
      pure Tamil, no English leak (RT gate).

## T4 — Result table + known-defect note (R5)
- [x] Empty result table, one row per scenario (S1–S8).
- [x] Known-defect note: cosmetic pre-existing → may ship as owner-accepted backlogged defect;
      functional blocker → fix on SAME release branch + re-verify that scenario.

## TV — Validate
- [x] `just validate-docs` green.
- [x] Internal consistency: every manifest feature has a scenario; every scenario has a result row.

## TP — Lockstep
- [x] (Deferred to `/release-update`) the smoke-results index row — NOT added here (result unknown).
- [x] No CHANGELOG/tracker flip here — this is a release-prep doc, not a shipped feature; the release
      lifecycle commands handle the registry at `/release-start`/`/release-update`.

## Human Verification Plan (if run via Executor)
1. Open `docs/testing/releases/v2.0.0/smoke-test.md` → confirm pre-flight + S1–S8 + result table present.
2. Confirm every `[Unreleased]` feature maps to a scenario (no gap).
3. `just validate-docs` green; 0 code/engine files in the diff.
- [x] **TV — After human verification passes: `/verification-done`** (human-verify PASS recorded in REPORT.md)
