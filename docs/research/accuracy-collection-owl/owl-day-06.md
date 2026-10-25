# Owl Day 06 — 2026-10-29 (Weekday: Thu)

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
| date | `2026-10-29` |
| weekday | `Thu` |
| sunrise | `06:06` |
| sunset | `17:50` |
| lunar phase (paksha) | `waning` (`Krishna`) |
| nakshatra | `Rohini` (upto 11:11) |

## S3 — Adhikara / Padu day-block expectation (from Kottumozhi pp14/17/18/22)

> For THIS (weekday, paksha), is Owl in an Adhikara block, a Padu day, or neither? Fill once per day.
> This is what #306 now applies to the live score — Saranidhi's classification must match this.

| Layer | Expected (corpus) | Saranidhi (#306) applied? | match? |
|---|---|---|---|
| day block | `adhikara` | `adhikara` | ✅ MATCH |
| night block | `normal` | `normal` | ✅ MATCH |

## Yama rows (Y1–Y5 day · Y6–Y10 night)

| yama | start | end | Drik ruling bird | Drik (Owl) state | Saranidhi ruling bird | Saranidhi (Owl) state | match? | remarks |
|------|-------|-----|------------------|------------------|-----------------------|-----------------------|--------|---------|
| 1 | `06:06` | `08:26` |  |  | vulture | sleeping |  |  |
| 2 | `08:26` | `10:47` |  |  | crow | walking |  |  |
| 3 | `10:47` | `13:08` |  |  | rooster | eating |  |  |
| 4 | `13:08` | `15:29` |  |  | peacock | dying |  |  |
| 5 | `15:29` | `17:50` | rooster |  | owl | ruling |  |  |
| 6 | `17:50` | `20:17` | rooster |  | owl | ruling |  |  |
| 7 | `20:17` | `22:44` |  |  | rooster | eating |  |  |
| 8 | `22:44` | `01:11` |  |  | vulture | sleeping |  |  |
| 9 | `01:11` | `03:38` |  |  | crow | walking |  |  |
| 10 | `03:38` | `06:06` |  |  | rooster | dying |  |  |

> **ruling bird:** `vulture` / `owl` / `crow` / `rooster` / `peacock`
> **Owl state:** `ruling` / `eating` / `walking` / `sleeping` / `dying`
> **Saranidhi columns:** leave blank until the dump run; then paste its row values and tick `match?`.
