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
| 1 | Best Times card — Y# first column | Explore → Best Times | Row order: Y#, time icon, time range, date label | Yes |
| 2 | Best Times — "Today" badge | Explore → Best Times | Today's row shows "Today" chip on right (not replacing date) | Yes |
| 3 | Best Times — date format | Explore → Best Times | Shows "Jul 12, Sat" format (MMM d, EEE) | Yes |
| 4 | Journal history — today expanded | Journal tab | Today's entries visible by default | Yes |
| 5 | Journal history — older collapsed | Journal tab (with multiple days of data) | Older dates show count + chevron, tap to expand | Yes |
| 6 | DOB result — Tamil nakshatra | Onboarding (Tamil) → Calculate from DOB | Shows "புஷ்யம் (Pushya)" not just "Pushya" | Yes |
| 7 | DOB result — Tamil bird | Onboarding (Tamil) → after calculation | Shows "ஆந்தை" not "Owl" | Yes |
| 8 | Rahu card — Emakandam | Today tab → Rahu card | Row 2 shows "Kuligai: HH:MM • Emakandam: HH:MM" | Yes |
| 9 | Rahu card — 4 rows | Today tab → Rahu card | Row1=Rahu, Row2=Kuligai+Emakandam, Row3=Sun+Moon, Row4=Tithi+Hora | Yes |
| 10 | Rahu card — Tithi | Today tab → Rahu card Row 4 | Shows "Shukla N" or "Krishna N" (1-15) | Yes |
| 11 | Rahu card — Hora | Today tab → Rahu card Row 4 | Shows planet emoji + name (e.g., "☿ Mercury") | Yes |
| 12 | Day Schedule title | Today tab → Schedule card | Shows "☀️ Day Schedule" (not "Today's Schedule") | Yes |
| 13 | Night Schedule unchanged | Today tab → Schedule card | Still shows "🌙 Night Schedule" | Yes |
| 14 | Analytics Y1 label | Analytics → Yama Performance | Shows "Y1", "Y2", etc. (not "Yama 1") | Yes |
| 15 | Explore card height | Explore tab (wide screen) | Rahu card height matches Bird card in two-column layout | Yes |
| 16 | Settings About — narrow | Settings (iPad/phone width) | About card appears at bottom after Clear All Data | Yes |
| 17 | Settings About — wide | Settings (iMac width) | About card in left column (unchanged) | Yes |

---

## Critical Path (Regression)

| # | Scenario | Steps | Expected | Pass? |
|---|----------|-------|----------|-------|
| 18 | App loads | Open URL | Dashboard loads without error | Yes |
| 19 | Bird Card displays | Today tab | Birth bird + state + guidance visible | Yes |
| 20 | Log entry | Journal → Solar → timer → log | Entry saved, history updates | Yes |
| 21 | Theme switch | Settings → Dark mode | UI switches cleanly | Yes |
| 22 | Language switch | Settings → Tamil | All text switches | Yes |
| 23 | Export data | Settings → Export | JSON file downloads | Yes |

---

## Results Summary

| Total | Passed | Failed | Blocked |
|-------|--------|--------|---------|
| 23 | 23 | 0 | 0 |

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
