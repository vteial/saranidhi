<a id="top"></a>
[← Back to Docs](../../README.md)

# Saranidhi — Panja Pakshi Workshop Knowledge Base

> Canonical digitized capture of the owner's **Panja Pakshi (பஞ்ச பட்சி / பஞ்ச பக்ஷி — the science of the five birds)**
> workshop and class knowledge. This is a **separate corpus from Sara Kalai** (`sarakalai-workshop-knowledge.md`)
> and must never be merged into it. It is **bilingual by design** — Tamil source terms are recorded first,
> each with transliteration and an English gloss. It is captured **incrementally, source by source and
> topic by topic**, across many sessions, meant to be resumed and appended to rather than written in one pass.
>
> This is the **source corpus from which the Panja Pakshi half of the backlog is later derived** — but
> **capture ≠ backlog**. Each captured practice is classified by *how much the app can actually help* (see Legends).
> The app already ships a substantial Panja Pakshi engine (birth-bird derivation, 5 bird states, day/night
> yamas — see `docs/research/calculation-methodology.md` + `lib/features/astro_engine/`), so a second job of this
> corpus is to **corroborate / audit the shipped implementation against the authentic class source** and flag any
> divergence as a CONF-PP for the owner to adjudicate.

---

## Source Corpus & Authority Hierarchy

Panja Pakshi is captured from a **tiered multi-source set** (local: `worknotes/panja_pakshi/`). When sources conflict, higher authority wins; the **owner is the final adjudicator** and records the decision in the CONF-PP tracker.

| Tier | Source | Local path | Authority | Notes |
|:---:|--------|-----------|:---------:|-------|
| 🥇 1 | **2025 Panja Pakshi workshop video** (the master's class the owner attended) | `worknotes/panja_pakshi/class/` (mp4 ~1.5 GB) | **PRIMARY** | Transcribe → `docs/research/transcripts/panja-pakshi-2025/pp-class-NN.md`. Recorded teaching outranks the books when they conflict. |
| 🥇 1 | **Master's 56-page book** (same teacher as the workshop) | `worknotes/panja_pakshi/books/` (PDF) | **PRIMARY** | Same-lineage author; corroborates/refines the video. Practices captured directly into this doc with page refs. |
| 🥈 2 | **Two classic books (~1920)**, semi-poetic archaic Tamil | `worknotes/panja_pakshi/books/` (PDF) | **ROOT / CLASSICAL** | Foundational doctrine. Archaic Tamil (not modern) → flag interpretation ambiguities as CONF-PP. |
| 🥉 3 | **3 hand-picked YouTube videos** | `worknotes/panja_pakshi/youtube/` (mp4) | **LOWER (corroboration)** | Transcribe → `docs/research/transcripts/panja-pakshi-youtube/pp-yt-NN.md`. Corroborate/refine only; never overturn a primary source or a resolved CONF-PP. |

**Resolution order:** (1) 2025 workshop video + master's book = primary → (2) 1920 classical books = root/foundational → (3) YouTube = corroboration. Handwritten notes (if any) are a secondary aid, verified against the video.

---

## How to use this document

- **Capture by source priority, then by topic.** Recommended batch order: (1) workshop video, (2) master's 56-page book, (3) the two 1920 classics, (4) YouTube corroboration.
- **Per practice, fill the template.** For every distinct practice, copy the [Per-Practice Template](#per-practice-template) and fill each field.
- **Tag its app-help bucket.** Classify every practice 🟢 / 🟡 / 🔴 (see Legends).
- **Corroborate the shipped engine.** Where the source matches the app's existing Pakshi implementation, add a `Corroborates: calculation-methodology.md / PakshiCalculator` note. Where it DIVERGES from the shipped model, do NOT edit the app — raise a **CONF-PP** for the owner.
- **Keep Tamil terms with transliteration.** Always Tamil term first, then transliteration + English gloss.
- **Cite the source + tier.** Every practice/claim carries its `Source ref` (which video timestamp / book + page / YouTube) so provenance is auditable.

---

## Legends

### Capture status

| Symbol | Meaning |
|--------|---------|
| ⬜ | Pending |
| 🔄 | In progress |
| ✅ | Captured |

### App-help classification

| Symbol | Bucket | Meaning |
|--------|--------|---------|
| 🟢 | **App-assistable** | Device can compute, remind, track, guide, or visualize → **strong backlog candidate**. |
| 🟡 | **App-augmentable** | App scaffolds (instructions, timers, checklists, prompts, self-report) but user does it → **maybe backlog**. |
| 🔴 | **Self-achieved / document-only** | Pure inner practice, esoteric attainment, or sensitive/non-directive material → **NOT a backlog item**; knowledge/context only. |

### Implemented flag

| Symbol | Meaning |
|--------|---------|
| ✅ | Implemented (already shipped) |
| ⬜ | Not yet |

---

## Topic Progress Tracker

*Add a new topic row here as each topic is begun. Update Capture Status (⬜ → 🔄 → ✅) and practice count as you go.*

| # | Topic | Capture Status | Practices | Source(s) |
|:-:|-------|:--------------:|:---------:|-----------|
| — | _(topics added during capture)_ | ⬜ | 0 | — |

**Total captured: 0 practices (capture not yet begun).**

---

## Open Confirmations Tracker — Panja Pakshi (பஞ்ச பட்சி சரிபார்ப்பு வரிசை)

> Separate from the Sara Kalai CONF tracker. These are points where a single source is ambiguous, sources
> conflict (e.g. archaic 1920 Tamil vs the master's modern teaching), or the source diverges from the app's
> **already-shipped** Pakshi engine. **The owner is the doctrinal authority; the capture agent only PROPOSES
> (🔁), never confirms (✅).** ID scheme: **CONF-PP-001, CONF-PP-002, …**

**Resolution Tier:** 🔴 T1 (blocking — conflicts a shipped feature / core engine) · 🟡 T2 (feature-shaping) · 🟢 T3 (detail/fidelity).
**Status:** ⏳ Pending · 🔁 Proposed (owner confirm) · ✅ Confirmed.

| ID | Tier | Topic / Practice | Question / Ambiguity | Source | Decision (owner) | App impact | Status |
|:--:|:--:|------------------|----------------------|--------|------------------|:----------:|:------:|
| — | — | _(raised during capture)_ | — | — | — | — | ⏳ |

---

## Per-Practice Template

*Copy this block for each distinct practice. Delete this comment when filling.*

```
#### Practice — <Tamil name> (<Transliteration> / <English gloss>)
- **Purpose / benefit (the why):** …
- **How it's practiced (brief mechanics):** …
- **App-help bucket:** 🟢 / 🟡 / 🔴 — <one-line reason>
- **Implemented?:** ⬜ / ✅ <which shipped feature, if any>
- **Corroborates / diverges:** <e.g. "Corroborates calculation-methodology.md birth-bird table" OR "Diverges — see CONF-PP-00N">
- **Rough app idea (optional):** …
- **Source ref:** <tier + citation, e.g. `panja-pakshi-2025/pp-class-02.md` @ mm:ss · master's book p.NN · 1920 classic <name> p.NN · `pp-yt-01.md`>
```

---

## Captured Topics

*Capture begins below this line, one `### <n>. <Topic name>` heading per topic.*
