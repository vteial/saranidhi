[← Back to Smoke Test Index](../smoke-test-results.md) · [Sprint 38 dossier](../../process/sprints/sprint-38-integrated-arudam/README.md)

# Smoke Test — v1.8.0-web (Sprint 38, Integrated Aruḍam Slice 1)

> Manual smoke test script for the flagship Integrated Aruḍam verdict card
> on physical devices (macOS, iPad, iOS, Web). Executed on staging
> (`saranidhi-staging.vercel.app`) during `/release-start`; results recorded inline.

## Result

- **Status:** ⬜ PENDING — owner executes on staging.
- **Date:** ____ · **Devices:** ____

## Scenarios

### Scenario 1: Ambient Card on Home (Day / Night)
- [ ] Open Home tab (Today view).
- [ ] Verify `🦅 ARUḌAM NOW` verdict card is prominently displayed at the top of the dashboard.
- [ ] Confirm band color, band label (e.g. *Favorable*, *Caution*, *Strong Yes*), and composite score `(0–100)` match the current cosmic state.
- [ ] Confirm Two-Clock breakdown displays:
  - **Moment:** `{birdState} · {horaPlanet} hora ({strength})`
  - **You:** Displays real-time breath status.

### Scenario 2: Fresh Aligned Breath
- [ ] Log a fresh breath observation matching the active expected flow (e.g. Solar in an odd Yama).
- [ ] Observe card updates immediately:
  - You clock shows green checkmark: `naturally aligned ✓`.
  - Affirmative guidance prose: *"Breath moves in rhythm with the cosmic current. Proceed with ease."*
  - No "Urgent worldly need?" button is visible.

### Scenario 3: Fresh Misaligned Breath & Urgent Contralateral Shift
- [ ] Log a fresh breath observation opposing the active expected flow (e.g. Lunar in an odd Yama).
- [ ] Observe card updates immediately:
  - You clock shows warning icon: `not naturally aligned ⚠`.
  - Cultivation guidance: *"Wait, accept, or note. Natural alignment is a lifelong cultivation of patience."*
  - Low-emphasis link appears: `Urgent worldly need?`
- [ ] Tap `Urgent worldly need?`:
  - Modal bottom sheet opens with title: *"Contralateral Shift Guidance"*.
  - Warning container is shown: *"Forced breath shifting is an emergency measure for unavoidable action..."*
  - Technique steps: posture shift / axillary pressure instructions.
  - Tap `Re-check Breath`:
    - Guided nostril test runs.
    - Recording logs the breath entry with `wasForcedShift = true`.
    - Floating SnackBar notice confirms: *"Shift logged. Observe how naturally the rhythm returns."*

### Scenario 4: Stale Breath (>30 Minutes) Degradation
- [ ] When no breath entry exists within the past 30 minutes (or on a fresh install):
  - Card degrades to cosmic ceiling: You clock shows `breath observation needed`.
  - Stale guidance: *"Showing current timing ceiling. Check your breath to evaluate personal readiness."*
  - Action link appears: `Check your breath →`.
  - Tapping opens the guided nostril test to record a fresh observation.

### Scenario 5: Inauspicious Floor-Lock (Rahu Kaal / Emakandam)
- [ ] During an active Rahu Kaal or Emakandam window (day or night):
  - Card border shifts to error warning tint.
  - Verdict band displays `Hard No (10)`.
  - Score is suppressed to 10 regardless of bird state or breath flow.

### Scenario 6: Tamil Localization
- [ ] Switch language to Tamil (தமிழ்).
- [ ] Verify card title: `🦅 அருடம் இப்போது`.
- [ ] Verify clocks: `தருணம்:`, `நீங்கள்:`.
- [ ] Verify alignment statuses: `இயற்கையாக ஒத்துப்போகிறது ✓`, `இயற்கையாக ஒத்துப்போகவில்லை ⚠`, `மூச்சை கவனிக்கவும்`.
- [ ] Verify all guidance prose and sheet copy render in poetic, accurate Tamil.
