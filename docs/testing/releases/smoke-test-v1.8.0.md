[← Back to Smoke Test Index](../smoke-test-results.md) · [Sprint 38 dossier](../../process/sprints/sprint-38-integrated-arudam/README.md)

# Smoke Test — v1.8.0-web (Sprint 38, Integrated Aruḍam Slice 1)

**Release:** v1.8.0-web (Sprint 38 — Integrated Aruḍam Slice 1)  
**Date:** 2026-09-12  
**Tester:** Antigravity (QA-Verify Agent)  
**Shipping Commit:** `a166a66` on `release/v1.8.0` (PR #184)  
**Device/Browser:** Chrome / Desktop & Tablet Viewports (1200x900, 1024x768) + Mobile Viewport (390x844)  
**Environment:** PR #184 Vercel Preview (`https://saranidhi-git-release-v180-eialarasus-projects.vercel.app`) using `VERCEL_AUTOMATION_BYPASS_SECRET`  

## Result

- **Status:** ✅ PASS — Fully verified on deployed PR #184 Vercel Preview build.
- **Date:** 2026-09-12 · **Devices / Viewports:** Desktop/Tablet (1200x900, 1024x768) and Mobile Viewport (390x844).
- **Environment Tested:** PR #184 Vercel Preview (`https://saranidhi-git-release-v180-eialarasus-projects.vercel.app/?x-vercel-protection-bypass=...&x-vercel-set-bypass-cookie=true`).
- **Build / Version Confirmed:** Settings → About card explicitly confirms `Saranidhi v1.8.0 (1) The Treasure House of Breath` at commit `a166a66`.
- **CI Gate:** GREEN on PR #184 (`Analyze, Fast Tests & Build`: SUCCESS, `Full Test Suite + Coverage`: SUCCESS, `Integration Tests (Web)`: SUCCESS).
- **Bugs / Regressions:** None found. Zero layout overflows, zero doctrinal violations, zero script leakage.

---

## Scenario Verification Summary

| # | Scenario | Status | Key Observations & Evidence |
|---|----------|:------:|-----------------------------|
| 1 | Ambient Card on Home (Day / Night) | ✅ PASS | `🦅 ARUḌAM NOW` verdict card renders prominently at top of Home (Today). Composite score, band label (`Strong Yes (100)` / `Hard No (10)`), and Two-Clock breakdown (`Moment: Eating · Mars hora (strong)`, `You: naturally aligned ✓`) match real-time astronomical and breath states. |
| 2 | Fresh Aligned Breath | ✅ PASS | Logging active expected breath flow (Right / Solar in Yama 4 on Shukla 1) updates card immediately: green checkmark `naturally aligned ✓`, affirmative prose *"Breath moves in rhythm with the cosmic current. Proceed with ease."*, and the "Urgent worldly need?" button is cleanly absent. |
| 3 | Fresh Misaligned Breath & Urgent Contralateral Shift | ✅ PASS | Logging opposing breath flow (Left / Lunar in Yama 4) updates card to: warning icon `not naturally aligned ⚠`, cultivation prose *"Wait, accept, or note. Natural alignment is a lifelong cultivation of patience."*, and low-emphasis link `Urgent worldly need?`. Tapping opens modal bottom sheet *"Contralateral Shift Guidance"* with warning callout, technique instructions, and `Re-check Breath` button. Completing recheck logs entry with `wasForcedShift = true` and shows floating SnackBar *"Shift logged. Observe how naturally the rhythm returns."*. |
| 4 | Stale Breath (>30 Min) Degradation | ✅ PASS | Fresh session with no prior breath log cleanly degrades to cosmic timing ceiling: You clock displays `breath observation needed`, stale prose *"Showing current timing ceiling. Check your breath to evaluate personal readiness."*, and actionable link `Check your breath →` which triggers the guided nostril test. No fabricated breath alignment state. |
| 5 | Inauspicious Floor-Lock (Rahu Kaal / Emakandam) | ✅ PASS | Tested during active Emakandam window (13:41–15:13 on Saturday): card border shifts to red warning tint, verdict band displays `Hard No (10)`, and score is suppressed to 10 regardless of bird state or breath flow. Once Emakandam window concluded (>15:13:30), floor-lock lifted immediately to `Strong Yes (100)`. |
| 6 | Tamil Localization | ✅ PASS | Full Tamil fidelity verified: card title `🦅 அருடம் இப்போது`, clocks `நேரம்:`, `நீங்கள்:`, alignment statuses `இயற்கையாக இணைந்தீர் ✓` / `இயற்கையாக ஒத்துப்போகவில்லை ⚠` / `மூச்சை கவனிக்கவும்`, verdict bands `சிறப்பான ஆம் (100)` / `கடுமையான இல்லை (10)`, and all guidance prose in poetic, pure Tamil with zero English leakage. |
| — | Visual Rendering (Narrow 390px & Wide 1024px) | ✅ PASS | Rendered cleanly on both 390x844 mobile viewport and 1024x768 / 1200x900 desktop viewports. No yellow/black overflow stripes, no clipped text, flawless layout hierarchy. |

---

## Detailed Scenarios

### Scenario 1: Ambient Card on Home (Day / Night)
- [x] Open Home tab (Today view).
- [x] Verify `🦅 ARUḌAM NOW` verdict card is prominently displayed at the top of the dashboard.
- [x] Confirm band color, band label (e.g. *Favorable*, *Caution*, *Strong Yes*), and composite score `(0–100)` match the current cosmic state.
- [x] Confirm Two-Clock breakdown displays:
  - **Moment:** `{birdState} · {horaPlanet} hora ({strength})` (Observed: `Eating · Mars hora (strong)` and `Eating · Jupiter hora (weak)`).
  - **You:** Displays real-time breath status (`breath observation needed`, `not naturally aligned ⚠`, `naturally aligned ✓`).
- **Result:** ✅ PASS  
- **Evidence:** Verified on both desktop and mobile viewports (`home_misaligned_state_1789205997908.png`, `after_use_this_flow_1789206095493.png`, `arudam_now_english_desktop_1789206391454.png`). Card is at top of screen above Action Windows.

### Scenario 2: Fresh Aligned Breath
- [x] Log a fresh breath observation matching the active expected flow (Solar in Yama 4 on Shukla 1).
- [x] Observe card updates immediately:
  - You clock shows green checkmark: `naturally aligned ✓`.
  - Affirmative guidance prose: *"Breath moves in rhythm with the cosmic current. Proceed with ease."*
  - No "Urgent worldly need?" button is visible.
- **Result:** ✅ PASS  
- **Evidence:** Captured in `after_use_this_flow_1789206095493.png`, `arudam_now_english_desktop_1789206391454.png`, and `arudam_now_english_mobile_1789206400366.png`. Verified immediate reactive update without page reload upon completing the guided test.

### Scenario 3: Fresh Misaligned Breath & Urgent Contralateral Shift
- [x] Log a fresh breath observation opposing the active expected flow (Lunar in Yama 4 on Shukla 1).
- [x] Observe card updates immediately:
  - You clock shows warning icon: `not naturally aligned ⚠`.
  - Cultivation guidance: *"Wait, accept, or note. Natural alignment is a lifelong cultivation of patience."*
  - Low-emphasis link appears: `Urgent worldly need?`.
- [x] Tap `Urgent worldly need?`:
  - Modal bottom sheet opens with title: *"Contralateral Shift Guidance"*.
  - Warning container is shown: *"Forced breath shifting is an emergency measure for unavoidable action, not a daily habit. Actively altering your nostril dominance taxes vital reserves. A shift nudges the channel for approximately 10–60 minutes and can revert naturally at any time. It may improve your odds, but never guarantees success."*
  - Technique steps: *"Rest or Pressure Technique: Lie on the side of the currently active nostril, or apply gentle pressure to the opposite armpit using a cushion or your arm for 3–5 minutes."*
  - Tap `Re-check Breath`:
    - Guided nostril test runs.
    - Recording logs the breath entry with `wasForcedShift = true`.
    - Floating SnackBar notice confirms: *"Shift logged. Observe how naturally the rhythm returns."*
- **Result:** ✅ PASS  
- **Evidence:** Captured in `home_misaligned_state_1789205997908.png`, `contralateral_shift_modal_1789206013483.png`, and `guided_nostril_test_step1_1789206023839.png`. Doctrinal North Star verified: copy emphasizes patience and never guarantees success.

### Scenario 4: Stale Breath (>30 Minutes) Degradation
- [x] When no breath entry exists within the past 30 minutes (or on a fresh install):
  - Card degrades to cosmic ceiling: You clock shows `breath observation needed`.
  - Stale guidance: *"Showing current timing ceiling. Check your breath to evaluate personal readiness."*
  - Action link appears: `Check your breath →`.
  - Tapping opens the guided nostril test to record a fresh observation.
- **Result:** ✅ PASS  
- **Evidence:** Verified on initial load before logging breath (`click_feedback_1789205868046.png`). Tapping `Check your breath →` launched the guided nostril test dialog cleanly.

### Scenario 5: Inauspicious Floor-Lock (Rahu Kaal / Emakandam)
- [x] During an active Rahu Kaal or Emakandam window (day or night):
  - Card border shifts to error warning tint (red outline).
  - Verdict band displays `Hard No (10)`.
  - Score is suppressed to 10 regardless of bird state or breath flow.
- **Result:** ✅ PASS  
- **Evidence:** Observed live during active Saturday Emakandam (13:41–15:13): card rendered with red border tint, red header `Hard No (10)`, and score locked at 10 (`click_feedback_1789205868046.png`, `home_misaligned_state_1789205997908.png`). Once the clock crossed 15:13:30, the floor-lock released, and the card updated to `Strong Yes (100)` with green border tint (`arudam_now_after_emakandam_1789206321066.png`).

### Scenario 6: Tamil Localization
- [x] Switch language to Tamil (தமிழ்).
- [x] Verify card title: `🦅 அருடம் இப்போது`.
- [x] Verify clocks: `நேரம்:`, `நீங்கள்:`.
- [x] Verify alignment statuses: `இயற்கையாக இணைந்தீர் ✓` / `இயற்கையாக ஒத்துப்போகவில்லை ⚠` / `மூச்சை கவனிக்கவும்`.
- [x] Verify all guidance prose and sheet copy render in poetic, accurate Tamil.
- **Result:** ✅ PASS  
- **Evidence:** Captured in `home_tamil_localization_1789206201589.png` and `arudam_now_after_emakandam_1789206321066.png`. Verified `நேரம்: உண்ணுதல் · செவ்வாய் ஹோரை (வலுவானது)`, `நீங்கள்: இயற்கையாக இணைந்தீர் ✓`, and `சுவாசம் இயற்கையோடு இசைந்து செல்கிறது. செயலில் அமைதியுடன் தொடருங்கள்.` with zero script or layout anomalies.

---

## Responsive Viewport Verification (Risk Focus)

- **Mobile Viewport (390 x 844):** Verified in `arudam_now_mobile_viewport_1789206169057.png` and `arudam_now_english_mobile_1789206400366.png`. The card wraps neatly within screen boundaries; all text lines, icons, and action links remain readable without horizontal scrolling or clipping.
- **Desktop / Tablet Viewport (1024 x 768 / 1200 x 900):** Verified in `arudam_now_english_desktop_1789206391454.png` and `home_misaligned_state_1789205997908.png`. Margins, dividers, two-clock alignment, and background tint display with clean aesthetic hierarchy.

---

## About & Version Check
- Settings view inspected (`settings_about_view_1789205987144.png`).
- Version confirmed: `Saranidhi v1.8.0 (1) The Treasure House of Breath`.
- Commit under test: `a166a66` on `release/v1.8.0`.

