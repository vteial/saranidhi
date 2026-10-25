# Owl Day 03 — 2026-10-26 (Weekday: Mon)

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
| date | `2026-10-26` |
| weekday | `Mon` |
| sunrise | `06:05` |
| sunset | `17:51` |
| lunar phase (paksha) | `waxing` (`Shukla` Purnima upto 09:41, then Krishna) |
| nakshatra | `Ashwini` (upto 17:41) |

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
| 1 | `06:05` | `08:26` | rooster | eating | peacock | eating | ✅ MATCH | Both engines show eating. Drik shows Rooster ruling. |
| 2 | `08:26` | `10:47` | crow / vulture | walking / eating | vulture | walking | ⚠️ DIFF | Tithi split at 09:41 (Purnima end): Drik splits Y2 into Shukla (walking) & Krishna (eating). |
| 3 | `10:47` | `13:08` | crow | dying | owl | ruling | ⚠️ DIFF | Drik uses Krishna (dying). |
| 4 | `13:08` | `15:29` | peacock | sleeping | rooster | sleeping | ✅ MATCH | Both engines show sleeping. Drik uses Krishna (sleeping). |
| 5 | `15:29` | `17:51` | owl | ruling | crow | dying | ⚠️ DIFF | Owl is ruling bird in Drik. |
| 6 | `17:51` | `20:17` | peacock | walking | crow | dying | ⚠️ DIFF | Drik uses Krishna (walking). |
| 7 | `20:17` | `22:44` | vulture | dying | owl | ruling | ⚠️ DIFF | Drik uses Krishna (dying). |
| 8 | `22:44` | `01:11` | owl | ruling | rooster | sleeping | ⚠️ DIFF | Owl is ruling bird in Drik. |
| 9 | `01:11` | `03:38` | crow | eating | vulture | eating | ✅ MATCH | Both engines show eating. Drik uses Krishna (eating). |
| 10 | `03:38` | `06:05` | rooster | sleeping | peacock | walking | ⚠️ DIFF | Drik uses Krishna (sleeping). |

> **ruling bird:** `vulture` / `owl` / `crow` / `rooster` / `peacock`
> **Owl state:** `ruling` / `eating` / `walking` / `sleeping` / `dying`
> **Saranidhi columns:** leave blank until the dump run; then paste its row values and tick `match?`.
