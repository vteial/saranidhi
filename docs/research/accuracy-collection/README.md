# Accuracy & Validation — 7-Day Data Collection

> **Owner task.** This folder is the **recording mechanism** for the three-way comparison matrix
> (Saranidhi vs Align27 vs Tamil Panchangam) that the **Accuracy & Validation** epic depends on
> (`BACKLOG.md` → "Accuracy & Validation").
> Fill one `day-NN_*.md` sheet per day; the Saranidhi column comes from the `diagnostic-dump` tool
> (spec `diagnostic-dump`, PR #296) once it ships.
> **Last verified:** v1.13.0-web (template authored 2026-10-23).

## HARD PRE-REQUISITE — read before collecting

- **The Swara-Clock Engine fix (Sprint 42) MUST be live (v1.11.0+) before Day 1.** If collection
  starts on the old yama-clock model, every breath/state observation calibrates the *broken* engine —
  invalid data (the dependency paradox noted in the epic). Confirm production is **≥ v1.11.0** first.

## Pinned constants — set these ONCE, keep them identical across all three sources

| Constant | Value (fill in) | Why it must not vary |
|---|---|---|
| **Bird** | `owl` | Your corrected bird per CONF-PP-001/002. Same bird in Saranidhi, Align27 and Panchangam. |
| **Location** | `<city>` lat `__._____` lng `__._____` | Align27 **and** drikpanchang must be set to this exact place — a different city shifts sunrise and every yama boundary. |
| **Start date** | `____-__-__` | The morning after v1.11.0 is confirmed live. 7 **consecutive** days, no skips. |
| **Day boundary** | sunrise → sunrise (CONF-001) | Record Panchangam/Align27 on the **sunrise-anchored civil day**, not midnight→midnight — otherwise weekday/phase can read off by a boundary. |
| **Time format** | 24-hour local, to the minute | So a plain text diff against the dump works. |
| **Spelling** | lowercase (`owl`, `eating`, `waxing`) | Match exactly what the dump emits, so comparison is mechanical. |

## The mechanism (keep it boring — ~5 min/day)

1. **Once each morning, right after sunrise**, open **Align27** and **drikpanchang.com** (or a physical
   Tamil calendar). Both give the **whole day ahead**, so you read the full 10-yama schedule in one sitting —
   you do NOT watch it yama-by-yama live.
2. Fill that day's sheet completely: the per-day header (sunrise/sunset/phase/nakshatra from Panchangam)
   and all **10 yama rows** (per-yama times + ruling bird + Owl's state from Align27).
3. **Note anomalies in the `remarks` column — do not "fix" them.** A Thursday paksha split (CONF-013),
   a day the two sources already disagree, a yama that straddles midnight: those remarks are the
   root-cause diagnosis input, so leave them raw.
4. **Who gives what:** Panchangam = the astronomical envelope (sunrise/sunset, lunar phase, nakshatra);
   Align27 = the Pancha Pakshi states (per-yama ruling bird + Owl's state). Saranidhi = the dump.

## Column responsibilities

| Column | Filled from | When |
|---|---|---|
| **Panchangam** envelope (sunrise/sunset, phase, nakshatra) | drikpanchang / calendar | each morning |
| **Align27** per-yama ruling bird + Owl state | Align27 app | each morning |
| **Saranidhi** per-yama output | `diagnostic-dump --bird owl ... --format md` | after the tool ships (one run for all 7 days) |

## After the 7 days

Run the dump once for the same bird / location / 7 days, then the next epic tasks are mechanical:
**three-way comparison matrix → root-cause diagnosis → calibration fix → re-run → document in
`docs/research/accuracy-calibration.md`.**
