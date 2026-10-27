# Tasks — User Guide Light Refresh (`user-guide-refresh`)

> Executor contract: implement on `fix/`|`sprint/`, run local suite GREEN (except the 4 known CloudKit
> macOS failures), open the PR, emit the Human Verification Plan, STOP. Never merge.

## T0 — Preflight & ground the open questions
- [x] Re-read `user_guide_screen.dart`, `app_en.arb`/`app_ta.arb` `guide*` keys firsthand.
- [x] **OQ-1:** confirm current bottom-nav labels/order from the router/nav source (not just steering).
- [x] **OQ-2:** grep for any existing `guideOracle*` key; extend if present, don't duplicate.
- [x] **OQ-3:** confirm canonical existing Tamil for Oracle/Prasanam, Hora, Tattva and reuse it.

## T1 — Pin regression invariants FIRST (RQ)
- [x] Widget test: `UserGuideScreen` renders the expected ordered set of `_Section`s + the
      `_ReferenceSection` (asserts the flat architecture is intact — RQ.1).
- [x] Assert the four reference tables (Planets/Elements/Birds/Nakshatras) still render (RQ.2).
- [x] These tests pass on the UNCHANGED screen before any content edit (pin the baseline).

## T2 — Oracle section (R1)
- [x] Add `guideOracleTitle` / `guideOracleBody` to EN + TA ARB (pure Tamil, descriptive-only per D2).
- [x] Wire one new `_Section(title: l10n.guideOracleTitle, body: l10n.guideOracleBody)` after the
      Dashboard section in the sliver list (D1).

## T3 — Nav correction (R2)
- [x] Correct stale "Explore tab" references in `guideHowToBody` + `guideBestBody` (EN + TA) to the
      current Home · Journal · Oracle · Analytics nav + gear Settings.

## T4 — Journal + dashboard feature content (R3, R4)
- [x] Add pin/star (pinned-first), streak milestone celebrations, and guided breath presets to the
      How-to / Dashboard / Benefits bodies (EN + TA).
- [x] Add active Hora + Tattva readings to `guideDashboardBody` (EN + TA).

## T5 — Practice Sync note (R5)
- [x] One FAQ Q&A + one Benefits/How-to line on opt-in, default-OFF, local-first-preserving sync
      (EN + TA), framed per D3 so the privacy guarantee is not contradicted.

## T6 — Doc mirror (R6)
- [x] Mirror all new/changed prose into `docs/product/user-guide.md`. Leave the `> Reviewed:` stamp
      (release-gated).

## TL — l10n generate
- [x] `flutter gen-l10n` — regenerate; never hand-edit generated files.

## TT — Tamil gate (RT)
- [x] Eyeball Tamil mode for every new/changed section — pure script, no transliteration, no hardcoded
      English. (Recurring-miss gate.)

## TC — Standing criteria
- [x] **RC = n/a** — assert in the REPORT that no engine/calc/doctrine file was touched (content only).
- [x] `flutter analyze --fatal-infos` clean; guide/l10n tests green; coverage ≥ 19%.

## TG — Firewall check
- [x] `git diff main --name-only -- lib/features/astro_engine/` is **empty** (0 engine files).
- [x] Diff is confined to the guide screen, the two ARB files + generated, the doc, and the new test.

## TP — Lockstep at close
- [x] CHANGELOG `[Unreleased]` entry (user-guide-refresh).
- [x] SPRINT_TRACKER row.
- [x] Flip the BACKLOG "User Guide refresh" item to done (NOT the structured-model epic row).

## Human Verification Plan (Executor emits, owner runs)
1. Open guide in EN → confirm Oracle section present, nav references correct, journal/dashboard/sync
   content present.
2. Switch to Tamil mode → confirm every new section renders in pure Tamil script (no English leak).
3. Confirm the guide still scrolls as one flat list (no ToC/search appeared) and the reference tables
   render.
4. `just validate-local` green (±4 CloudKit); 0 astro-engine files in the diff.
