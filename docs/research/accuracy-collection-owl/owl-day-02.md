# Owl Day 02 — 2026-10-25 (Weekday: Sun)

> One sheet per collection day for the **Owl** basis. Method per
> `docs/research/accuracy-collection-owl/README.md`.
> - **Envelope:** if a Cock sheet exists for THIS date (`docs/research/accuracy-collection/day-NN.md`,
>   dates 2026-10-23..29), copy sunrise/sunset/phase/nakshatra from it — same location, already recorded.
>   For a date with no matching Cock sheet (e.g. 2026-10-30), collect the envelope fresh from the Panchangam.
> - **Drik (Owl):** in drikpanchang.com Pancha Pakshi, **explicitly select Owl** (S1), read the 10-yama schedule.
> - **Saranidhi (Owl):** fill from `diagnostic-dump --bird owl` after all 7 days (one run).
> - **Adhikara/Padu (expected):** hand-read from Kottumozhi pp14/17/18/22 (S3) — the #306 day-block check.
> 24-hour local time to the minute. Lowercase spelling. Leave anomalies raw in `remarks`.

## Day header (copy envelope from the matching Cock day-sheet)

| Field | Value |
|---|---|
| date | `2026-10-25` |
| weekday | `Sun` |
| sunrise | `06:05` |
| sunset | `17:51` |
| lunar phase (paksha) | `waxing` (`Shukla`) |
| nakshatra | `Revati` |

## S3 — Adhikara / Padu day-block expectation (from Kottumozhi pp14/17/18/22)

> For THIS (weekday, paksha), is Owl in an Adhikara block, a Padu day, or neither? Fill once per day.
> This is what #306 now applies to the live score — Saranidhi's classification must match this.

| Layer | Expected (corpus) | Saranidhi (#306) applied? | match? |
|---|---|---|---|
| day block | `padu` | `padu` | ✅ MATCH |
| night block | `padu` | `padu` | ✅ MATCH |

## Yama rows (Y1–Y5 day · Y6–Y10 night)

| yama | start | end | Drik ruling bird | Drik (Owl) state | Saranidhi ruling bird | Saranidhi (Owl) state | match? | remarks |
|------|-------|-----|------------------|------------------|-----------------------|-----------------------|--------|---------|
| 1 | `06:05` | `08:26` | vulture |  | owl | ruling |  |  |
| 2 | `08:26` | `10:47` | peacock |  | rooster | dying |  |  |
| 3 | `10:47` | `13:09` | vulture |  | vulture | eating |  |  |
| 4 | `13:09` | `15:30` | owl |  | crow | walking |  |  |
| 5 | `15:30` | `17:52` | rooster |  | peacock | sleeping |  |  |
| 6 | `17:52` | `20:18` | owl |  | peacock | sleeping |  |  |
| 7 | `20:18` | `22:45` | crow |  | vulture | eating |  |  |
| 8 | `22:45` | `01:11` | rooster |  | crow | walking |  |  |
| 9 | `01:11` | `03:38` | vulture |  | rooster | dying |  |  |
| 10 | `03:38` | `06:05` | peacock |  | owl | ruling |  |  |

> **ruling bird:** `vulture` / `owl` / `crow` / `rooster` / `peacock`
> **Owl state:** `ruling` / `eating` / `walking` / `sleeping` / `dying`
> **Saranidhi columns:** leave blank until the dump run; then paste its row values and tick `match?`.
