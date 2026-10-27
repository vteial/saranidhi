# Design — User Guide Light Refresh (`user-guide-refresh`)

## Approach
Content-only edit through the existing seam: the guide screen already renders every section from
`l10n.guide*` ARB keys, so the refresh is **ARB-value authoring + one new `_Section` call per new
section** — no new widget abstraction. The flat `CustomScrollView` stays; we add/edit keys and wire the
two new sections into the existing sliver list.

## Real seams (firsthand)
| Surface | File | What changes |
| :--- | :--- | :--- |
| In-app guide screen | `lib/features/settings/presentation/user_guide_screen.dart` | Add 1 new `_Section(...)` call for the Oracle section (R1), placed after `guideDashboard`. **No other structural edit.** |
| Guide strings (EN) | `lib/l10n/app_en.arb` | New `guideOracle{Title,Body}`; edit `guideHowToBody`, `guideBestBody`, `guideDashboardBody`, `guideBenefitsBody`, `guideFaqBody` for R2–R5. |
| Guide strings (TA) | `lib/l10n/app_ta.arb` | Same keys, pure Tamil script (RT gate). |
| Generated | `lib/l10n/generated/app_localizations*.dart` | Regenerated via `flutter gen-l10n` — never hand-edited. |
| Doc mirror | `docs/product/user-guide.md` | Mirror the new/changed prose; leave `> Reviewed:` stamp (R6). |

## Content design decisions
- **D1 — Oracle section placement.** New section goes **after** "Understanding the Dashboard" and
  **before** "Benefits", so the reading order is features → dashboard → oracle → benefits → FAQ. Keeps
  the narrative arc intact.
- **D2 — Oracle description stays descriptive, not doctrinal (RC guard).** The body describes the
  shipped UX (a yes/no omen reading, the 4th tab, the window-status banner, user-saved history) and
  explicitly does NOT restate or invent scoring doctrine — avoids enshrining an unverified rule in
  user-facing content.
- **D3 — Practice Sync framing (R5).** Framed as "opt-in, default OFF, your data stays on your device
  unless you turn this on and sign into your own account" — must not contradict the standing privacy
  guarantee in Benefits/FAQ. One FAQ Q&A + one Benefits line; no new section (it's a settings feature,
  not a core daily-practice concept).
- **D4 — Nav correction is a find-replace of stale terms**, not a rewrite: "Explore tab" → the correct
  tab (Analytics for trends, Oracle for omen readings) wherever it appears.

## Open questions (resolve at T0)
- **OQ-1** — Confirm the exact current bottom-nav labels/order from `main_navigation`/router source
  (steering says Home · Journal · Oracle · Analytics) before writing R2 corrections — ground it, don't
  trust the steering note alone.
- **OQ-2** — Confirm whether a `guideOracle*` key already exists (avoid a duplicate key); if partial
  Oracle content exists elsewhere, extend rather than duplicate.
- **OQ-3** — Confirm the Tamil values for any Oracle/Hora/Tattva terms reuse existing canonical ARB
  translations (e.g. the app already localizes "Oracle"/"Prasanam", Hora, Tattva) rather than coining
  new Tamil for a term the app already renders — consistency with the live UI.

## Rejected alternative
- **Pulling in the `GuideSection` structured model** to "do it properly" — rejected: it's the explicit
  post-2.0 epic, sequenced after the Now Surface. Pulling it onto the 2.0 path inverts the owner's
  stated order and turns a content refresh into a multi-sprint structural rebuild. The flat guide's
  *content* is the right shape; only the content is stale.
