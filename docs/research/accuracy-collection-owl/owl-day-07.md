# Owl Day 07 — 2026-10-30 (Weekday: Fri)

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
| date | `2026-10-30` |
| weekday | `Fri` |
| sunrise | `06:06` |
| sunset | `17:50` |
| lunar phase (paksha) | `waning` (`Krishna`) |
| nakshatra | `Mrigashira` |

## S3 — Adhikara / Padu day-block expectation (from Kottumozhi pp14/17/18/22)

> For THIS (weekday, paksha), is Owl in an Adhikara block, a Padu day, or neither? Fill once per day.
> This is what #306 now applies to the live score — Saranidhi's classification must match this.

| Layer | Expected (corpus) | Saranidhi (#306) applied? | match? |
|---|---|---|---|
| day block | `normal` | `normal` | ✅ MATCH |
| night block | `normal` | `normal` | ✅ MATCH |

## Yama rows (Y1–Y5 day · Y6–Y10 night)

| yama | start | end | Drik ruling bird | Drik (Owl) state | Saranidhi ruling bird | Saranidhi (Owl) state | match? | remarks |
|------|-------|-----|------------------|------------------|-----------------------|-----------------------|--------|---------|
| 1 | `06:06` | `08:26` | peacock | sleeping | crow | walking | ⚠️ DIFF | Drik shows Peacock ruling. |
| 2 | `08:26` | `10:47` | owl | ruling | owl | ruling | ✅ MATCH | Both engines match: ruling. Owl is ruling bird in both engines. |
| 3 | `10:47` | `13:08` | rooster | walking | vulture | sleeping | ⚠️ DIFF | Drik shows Rooster ruling. |
| 4 | `13:08` | `15:29` | vulture | eating | peacock | eating | ✅ MATCH | Both engines match: eating. |
| 5 | `15:29` | `17:50` | crow | dying | rooster | dying | ✅ MATCH | Both engines match: dying. |
| 6 | `17:50` | `20:17` | vulture | dying | rooster | dying | ✅ MATCH | Both engines match: dying. |
| 7 | `20:17` | `22:44` | owl | ruling | peacock | eating | ⚠️ DIFF | Owl is ruling bird in Drik. |
| 8 | `22:44` | `01:11` | crow | eating | owl | ruling | ⚠️ DIFF | Drik shows Crow ruling. |
| 9 | `01:11` | `03:38` | rooster | sleeping | vulture | sleeping | ✅ MATCH | Both engines match: sleeping. |
| 10 | `03:38` | `06:06` | peacock | walking | crow | walking | ✅ MATCH | Both engines match: walking. |

> **ruling bird:** `vulture` / `owl` / `crow` / `rooster` / `peacock`
> **Owl state:** `ruling` / `eating` / `walking` / `sleeping` / `dying`
> **Saranidhi columns:** leave blank until the dump run; then paste its row values and tick `match?`.
