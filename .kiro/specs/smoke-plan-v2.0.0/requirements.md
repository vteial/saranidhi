# Requirements — v2.0.0 Smoke-Test Plan (`smoke-plan-v2.0.0`)

> **Class:** release-gated deliverable (the QA dossier the owner runs on the release PR's Vercel
> preview before `/release-finish`). This Spec AUTHORS the smoke-test plan document; it does **not**
> run the release. `/release-start v2.0.0-web` (separate lifecycle command) bumps pubspec, cuts the
> `release/v2.0.0` branch, and lands the dossier — this Spec produces the `smoke-test.md` content that
> dossier will carry.

## Intent (one sentence of "done")
A complete, owner-runnable v2.0.0 smoke-test plan (`docs/testing/releases/v2.0.0/smoke-test.md`) that
characterizes every feature shipped since v1.13.0 **plus** the standing regression surface, in the
house format (pre-flight → numbered scenarios with checkboxes → result table), bilingual-aware.

## Why v2.0.0 is a MAJOR bump (grounds the smoke scope)
v1.13.0 → **2.0.0** is the firm's first major-version increment. The smoke must therefore cover the
**full accumulated `[Unreleased]` feature set** (not just one sprint's delta), because a major release
re-characterizes the whole surface. Firsthand from the `[Unreleased]` CHANGELOG, the shipped v2.0 set:

| Area | Feature | Source |
| :--- | :--- | :--- |
| UX wiring | WhatsNew gate · PresetSelector guidance · StreakCelebration · isPinned journal | `deferred-widgets-wiring` (#312) |
| Perf / a11y | startup off critical path · run-once on-open · reduced-motion across animations | `performance-pass` (#315) |
| l10n | unpin/delete disambiguation · yama notif title localized | `l10n-polish-sweep` (#317) |
| Docs | User Guide refreshed for the v2.0 feature set (Oracle, nav, sync) | `user-guide-refresh` (#319) |
| Engine | Adhikara / Padu-Pakshi activation · Pakshi scoring corpus-alignment | `adhikara-padu-activation`, `pakshi-scoring-corpus-alignment` |
| Correctness | Golden-fixture gate + independent-truth hardening | `TSK-golden-01/02` |
| Sync | Practice Sync auto-on-open fast-follow | `practice-sync-auto-on-open` |
| Tooling | diagnostic dump (read-only CLI) | `diagnostic-dump` |

## Requirements (EARS)

- **R1 — Pre-flight gate.** The plan SHALL open with a pre-flight block: preview reachable at the
  bypass URL (HTTP 200); **About card reads exactly `Saranidhi v2.0.0`** (wrong version → abort, no
  fallback); required CI green on the release PR head; backend health (`curl .../api/health → 200`,
  noting scale-to-zero cold-start).
- **R2 — New-feature scenarios.** The plan SHALL have one numbered scenario per v2.0 feature area above,
  each with concrete checkbox steps a human runs on the preview:
  - **S-widgets** — WhatsNew fires once post-onboarding; pin/star pinned-first; streak celebration at a
    milestone; preset shows guidance without overwriting manual capture.
  - **S-perf/a11y** — app paints fast on cold open; with OS reduced-motion ON, repeating animations
    show static end-states (pacers, shimmer, streak overlay) and the app is fully usable.
  - **S-l10n** — in Tamil: unpin tooltip `பின் அகற்று` ≠ delete `நீக்கு`; yama notification title
    `Saranidhi — யாம N`.
  - **S-oracle** — Prasanam tab: a reading resolves into a band; window-status banner reflects
    conditions; "Save to History" is user-initiated (not auto).
  - **S-engine** — Adhikara boost / Padu penalty reflected in Oracle + Home ambient card for an
    onboarded bird; **un-onboarded (null-bird) profile is a byte-identical no-op**; Rahu/Emakandam
    floor-locks still take precedence.
  - **S-sync** — Practice Sync auto-on-open fires once on cold open / 5-min resume **only when opted in
    + authenticated**; **zero network when disabled**; cross-device round-trip + idempotent re-sync.
- **R3 — Standing regression scenarios.** The plan SHALL re-verify the always-checked surface:
  onboarding (dual-path), dashboard (bird card / Rahu Kaal / 10-yama / Hora / Tattva), journal,
  Analytics, Settings export/import (Merge-Restore + owner-guard), offline-first with sync OFF.
- **R4 — Bilingual sweep.** The plan SHALL include a dedicated EN/TA scenario covering the new v2.0
  surfaces (Oracle, WhatsNew, preset guidance, streak overlay, pin affordance) in pure Tamil.
- **R5 — Result table + known-defect handling.** The plan SHALL carry an empty result table (one row
  per scenario) for the owner to fill, and a note that a minor pre-existing cosmetic defect may ship
  as an owner-accepted backlogged known defect (per the release doctrine); a functional blocker is
  fixed on the SAME release branch and the scenario re-verified.
- **R6 — Environment + bypass.** The plan SHALL name the environment as the release PR's **Vercel
  preview** (NOT staging) with the `VERCEL_AUTOMATION_BYPASS_SECRET` query-param auth, and the live Fly
  PocketBase for the sync round-trip.

## Standing criteria
- **RT:** the bilingual scenario (R4) IS the Tamil gate for the release — pure script, no English leak
  on the new surfaces.
- **RC:** the engine scenario (S-engine) SHALL cite the CONF provenance for Adhikara/Padu
  (CONF-PP-007, Kottumozhi Sathya pp. 14/17/18/22) and the null-bird no-op invariant, so the smoke
  verifies the shipped doctrine, not an invented one.
- **RQ:** this is a docs deliverable — `validate-docs` green; the plan is internally consistent (every
  listed feature has a scenario; every scenario has a result-table row).

## Out of scope (explicit)
- Running the release (`/release-start`/`/release-finish`), the pubspec bump, the branch cut, the tag.
- The other dossier files (`release-notes.md`, `docs-audit.md`, `qa-verify-prompt.md`, `README.md`) —
  those are authored at `/release-start`. This Spec is the **smoke-test plan content** only.
- Any code, engine, or schema change.
