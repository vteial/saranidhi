[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 42 dossier](../../../process/sprints/sprint-42-swara-clock/README.md)

# Smoke Test — v1.11.0-web (Sprint 42, Swara Clock Engine & Weekday Udhaya)

**Release:** v1.11.0-web (Sprint 42 — ★ Swara Clock Engine & Weekday Udhaya)
**Date:** _pending_
**Tester:** Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.11.0` (PR #_pending_)
**Device/Browser:** Chrome — Desktop (1200×900) + Tablet (1024×768) + Mobile (390×844)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1110-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Status:** ⏳ _pending_
- **Date:** _pending_ · **Devices / Viewports:** _pending_
- **Environment Tested:** PR Vercel Preview (`https://saranidhi-git-release-v1110-eialarasus-projects.vercel.app/?x-vercel-protection-bypass=…&x-vercel-set-bypass-cookie=true`)
- **Build / Version Confirmed:** Settings → About should read **`Saranidhi v1.11.0 (1)`** _(confirm)_
- **CI Gate:** _(confirm 100% GREEN on the release PR — Analyze/Fast+Build, Full Suite+Coverage; Integration Tests (Web) is the known-flaky non-blocking job)_
- **Local Gate:** 0 analyze issues; 628 passing unit/widget tests (4 known CloudKit baseline).
- **Bugs / Regressions:** _pending_

> **Scope note (what to focus on).** This is a **correctness engine** release, not a new
> visible feature. The swara-clock **math** (weekday seeds, 1h/2h inception, hourly progression,
> pre-dawn cross-midnight anchoring) is covered by 12 `SwaraClock` unit tests + regression tests
> and CI. The manual gate should target what CI can't catch: the **Nostril Pattern card's visual
> rendering** on the new 1-hour clock (hourly blocks + `← NOW` chip + ~1h countdown, **not** the
> old yama rows / yama-boundary countdown), the **live night cycle** (no longer a dead "no
> pattern at night" note), **weekday-seed correctness** cross-checked against the expected dawn
> nostril at a known sunrise (the "Sunday morning" check), **Tamil** rendering of any changed
> copy, and the **regression eyeball** (bird-state schedule, Rahu/Kuligai/Emakandam, Aruḍam Now
> verdict, Oracle, breath journal all unchanged). Where a specific time-of-day can't be produced
> live, verify against the unit-test evidence + a date/time-seeded state and mark the scenario
> accordingly (honest-but-partial).

---

## Scenario Plan

| # | Scenario | Status | What to verify |
|---|----------|:------:|----------------|
| 1 | **Nostril Pattern card — hourly blocks (new clock)** | ⏳ | The card renders **hourly swara blocks** (current + upcoming), each ~1h, with the current block carrying the `← NOW` chip. NOT the old 5 yama rows. Solar (☀️/Right) vs Lunar (🌙/Left) labels correct. |
| 2 | **Next-switch countdown ≈ ~1h** | ⏳ | The "next switch in N min" is derived from the **~1h swara block end** (`≤ 60 min`), not the 1.5h yama boundary. Counts down toward the next hourly switch. |
| 3 | **Weekday dawn seed correctness (the "Sunday morning" check)** | ⏳ | At/near a **known weekday sunrise**, the expected dawn nostril matches the CONF-013 Udhaya seed (e.g. **Sunday → Right/Solar**, Monday → Left/Lunar, Tuesday → Right held 2h). Cross-check against a manually-checked nostril / the seed table. Verify via date-seeded state + unit-test evidence where a live sunrise isn't reachable. |
| 4 | **Thursday paksha split** | ⏳ | Thursday **Shukla (waxing) → Left/1h**, **Krishna (waning) → Right/2h**. Verify via seeded date (a waxing Thursday vs a waning Thursday) or unit-test evidence. |
| 5 | **Live night cycle (no dead zone)** | ⏳ | After sunset / at night the card shows a **live** expected block (Solar/Lunar continuing the 24h cycle) + the gentle inward-rest note — **not** the old "no expected nostril pattern at night" dead-zone message. |
| 6 | **Aruḍam Now readiness reflects the new clock** | ⏳ | The Aruḍam Now verdict's readiness (aligned ×1.0 / misaligned ×0.75) reflects the corrected expected nostril. When breath matches the swara-clock expectation → aligned; when it doesn't → misaligned. Sushumna handling unchanged. |
| 7 | **Tamil localization** | ⏳ | In தமிழ் mode: Nostril Pattern card labels, the night rest note, and any changed guidance render in **pure Tamil script** (zero English leakage). ARB parity intact. |
| — | **Regression eyeball — Pakshi/yama/Oracle UNCHANGED** | ⏳ | Bird-state day/night schedule, Rahu Kaal / Kuligai / Emakandam, the Aruḍam Now **Moment** score, Prasanam Oracle, and the breath journal render/behave exactly as v1.10.x. No overflow at 390px / 1024px. |
| — | **Version confirm** | ⏳ | Settings → About = `Saranidhi v1.11.0 (1)`. |

---

## Detailed Scenarios

### Scenario 1: Nostril Pattern card — hourly blocks (new clock)
- [ ] On Home (Today), confirm the Nostril Pattern card renders hourly swara blocks (current + upcoming), current block flagged `← NOW`.
- **Result:** ⏳
- **Evidence:**

### Scenario 2: Next-switch countdown ≈ ~1h
- [ ] Confirm the countdown reflects the ~1h swara block end (≤60 min), not the yama boundary.
- **Result:** ⏳
- **Evidence:**

### Scenario 3: Weekday dawn seed correctness ("Sunday morning" check)
- [ ] At/near a known weekday sunrise, confirm expected dawn nostril matches the CONF-013 Udhaya seed.
- **Result:** ⏳
- **Evidence:**

### Scenario 4: Thursday paksha split
- [ ] Confirm Thursday Shukla → Left/1h and Krishna → Right/2h (seeded dates or unit-test evidence).
- **Result:** ⏳
- **Evidence:**

### Scenario 5: Live night cycle (no dead zone)
- [ ] At night, confirm a live expected block + inward-rest note (not the old dead-zone message).
- **Result:** ⏳
- **Evidence:**

### Scenario 6: Aruḍam Now readiness reflects the new clock
- [ ] Confirm readiness (×1.0 aligned / ×0.75 misaligned) tracks the corrected expected nostril; Sushumna unchanged.
- **Result:** ⏳
- **Evidence:**

### Scenario 7: Tamil localization
- [ ] Switch to தமிழ் → confirm all changed nostril-pattern copy in pure Tamil script.
- **Result:** ⏳
- **Evidence:**

### Regression eyeball
- [ ] Bird-state schedule, Rahu/Kuligai/Emakandam, Aruḍam Now Moment score, Oracle, journal unchanged vs v1.10.x; no overflow at 390px / 1024px; About = v1.11.0.
- **Result:** ⏳
- **Evidence:**

---

## Bugs / Regressions

_Pending execution._
