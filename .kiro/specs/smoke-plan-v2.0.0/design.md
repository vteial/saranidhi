# Design — v2.0.0 Smoke-Test Plan (`smoke-plan-v2.0.0`)

## Approach
Author `docs/testing/releases/v2.0.0/smoke-test.md` by matching the house format of the latest dossier
smoke (`v1.13.0/smoke-test.md`): a header note stating the release character, a **pre-flight** block,
numbered **scenarios** with checkbox steps, and an empty **result table** for the owner to fill. The
content is derived firsthand from the `[Unreleased]` CHANGELOG feature manifest.

## Document structure (the sections the plan will contain)
1. **Header** — "v2.0.0-web · first MAJOR release · re-characterizes the full surface", environment
   (release PR preview + bypass secret + live Fly PocketBase).
2. **Pre-flight** — reachability, exact version string `Saranidhi v2.0.0`, CI-green, backend health.
3. **Scenarios** (R2–R4):
   - S1 WhatsNew + journal widgets · S2 perf + reduced-motion a11y · S3 l10n disambiguation ·
     S4 Prasanam Oracle · S5 engine (Adhikara/Padu + null-bird no-op + floor-locks) ·
     S6 Practice Sync (opt-in gate / zero-network-off / auto-on-open / round-trip) ·
     S7 standing regression sweep · S8 bilingual EN/TA sweep.
4. **Result table** — empty, one row per scenario.
5. **Known-defect note** — the release-doctrine rule for cosmetic vs blocker.

## Key design decisions
- **D1 — Major-release scope, not sprint-delta.** Because this is the 1.x→2.0 bump, the smoke covers
  the whole accumulated feature set, not only the last sprint. (The v1.13.0 smoke was a single-feature
  smoke; this one is a full re-characterization.)
- **D2 — The engine scenario is the sharpest (RC).** Adhikara/Padu is the one shipped change that
  touched scoring semantics. The scenario must verify: (a) the boost/penalty shows for an onboarded
  bird, (b) a **null-bird profile is a byte-identical no-op** (multiplier = 1.0), (c) Rahu/Emakandam
  floor-locks still override the boost. Cites CONF-PP-007 so the smoke checks the real doctrine.
- **D3 — Sync scenario re-uses the v1.13.0 round-trip but adds the auto-on-open fast-follow.** The new
  behavior to verify is: fires once on cold open + 5-min resume, ONLY when opted in + authenticated,
  zero network when disabled (the consent gate).
- **D4 — No version bump here.** The plan is authored on a `docs/*` branch; the `Saranidhi v2.0.0`
  string in the pre-flight is the *target assertion* the owner checks at release time — this Spec does
  NOT touch pubspec (that happens at `/release-start`).

## Open questions (resolve at T0)
- **OQ-1** — confirm the dossier folder convention: does the smoke live at
  `docs/testing/releases/v2.0.0/smoke-test.md` (rich-release folder, the v1.7.0+ pattern) — yes, match
  the latest. Create the folder; the other dossier files come later at `/release-start`.
- **OQ-2** — confirm the smoke-test index/results file that rows link back to
  (`docs/testing/smoke-test-results.md`) and whether this Spec adds the v2.0.0 index row now or defers
  it to `/release-update` (defer — the result isn't known until the owner runs it).

## Rejected alternative
- **Authoring the full `/release-start` dossier now** — rejected: that's the release-lifecycle command's
  job (it bumps pubspec, cuts `release/v2.0.0`, pre-fills the preview URL + PR #). Authoring it here
  would duplicate that work on the wrong branch class and pre-empt the owner's release gate. This Spec
  produces only the smoke-plan content the dossier will carry.
