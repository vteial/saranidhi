[← Back to Root](../README.md)

# Saranidhi — Third-Party Comparison & Sources

> Internal reference documenting bird state mapping differences between
> Saranidhi, Align27, and traditional Tamil Panchapakshi texts.

---

## Bird State Mapping Sources

### Primary Source: Prof. Dr. U.S. Pulippani
- **Book:** "Biorhythms of Natal Moon — Mysteries of Pancha Pakshi"
- **System:** 2D lookup tables (weekday × lunar phase → 5×5 state matrix)
- **Used in:** Saranidhi's `PakshiCalculator` (authentic tables, Sprint 12+)

### Secondary Reference: Suzhimunai WordPress
- **URL:** https://suzhimunai.wordpress.com/category/பஞ்ச-பட்சி-சாஸ்திரம்/
- **Key finding:** Birth bird swaps with lunar phase (waxing ↔ waning)
- **Swap mapping:**
  - Waxing Vulture = Waning Peacock
  - Waxing Owl = Waning Rooster
  - Crow stays Crow (center of the mirror)
  - Waxing Rooster = Waning Owl
  - Waxing Peacock = Waning Vulture
- **Pattern:** Mirror positions 1↔5, 2↔4, 3 stays
- **Implemented in:** Sprint 27.5 (Task 27.5.3)

### Align27 (Cosmic Insights Pvt. Ltd.)
- **Platform:** iOS/Android/Web app
- **Algorithm:** Proprietary (likely same Pulippani tables)
- **Key differences from Saranidhi:**
  - Uses a single "ruling bird" display per yama (no full 5×5 table shown)
  - Does NOT appear to swap birth bird with lunar phase
  - Uses approximate sunrise/sunset (possibly fixed to standard times)
  - Displays in English only (no Tamil support)

---

## Comparison Matrix (Bird States per Yama)

| Feature | Saranidhi | Align27 | Traditional Text |
|---------|-----------|---------|-----------------|
| Day groups (bright) | A(Sun/Tue), B(Mon/Wed/Sat), C(Thu), D(Fri) | Unknown | Same as Saranidhi |
| Day groups (dark) | A(Sun/Tue), B(Mon/Sat), C(Wed), D(Thu), E(Fri) | Unknown | Same |
| Night tables | Full 5×5 (10 tables) | Partial | Full |
| Birth bird phase swap | Yes (Sprint 27.5) | No (always waxing bird) | Yes |
| Sunrise algorithm | NOAA solar position | Unknown | Manual panchangam |
| Moon longitude | Jean Meeus ELP 2000/82 | Unknown | Manual panchangam |
| Ayanamsa | Lahiri | Unknown | Lahiri (most common) |

---

## Validation Strategy

1. **Pulippani tables:** Our state tables were manually transcribed and verified
   against the book's matrices during Sprint 12.
2. **Lunar phase swap:** Confirmed via multiple Tamil Panchapakshi sources
   (suzhimunai.wordpress.com, classic Sara Kalai workshop knowledge).
3. **Cross-reference with Align27:** Used during Sprints 14–19 for the ruling
   bird comparison row (now removed in Sprint 27.5 as we've validated accuracy).

---

## Removed: Align27 Comparison Row

The Align27 comparison row (`_Align27Row` / `_NightAlign27Row` in
`full_day_schedule.dart`) was used from Sprint 14 through Sprint 27 as a
visual cross-reference during the 6-month validation period. It showed
"Align27: [Bird] / [State]" for the current yama.

**Removed in Sprint 27.5** (Task 27.5.6) because:
1. Validation period complete — our tables match traditional sources.
2. Showing a competitor's name in the UI is inappropriate for production.
3. The phase-aware birth bird (Task 27.5.3) makes our calculation more
   accurate than Align27's static approach.

---

[← Back to Root](../README.md)
