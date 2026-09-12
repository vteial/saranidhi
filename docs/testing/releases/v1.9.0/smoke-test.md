[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 39 dossier](../../../process/sprints/sprint-39-why-accordion/README.md)

# Smoke Test — v1.9.0-web (Sprint 39, Integrated Aruḍam "Why?" Accordion)

**Release:** v1.9.0-web (Sprint 39 — verdict-transparency "Why?" accordion)
**Date:** _pending_
**Tester:** Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.9.0` (PR #___)
**Device/Browser:** Chrome — Desktop (1200×900) + Tablet (1024×768) + Mobile (390×844)
**Environment:** the release PR's Vercel **preview** (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Status:** ⏳ _pending — awaiting QA-Verify run on the PR preview_
- **Build / Version to confirm:** Settings → About must read **`Saranidhi v1.9.0 (1)`**.
- **CI Gate:** must be GREEN on the release PR (Analyze / Fast Tests / Build + Full Suite).

> **Scope note (what to focus on):** this is a **transparency-only** release. The verdict
> score, bands, floor-lock, and Prasanam Oracle are **unchanged** — CI + the engine's
> behavior-preserving tests cover that. The highest-value manual verification is the
> **new "Why?" accordion**: collapsed-by-default, expand behavior, the **doctrinal copy +
> CONF citations**, the Moment/You vs Blocked grouping, and **Tamil** rendering. No raw
> arithmetic must ever appear; no tooltips.

---

## Scenario Plan

| # | Scenario | Status | What to verify |
|---|----------|:------:|----------------|
| 1 | **"Why?" collapsed by default** | ⏳ | On Home (Today), the Aruḍam Now card shows a `▸ Why?` row under the guidance box. The reason body + any `CONF-` text is **not** visible until tapped. Tap target feels ≥44×44; chevron animates on expand. |
| 2 | **Expanded — Moment / You grouping (normal verdict)** | ⏳ | Tapping "Why?" reveals **Moment — the timing** (bird state / hora / tarabala / activity harmony lines) and **You — your readiness** (breath line). Each line is plain-language doctrine + a subdued `· CONF-…` citation. **No numbers / no raw math.** |
| 3 | **Aligned vs misaligned readiness copy** | ⏳ | Fresh **aligned** breath → You line reads the "naturally aligned … full height" copy. Fresh **misaligned** → the "dampened — not blocked … the higher path is to wait" copy (North Star honoured; never "shift to win"). |
| 4 | **Stale breath omits the You reason** | ⏳ | With the latest breath log >30 min old (or none), the expanded "Why?" shows Moment reasons only — **no fabricated readiness line** (matches the card's stale degrade). |
| 5 | **Floor-locked → single Blocked reason** | ⏳ | During active Rahu Kaal / Emakandam, the expanded "Why?" shows a single **Blocked** explanation citing `CONF-018`, and does **not** show Moment/You subheads. |
| 6 | **Tamil localization** | ⏳ | In Tamil mode: the label reads `ஏன்?`, headings `நேரம் — பிரபஞ்ச தருணம்` / `நீங்கள் — உங்கள் சுவாசம்` / `தடைபட்ட காலம்`, and all reason prose renders in pure Tamil script (zero English leakage). Citations (`· CONF-…`) remain as-is. |
| — | **Regression eyeball (collapsed card unchanged)** | ⏳ | With "Why?" collapsed, the header + two-clock breakdown + guidance box render exactly as v1.8.x. No layout overflow at 390px or 1024px. |
| — | **Version confirm** | ⏳ | Settings → About = `Saranidhi v1.9.0 (1)`. |

---

## Detailed Scenarios

### Scenario 1: "Why?" collapsed by default
- [ ] Open Home (Today); locate the `🦅 ARUḌAM NOW` card.
- [ ] Confirm a `▸ Why?` affordance sits below the guidance prose box.
- [ ] Confirm no reason text / no `CONF-` citation is visible before tapping.
- [ ] Tap → body expands; chevron rotates; tap again → collapses.
- **Result:** ⏳

### Scenario 2: Expanded Moment / You grouping
- [ ] Expand "Why?" on a normal (non-floor-locked) verdict.
- [ ] Confirm **Moment — the timing** subhead + factor lines (bird / hora / tarabala / harmony).
- [ ] Confirm **You — your readiness** subhead + the readiness line.
- [ ] Confirm each line carries a subdued `· CONF-…` citation and **no raw numbers**.
- **Result:** ⏳

### Scenario 3: Aligned vs misaligned readiness copy
- [ ] Log a fresh **aligned** breath → verify the aligned readiness copy under You.
- [ ] Log a fresh **misaligned** breath → verify the "dampened — not blocked / wait" copy.
- **Result:** ⏳

### Scenario 4: Stale breath omits the You reason
- [ ] With no fresh breath (>30 min), expand "Why?" → verify Moment-only, no readiness line.
- **Result:** ⏳

### Scenario 5: Floor-locked single Blocked reason
- [ ] During active Rahu Kaal / Emakandam, expand "Why?" → verify a single **Blocked** reason + `CONF-018`, no Moment/You subheads.
- **Result:** ⏳

### Scenario 6: Tamil localization
- [ ] Switch to Tamil; expand "Why?" → verify label/headings/prose in pure Tamil script.
- **Result:** ⏳

### Regression eyeball
- [ ] Collapsed card identical to v1.8.x; no overflow at 390px / 1024px; About = v1.9.0.
- **Result:** ⏳

---

## Bugs / Regressions

_None recorded yet — fill during the QA-Verify run. Any issue → fix on `release/v1.9.0`,
re-verify the specific scenario, then proceed._
