[← Back to Root](../README.md)

# Smoke Test Plan — v1.2.2-web

> Release: v1.2.2-web | Date: __________ | Tester: __________

---

## Test Environment

| Item | Value |
|------|-------|
| URL | https://saranidhi.vercel.app |
| Browser | |
| Device | |
| Profile | Pushya / Chennai |

---

## Sprint 28 Specific Tests

| # | Scenario | Steps | Expected | Pass? |
|---|----------|-------|----------|-------|
| 1 | Best Times card — Y# first column | Explore → Best Times | Row order: Y#, time icon, time range, date label | |
| 2 | Best Times — "Today" badge | Explore → Best Times | Today's row shows "Today" chip on right (not replacing date) | |
| 3 | Best Times — date format | Explore → Best Times | Shows "Jul 12, Sat" format (MMM d, EEE) | |
| 4 | Journal history — today expanded | Journal tab | Today's entries visible by default | |
| 5 | Journal history — older collapsed | Journal tab (with multiple days of data) | Older dates show count + chevron, tap to expand | |
| 6 | DOB result — Tamil nakshatra | Onboarding (Tamil) → Calculate from DOB | Shows "புஷ்யம் (Pushya)" not just "Pushya" | |
| 7 | DOB result — Tamil bird | Onboarding (Tamil) → after calculation | Shows "ஆந்தை" not "Owl" | |
| 8 | Rahu card — Emakandam | Today tab → Rahu card | Row 2 shows "Kuligai: HH:MM • Emakandam: HH:MM" | |
| 9 | Rahu card — 4 rows | Today tab → Rahu card | Row1=Rahu, Row2=Kuligai+Emakandam, Row3=Sun+Moon, Row4=Tithi+Hora | |
| 10 | Rahu card — Tithi | Today tab → Rahu card Row 4 | Shows "Shukla N" or "Krishna N" (1-15) | |
| 11 | Rahu card — Hora | Today tab → Rahu card Row 4 | Shows planet emoji + name (e.g., "☿ Mercury") | |
| 12 | Day Schedule title | Today tab → Schedule card | Shows "☀️ Day Schedule" (not "Today's Schedule") | |
| 13 | Night Schedule unchanged | Today tab → Schedule card | Still shows "🌙 Night Schedule" | |
| 14 | Analytics Y1 label | Analytics → Yama Performance | Shows "Y1", "Y2", etc. (not "Yama 1") | |
| 15 | Explore card height | Explore tab (wide screen) | Rahu card height matches Bird card in two-column layout | |
| 16 | Settings About — narrow | Settings (iPad/phone width) | About card appears at bottom after Clear All Data | |
| 17 | Settings About — wide | Settings (iMac width) | About card in left column (unchanged) | |

---

## Critical Path (Regression)

| # | Scenario | Steps | Expected | Pass? |
|---|----------|-------|----------|-------|
| 18 | App loads | Open URL | Dashboard loads without error | |
| 19 | Bird Card displays | Today tab | Birth bird + state + guidance visible | |
| 20 | Log entry | Journal → Solar → timer → log | Entry saved, history updates | |
| 21 | Theme switch | Settings → Dark mode | UI switches cleanly | |
| 22 | Language switch | Settings → Tamil | All text switches | |
| 23 | Export data | Settings → Export | JSON file downloads | |

---

## Results Summary

| Total | Passed | Failed | Blocked |
|-------|--------|--------|---------|
| 23 | | | |

### Failures (if any)

| # | Issue | Severity | Action |
|---|-------|----------|--------|
| | | | |

---

### Sign-off

- [ ] All Sprint 28 specific tests pass
- [ ] All critical path scenarios pass
- [ ] Ready for production release

Tester: __________ | Date: __________

---

[← Back to Root](../README.md)
