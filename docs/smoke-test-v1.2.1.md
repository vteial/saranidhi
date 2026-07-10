[← Back to Root](../README.md)

# Smoke Test — v1.2.1-web

> Release: v1.2.1-web | Date: 2026-07-10 | Tester: Eialarasu

---

## Test Environment

| Item | Value |
|------|-------|
| URL | https://saranidhi.vercel.app |
| Browser | Chrome |
| Device | iMac |
| Profile | Pushya / Chennai |

---

## Sprint 27.5 Specific Tests (Priority)

| # | Scenario | Steps | Expected | Pass? |
|---|----------|-------|----------|-------|
| 1 | Birth bird phase swap | Check Bird Card → compare bird name with current moon phase | Waning: Owl→Rooster swap. Waxing: Owl stays Owl | Yes |
| 2 | Moon phase on Rahu card | Check enhanced Rahu card | Shows waxing/waning emoji + label | Yes |
| 3 | Kuligai Kaal display | Check Rahu card | Shows "Kuligai: HH:MM - HH:MM" (different from Rahu) | Yes |
| 4 | Sunrise/Sunset on Rahu card | Check Rahu card | Shows ☀️ HH:MM / HH:MM | Yes |
| 5 | Align27 row removed | Today's Schedule card | No "Align27: Bird / State" italic row at bottom | Yes |
| 6 | Divider after Night Schedule removed | Today + Explore → Schedule card | No horizontal line after last night yama | Yes |
| 7 | Sushumna: no timer | Journal → tap Sushumna | Meditation card shown, no timer, direct Log button | Yes |
| 8 | Sushumna: no alignment shown | Journal → tap Sushumna | No "Not Aligned" / "Aligned" card | Yes |
| 9 | Nostril button order | Journal screen | Left-to-right: Lunar → Sushumna → Solar | Yes |
| 10 | Timer cancel button | Journal → tap Solar → start inhale | Red "Cancel" button appears below timer | Yes |
| 11 | Tattva format | Bird Card sub-row | Shows "Earth / Prithvi" (English / Sanskrit) | Yes |
| 12 | Best Times translated (Tamil) | Switch to Tamil → Explore → Best Times | Title: "இந்த வார சிறந்த நேரங்கள்", rows: "இன்று" | Yes |
| 13 | Calendar removed from Explore | Explore tab | No inline calendar month grid | Yes |
| 14 | DateSelector: Today button | Explore → DateSelector row | Shows "Today" button (not "Tomorrow") | Yes |
| 15 | User Guide back button | Settings → About → User Guide | Back button matches Settings style (SliverAppBar) | Yes |
| 16 | Monthly Patterns dedup | Analytics → Monthly Patterns | "Needs Attention" hidden if same as "Best Day" | Yes |
| 17 | App version in About | Settings → About card | Shows "v1.2.1(1)" instead of 'v1.2.1' | No | 
| 18 | Export has version fields | Settings → Export → open JSON | Contains "appVersion": "1.2.1", "schemaVersion": 3 | Yes |
| 19 | DB migration (no crash) | Load app with existing data | App loads, pinned entries persist | Yes |

---

## Critical Path (Regression)

| # | Scenario | Steps | Expected | Pass? |
|---|----------|-------|----------|-------|
| 20 | App loads | Open URL | Dashboard loads without error | Yes |
| 21 | Bird Card displays | Today tab | Birth bird + state + guidance text visible | Yes |
| 22 | Rahu Kaal timing | Today tab | Rahu time window shows reasonable IST time | Yes |
| 23 | Full day schedule | Today tab | 10 yamas (5 day + 5 night) with states | Yes |
| 24 | Log Solar entry | Journal → Solar → timer → complete → log | Entry saved, appears in history | Yes |
| 25 | Log Lunar entry | Journal → Lunar → timer → complete → log | Entry saved, aligned/not-aligned shown | Yes |
| 26 | Streak updates | After logging entry | Streak count reflects new entry | Yes |
| 27 | Theme switch | Settings → Dark mode | UI switches without crash | Yes |
| 28 | Language switch (Tamil) | Settings → Tamil | All visible text switches to Tamil | Yes |
| 29 | Date navigation | Explore → tap ← / → arrows | Schedule updates for selected date | Yes |
| 30 | Export/Import | Settings → Export → download file | Valid JSON file downloads | Yes |

---

## Results Summary

| Total | Passed | Failed | Blocked |
|-------|--------|--------|---------|
| 30 | 29 | 1 | 0 |

### Failures (if any)

| # | Issue | Severity | Action |
|---|-------|----------|--------|
| | | | |

---

### Sign-off

- [ ] All critical path scenarios pass
- [ ] All Sprint 27.5 specific tests pass
- [ ] Ready for production release

Tester: ___________ | Date: ___________

---

[← Back to Root](../README.md)
