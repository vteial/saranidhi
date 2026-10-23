# Owl-Column Ground-Truth Collection Plan

> **Owner task — the recording mechanism for the Owl basis.** Companion to
> `docs/research/accuracy-collection/` (the 7-day Cock matrix, PRs #298–#300). That first collection
> validated the **Cock** column because both Align27 and Drik Panchang expose a Cock schedule. The app,
> however, renders the **Owl / effective birth bird** (CONF-PP-001/002 canonical) — and the Owl column in
> those sheets is **Saranidhi's own output with no external source beside it**. This plan closes that gap.
> **Class:** governance / data-collection runbook (not an engine change). **Last verified:** v1.13.0-web.

## Why this is NOT just "re-run the Cock collection with --bird owl"

The Cock matrix had external ground truth for free: Align27 + Drik both publish a Cock column, so
`Saranidhi(Cock)` had something to be checked against. **Owl has no such free column** — Align27 shows
"Your bird: 🐓 Cock" for the owner's profile (modern Pulippani dual-table mapping), and Drik lets you
*pick* a bird. So the first problem to solve is **where an external Owl schedule comes from at all.**
Running `diagnostic-dump --bird owl` only gives us *more Saranidhi output* — it cannot self-validate.

## The central decision this plan forces (pick ONE source strategy before collecting)

| Strategy | How Owl ground truth is obtained | Strength | Cost / risk |
|---|---|---|---|
| **S1 — Drik explicit-Owl** | In drikpanchang.com Pancha Pakshi, explicitly select **Owl** as the bird and read its 10-yama schedule. | A genuine external Owl column, same source family as the Cock collection. | Drik's Owl is *also* a modern/Pulippani-lineage computation — so S1 tests "does Saranidhi's Owl match Drik's Owl", NOT "is Owl doctrinally right". Still valuable as a cross-engine check. |
| **S2 — Derive Owl from the validated Cock ground truth** | Use the already-collected Align27+Drik **ruling-bird** column (which is bird-independent) + the lineage state-assignment rule to compute what Owl *should* be, independently of Saranidhi. | Reuses data already in hand; tests the *model*, not just another engine. | Requires the per-yama sequence rule we DON'T yet have (CONF-PP-007 open) — so S2 is blocked on the same unresolved question. |
| **S3 — Owner manual / corpus hand-computation** | Hand-compute Owl's 10-yama states from the Kottumozhi day-block tables (Adhikara/Padu) + the lineage sequence, for the 7 pinned days. | Pure primary-source ground truth, no secondary app. | Labour-intensive; and the *full* per-yama sequence is exactly what the corpus lacks (only day-blocks are tabulated). Can validate the Adhikara/Padu **day-block** layer we just shipped (#306), not the full sequence. |

**Recommendation:** run **S1 now** (cheap, gives a real external Owl column, directly checks the
cross-engine delta) **and** use **S3 partially** to validate the #306 Adhikara/Padu day-blocks the app now
applies — because S3 *can* cover the day-block layer even though it can't cover the full sequence. **Defer
S2** until CONF-PP-007 resolves the sequence model (S2 needs it). This way the collection produces a usable
result today without waiting on the open doctrinal question.

## Pinned constants — set ONCE, identical across sources (mirror the Cock sheet)

| Constant | Value | Why it must not vary |
|---|---|---|
| **Bird** | `owl` | The app's canonical rendered bird (CONF-PP-001/002). |
| **Location** | `Kallakkurichchi` lat `11.7382` lng `78.9639` | Same place as the Cock collection — a different city shifts every yama boundary. |
| **Start date** | **2026-10-24 → 10-30** (starts tomorrow, 7 **consecutive** days, Sat→Fri) | Days 1–6 (10-24..29) overlap the Cock matrix week, so copy those envelopes from the Cock sheets; Day 7 (10-30) has no Cock sheet — collect its envelope fresh. |
| **Day boundary** | sunrise → sunrise (CONF-001) | Weekday/phase read on the sunrise-anchored civil day. |
| **Time format** | 24-hour local to the minute; lowercase spelling | Mechanical diff against the dump. |

## HARD pre-requisite
- Production must be **≥ the Swara-Clock fix (v1.11.0+)** AND now **≥ v-with-#306** (the Adhikara/Padu
  activation) so the Saranidhi Owl column reflects the *shipped* scoring, not a pre-activation engine.
- If reusing the Cock dates, the Panchangam envelope columns are already filled — copy them, don't re-collect.

## The mechanism (~5 min/day, same cadence as the Cock collection)
1. Each morning after sunrise, open **drikpanchang.com** and **explicitly select Owl** (S1). Read Owl's
   full 10-yama schedule (per-yama times + Owl state + ruling bird).
2. Fill that day's `owl-day-NN.md` sheet: reuse the Panchangam envelope from the matching Cock sheet; fill
   the `Drik(Owl)` column from step 1.
3. For the S3 day-block check, mark for each day whether Owl is in an **Adhikara** or **Padu** block per the
   Kottumozhi tables (pp14/17/18/22) — this is what #306 now applies, so it's directly checkable.
4. Note anomalies in `remarks` raw — do not "fix" them (paksha splits, straddled midnights, source disagreements).

## Column responsibilities

| Column | Filled from | When |
|---|---|---|
| Panchangam envelope (sunrise/sunset, phase, nakshatra) | copied from the matching Cock day-sheet | once |
| **Drik (Owl)** per-yama ruling bird + Owl state | drikpanchang, Owl explicitly selected (S1) | each morning |
| **Saranidhi (Owl)** per-yama output | `diagnostic-dump --bird owl --date <start> --days 7 --format md` | one run after the 7 days |
| **Adhikara/Padu day-block (expected)** | Kottumozhi pp14/17/18/22 hand-read (S3) | once per day |

## Deliverable layout (mirror the Cock folder)
```
docs/research/accuracy-collection-owl/
  README.md            (this plan, trimmed to the recording instructions)
  _owl-day-template.md
  owl-day-01.md .. owl-day-07.md
```

## After the 7 days — the analysis chain
1. **Cross-engine delta (S1):** Saranidhi(Owl) vs Drik(Owl) per yama — a match rate like the Cock 24.3%.
   A HIGH match here means Saranidhi and Drik share the Owl lineage; a low one means they diverge even
   within the modern school.
2. **Day-block validation (S3):** does Saranidhi's shipped #306 Adhikara/Padu classification for Owl match
   the Kottumozhi day-block tables on all 7 days? This is the part we CAN validate against the primary
   source today — it directly checks the modifier users now see.
3. **Record** in a new `docs/research/accuracy-calibration-owl.md`: the two match rates, any day-block
   mismatch (which WOULD be a #306 bug and a correctness-critical fix), and the still-open sequence question.
4. The full **per-yama sequence** validation stays **blocked on CONF-PP-007** — this collection does not
   attempt to resolve it, only to (a) measure the cross-engine Owl delta and (b) prove the day-block layer.

## Scope boundary (flag, don't fold)
- This is **data collection + the day-block check only**. It does NOT change the engine, does NOT resolve
  the per-yama sequence (CONF-PP-007), and does NOT adopt any source as canonical. A day-block MISMATCH
  surfaced in step 2 is logged as a separate correctness finding for an owner-gated fix Spec, not patched here.
