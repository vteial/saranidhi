# Requirements — User Guide Light Refresh (`user-guide-refresh`)

> **Class:** sprint deliverable (user-facing content that ships to users; bilingual EN+TA is a DoD gate).
> **Scope call (owner-authorized, this session):** a **light CONTENT refresh** of the existing flat
> guide to cover the v2.0 feature set. **NOT** the structured-model (`GuideSection`/ToC/search/collapse)
> epic — that stays post-2.0, sequenced after the native "Now" Surface (BACKLOG.md §"User Guide —
> Book-Style Navigation & Search"). This Spec touches guide *content only*, never the guide's widget
> architecture.

## Intent (one sentence of "done")
The in-app User Guide (`user_guide_screen.dart`, driven by `guide*` ARB keys) and the mirror doc
(`docs/product/user-guide.md`) describe every v2.0 user-facing feature, with the stale 4-tab/"Explore"
nav references corrected — EN + pure Tamil, zero new widget structure.

## Grounded content gap (firsthand, guide bodies vs. `[Unreleased]` CHANGELOG)
The 12 existing sections are accurate for what they cover, but these **shipped v2.0 features are absent
or stale** in the guide bodies:

| Gap | Where | Shipped in |
| :--- | :--- | :--- |
| **Prasanam Oracle** — the dedicated 4th nav tab — is entirely unmentioned | How-to, Dashboard, FAQ | flagship v2.0 feature |
| **Nav drift** — guide says "Explore tab"; current nav is **Home · Journal · Oracle · Analytics** + gear-icon Settings | `guideHowToBody` ("Explore"), `guideBestBody` | pre-v2.0 → now stale |
| **Pin/star journal entries** (`isPinned`) unmentioned | Dashboard / How-to | `deferred-widgets-wiring` (#312) |
| **Streak milestone celebrations** (7/30/100/365 overlays) — guide names "Streak" but not the celebration | Dashboard / Benefits | `deferred-widgets-wiring` (#312) |
| **Breath presets** (guided 4-7-8 / Box patterns, PresetSelector) unmentioned | How-to | `deferred-widgets-wiring` (#312) |
| **Hora / Tattva** on the dashboard unmentioned | `guideDashboardBody` | shipped (dashboard compute) |
| **Practice Sync** (opt-in cross-device, default OFF) unmentioned in guide prose | How-to / FAQ / Benefits | v1.13.0 + auto-on-open fast-follow |

## Requirements (EARS)

- **R1 — Prasanam Oracle section.** WHEN the user reads the guide, THEN it SHALL describe the Oracle
  (Prasanam) tab: what it is (a yes/no omen reading via `OracleCompositeEngine`), the 4th nav tab, the
  informational window-status friction, and that history is user-saved (not auto-saved). Added as a new
  `guideOracle{Title,Body}` section placed after the Dashboard section.
- **R2 — Nav correction.** WHEN the guide references app navigation, THEN it SHALL reflect the current
  **Home · Journal · Oracle · Analytics** bottom nav + gear-icon Settings — the stale "Explore tab"
  references in `guideHowToBody` and `guideBestBody` SHALL be corrected.
- **R3 — Journal features.** WHEN the user reads the How-to / Dashboard content, THEN it SHALL mention
  pin/star entries (pinned-first), streak milestone celebrations, and the guided breath presets.
- **R4 — Dashboard section completeness.** WHEN the user reads `guideDashboardBody`, THEN it SHALL list
  the active **Hora** (planetary hour) and **Tattva** (element) readings shown on the dashboard today-view.
- **R5 — Practice Sync note.** WHEN the user reads the guide, THEN it SHALL note Practice Sync as an
  **opt-in, default-OFF** cross-device feature that preserves offline-first and local-first privacy
  (one FAQ entry + one Benefits/How-to line) — framed so the privacy guarantee is not contradicted.
- **R6 — Doc mirror.** WHEN the in-app guide content is refreshed, THEN `docs/product/user-guide.md`
  SHALL be updated to match and its `> Reviewed:` stamp left for the release-gated bump (NOT bumped here).

## Standing criteria
- **RT (Tamil, DoD gate):** every new/changed guide string SHALL be authored in **both** `app_en.arb`
  and `app_ta.arb` in **pure Tamil script** (no transliteration, no hardcoded English). This is the
  recurring miss — eyeball Tamil mode for every new section before the PR.
- **RC (Provenance):** **n/a** — no doctrinal calculation, birth-bird formula, Oracle scoring, or
  astrological rule is modified. This is descriptive content about already-shipped, already-CONF-cited
  features. (The Oracle description SHALL NOT invent doctrine — it describes the shipped behavior only.)
- **RQ (Regression-first):**
  - **RQ.1** — the guide screen's **flat `CustomScrollView` / `_Section` architecture is UNCHANGED**
    (no `GuideSection` model, no ToC, no search — the post-2.0 epic is NOT pulled in). Pin with a
    widget test asserting the screen still renders N `_Section`s in order.
  - **RQ.2** — the bilingual **reference tables** (`_ReferenceSection`: Planets/Elements/Birds/Nakshatras)
    render unchanged.
  - **RQ.3** — `flutter analyze --fatal-infos` clean; existing guide/l10n tests green; new ARB keys
    generate cleanly (`gen-l10n`).

## Out of scope (explicit)
- The `GuideSection` structured model, ToC, in-guide search, per-section collapse/jump — the **post-2.0
  epic**, deferred after the native "Now" Surface.
- Any screenshot/figure assets, video, or interactive guide elements.
- Bumping the doc `> Reviewed:` stamp (release-gated at `/release-update`, not here).
- Any engine, schema, or calculation change.
