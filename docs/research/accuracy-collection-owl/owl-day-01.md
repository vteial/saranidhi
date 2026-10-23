# Owl Day 01 — 2026-10-24 (Weekday: Sat)

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
| date | `2026-10-24` |
| weekday | `Sat` |
| sunrise | `__:__` |
| sunset | `__:__` |
| lunar phase (paksha) | `waxing` / `waning` |
| nakshatra | `________` |

## S3 — Adhikara / Padu day-block expectation (from Kottumozhi pp14/17/18/22)

> For THIS (weekday, paksha), is Owl in an Adhikara block, a Padu day, or neither? Fill once per day.
> This is what #306 now applies to the live score — Saranidhi's classification must match this.

| Layer | Expected (corpus) | Saranidhi (#306) applied? | match? |
|---|---|---|---|
| day block | `adhikara` / `padu` / `normal` |  |  |
| night block | `adhikara` / `padu` / `normal` |  |  |

## Yama rows (Y1–Y5 day · Y6–Y10 night)

| yama | start | end | Drik ruling bird | Drik (Owl) state | Saranidhi ruling bird | Saranidhi (Owl) state | match? | remarks |
|------|-------|-----|------------------|------------------|-----------------------|-----------------------|--------|---------|
| 1 | `__:__` | `__:__` |  |  |  |  |  |  |
| 2 | `__:__` | `__:__` |  |  |  |  |  |  |
| 3 | `__:__` | `__:__` |  |  |  |  |  |  |
| 4 | `__:__` | `__:__` |  |  |  |  |  |  |
| 5 | `__:__` | `__:__` |  |  |  |  |  |  |
| 6 | `__:__` | `__:__` |  |  |  |  |  |  |
| 7 | `__:__` | `__:__` |  |  |  |  |  |  |
| 8 | `__:__` | `__:__` |  |  |  |  |  |  |
| 9 | `__:__` | `__:__` |  |  |  |  |  |  |
| 10 | `__:__` | `__:__` |  |  |  |  |  |  |

> **ruling bird:** `vulture` / `owl` / `crow` / `rooster` / `peacock`
> **Owl state:** `ruling` / `eating` / `walking` / `sleeping` / `dying`
> **Saranidhi columns:** leave blank until the dump run; then paste its row values and tick `match?`.
