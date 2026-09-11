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
| 1 | பஞ்சபூத தோற்றமும் 5 பறவை குறியீடுகளும் (Cosmological Foundation & 5 Bird Archetypes) | ✅ | 2 | 🥇 2025 Workshop Day 1 (`pp-class-01.md`) |
| 2 | ஜென்ம பக்ஷி & பெயர் எழுத்து பக்ஷி நிர்ணயம் (Natal Star & Name Initial Bird Determination) | ✅ | 2 | 🥇 2025 Workshop Day 1 (`pp-class-01.md`), Day 2 (`pp-class-02.md`) |
| 3 | நாழிகை-ஜாம காலப் பகுப்பு & 5 தொழில்கள் (Time Mathematics & The Five Bird States) | ✅ | 4 | 🥇 2025 Workshop Day 1 (`pp-class-01.md`), Day 4 (`pp-class-04.md`) |
| 4 | அதிகார, படுபக்ஷி & தன்ய நாட்கள் (Special Operating Days: Ruling, Downtime & Shunya) | ✅ | 4 | 🥇 2025 Workshop Day 2 (`pp-class-02.md`) |
| 5 | நட்பு-பகை உறவு வட்டங்கள் & திசை உத்திகள் (Inter-Bird Dynamics & Directional Tactics) | ✅ | 3 | 🥇 2025 Workshop Day 3 (`pp-class-03.md`) |
| 6 | 5 பக்ஷிகளின் ஆழமான உளவியல் குணங்கள் (Psychological Archetypes of the 5 Birds) | ✅ | 5 | 🥇 2025 Workshop Day 3 (`pp-class-03.md`) |
| 7 | பக்ஷி ஆற்றல் பெருக்கும் கருவிகள் & வாழ்வியல் பயன்பாடுகள் (Empowerment Tools & Life Applications) | ✅ | 5 | 🥇 2025 Workshop Day 4 (`pp-class-04.md`), Day 5 (`pp-class-05.md`) |
| 8 | நூல் சார்ந்த தனித்துவப் பிரயோகங்கள், வாஸ்து & தன வசிய தாந்த்ரீகம் (Book-Exclusive Esoteric Practices, Vastu & Wealth Tantra) | ✅ | 10 | 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf`) |

**Total captured: 35 practices across 8 foundational topics.**

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
| CONF-PP-001 | 🔴 T1 | Nakshatra-to-Bird Star Boundaries | The shipped engine (`PakshiCalculator` / Pulippani) partitions the 27 nakshatras as 5-5-5-5-7 (Vulture=5, Owl=5, Crow=5, Cock=5, Peacock=7), assigning Purva Phalguni to Crow, Vishakha to Cock, and Uttara Ashadha to Peacock. The 2025 workshop master partitions stars as 5-6-5-5-6, assigning Purva Phalguni (Pooram) to Owl, Vishakha (Visakam) to Crow, and Uttara Ashadha (Uthiradam) to Rooster. Which nakshatra boundary is canonical for the app's default birth bird? | 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 29:00) vs Shipped `PakshiCalculator._brightVultureNakshatras` | — | Shifting star assignments changes birth birds for individuals born under Pooram, Visakam, and Uthiradam. | 🔁 Proposed |
| CONF-PP-002 | 🔴 T1 | Permanent Natal Bird vs Dark Half Reverse Swap | The shipped engine (`PakshiCalculator.birthBirdFromNakshatraAndPaksha` / Pulippani Table 1 & 2) uses two distinct star tables: Table 1 (Ashwini forward) for Shukla births and Table 2 (Revati backward) for Krishna births. The 2025 workshop teacher explicitly states that for natives with a known birth star (Janma Nakshatra), the Valarpirai table is the permanent lifetime bird ("ஜென்ம பக்ஷி... இந்த ஒரே பறவையை வாழ்நாள் முழுவதும் பயன்படுத்தலாம்... தேய்பிறை பக்ஷி போகவே வேண்டாம்"), and that waxing/waning bird swapping ONLY applies to those deriving their bird from their name initial letter (Nama Pakshi). Should birth star lookups use a single permanent table for all births, or retain dual Shukla/Krishna tables? | 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 33:00) vs `calculation-methodology.md` §1 | — | Core engine calculation in `PakshiCalculator.birthBirdFromNakshatraAndPaksha`. | 🔁 Proposed |
| CONF-PP-003 | 🟡 T2 | Natural Friendship & Enmity Matrices | In `pakshi_attributes.dart` (Pulippani), Vulture's friends are Crow & Owl, and enemies are Peacock & Rooster. In the 2025 workshop (Day 3), Vulture's friends in Valarpirai are Peacock & Owl, and enemies are Crow & Rooster; and Vulture ↔ Peacock is declared a permanent invariant ally across both moon phases, while Vulture ↔ Rooster is declared a permanent bitter enemy. Several friend/enemy pairs are inverted between the workshop and Pulippani. Which relational matrix should the app display in compatibility and daily advice? | 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 02:46) vs `pakshi_attributes.dart` lines 197–252 | — | UI displays of bird allies, opponents, and relationship advice screens. | 🔁 Proposed |
| CONF-PP-004 | 🟡 T2 | Elemental Ruling Planets | In `pakshi_attributes.dart`, the ruling planets are: Vulture=Saturn, Owl=Mars, Crow=Venus, Rooster=Jupiter, Peacock=Mercury. In the 2025 workshop (Day 4 @ 48:41), the ruling planets are: Vulture=Guru (Jupiter), Owl=Sukran (Venus), Crow=Sevvai (Mars), Rooster=Budhan (Mercury), Peacock=Shani (Saturn), explained by classical Tamil Siddha elemental physics. Which planet mapping governs the bird attributes? | 🥇 2025 Workshop Day 4 (`pp-class-04.md` @ 48:41) vs `pakshi_attributes.dart` lines 91–121 | — | `PakshiAttributes` planet getters and color associations. | 🔁 Proposed |
| CONF-PP-005 | 🟢 T3 | Cardinal Direction Assignments | In `pakshi_attributes.dart`, bird directions are static (Vulture=West, Owl=North, Crow=South, Rooster=East, Peacock=Center). In the 2025 workshop (Day 3 @ 18:21), directions are dynamic by moon phase: Valarpirai (Vulture=East, Owl=South, Crow=West, Rooster=North, Peacock=Sky/Center) and Theipirai (Vulture=East, Owl=North, Crow=South, Rooster=Center, Peacock=West). Should the app support directional tactics with phase-dependent cardinal directions? | 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 18:21) vs `pakshi_attributes.dart` lines 124–154 | — | Tactical advice and compass UI feature in AstroEngine. | 🔁 Proposed |

---

## Per-Practice Template

```
#### Practice — <Tamil name> (<Transliteration> / <English gloss>)
- **Purpose / benefit (the why):** …
- **How it's practiced (brief mechanics):** …
- **App-help bucket:** 🟢 / 🟡 / 🔴 — <one-line reason>
- **Implemented?:** ⬜ / ✅ <which shipped feature, if any>
- **Corroborates / diverges:** <e.g. "Corroborates calculation-methodology.md birth-bird table" OR "Diverges — see CONF-PP-00N">
- **Rough app idea (optional):** …
- **Source ref:** <tier + citation>
```

---

## Captured Topics

### 1. பஞ்சபூத தோற்றமும் 5 பறவை குறியீடுகளும் (Cosmological Foundation & 5 Bird Archetypes)

#### Practice — பஞ்சபூத-உயிரெழுத்து வடிவு இயைபு (Pancha Bhoota Uyir Ezhuthu Vadivu Iyaibu / Element-Vowel Glyph Morphological Resonance)
- **Purpose / benefit (the why):** Establishes why specific birds govern specific primordial elements. Grounded in the Tamil vowel glyph shapes (`அ, இ, உ, எ, ஒ`), linking macrocosmic forces (அண்டம்) to microcosmic human embodiment (பிண்டம்).
- **How it's practiced (brief mechanics):**
  - **அ (A) → நிலம் (Earth / Prithvi) → வல்லூறு (Vulture):** Observes from immense heights and strikes prey on ground with unyielding precision.
  - **இ (I) → நீர் (Water / Apas) → ஆந்தை (Owl):** Nocturnal moon-energy (Chandra karaka), acute nocturnal vision, active in fluid dark.
  - **உ (U) → நெருப்பு (Fire / Agni) → காகம் (Crow):** Karmic fire of Shani (creates and destroys), beak/silhouette mimics glyph 'உ'.
  - **எ (E) → காற்று (Air / Vayu) → சேவல் / கோழி (Rooster / Cock):** Wakes the world at 4 AM Brahma Muhurtam, breath of awakening, silhouette mimics glyph 'எ'.
  - **ஒ (O) → ஆகாயம் (Ether / Akasha) → மயில் (Peacock):** Dances to rainclouds in the open sky, expansive etheric feathers mimic glyph 'ஒ'.
- **App-help bucket:** 🔴 Self-achieved / document-only — Foundational cosmological doctrine and ontology.
- **Implemented?:** ⬜ Not yet (doc-only).
- **Corroborates / diverges:** Corroborates `lib/features/astro_engine/domain/pakshi_attributes.dart` element associations (Earth, Water, Fire, Air, Ether), providing their authentic linguistic-glyph derivation.
- **Rough app idea (optional):** Visual infographic on bird detail screens showing the Tamil vowel glyph overlaid on the bird illustration.
- **Source ref:** 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 07:03 – 10:02).

#### Practice — கந்தபுராண சூரசம்ஹார போர் வியூக சான்றாக்கம் (Kanda Purana Surasamhara Por Vyooha Saandraakkam / Murugan's Canonical War Timing Precedent)
- **Purpose / benefit (the why):** Proves the antiquity and efficacy of Panja Pakshi Shastra as a strategic combat and electional system taught by Shiva to Murugan to overcome invincible adversaries.
- **How it's practiced (brief mechanics):**
  - Surapadman possessed boons making him invulnerable except to Shiva's direct third-eye fiery spark.
  - Shiva imparted Panja Pakshi Shastra to Murugan to calibrate his attack to the exact **அரசில் அரசு காலம் (Ruling sub-state within Ruling state)**.
  - On the final day of war, Murugan paused the duel with *"இன்று போய் நாளை வா"* (Go today and return tomorrow) because Surapadman's bird was entering its powerful state while Murugan's bird entered a declining state. Once the enemy's bird entered death/sleep, Murugan struck, cleaving the mango tree into Peacock (vehicle) and Rooster (flag).
- **App-help bucket:** 🔴 Document-only — Cultural and mythological lineage grounding.
- **Implemented?:** ⬜ Not yet.
- **Corroborates / diverges:** Corroborates the fundamental Siddha axiom: *"பக்ஷி பார்க்கத் தெரிந்தவனை பகைக்காதே"* (Do not oppose one who knows how to read his bird).
- **Rough app idea (optional):** In-app lore / historical context card in the learn section.
- **Source ref:** 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 13:20 – 20:47).

---

### 2. ஜென்ம பக்ஷி & பெயர் எழுத்து பக்ஷி நிர்ணயம் (Natal Star & Name Initial Bird Determination)

#### Practice — 27 நட்சத்திர நிரந்தர ஜென்ம பக்ஷி முறை (27 Nakshatra Nirantha Janma Pakshi Murai / Permanent Natal Bird Derivation via Moon Mansion)
- **Purpose / benefit (the why):** Determines the individual's permanent birth bird based on the natal Moon's nakshatra at birth.
- **How it's practiced (brief mechanics):**
  - **வல்லூறு (5 stars):** அஸ்வினி (Ashwini), பரணி (Bharani), கார்த்திகை (Krittika), ரோகிணி (Rohini), மிருகசீரிஷம் (Mrigashira).
  - **ஆந்தை (6 stars):** திருவாதிரை (Ardra), புனர்பூசம் (Punarvasu), பூசம் (Pushya), ஆயில்யம் (Ashlesha), மகம் (Magha), பூரம் (Purva Phalguni).
  - **காகம் (5 stars):** உத்திரம் (Uttara Phalguni), அஸ்தம் (Hasta), சித்திரை (Chitra), சுவாதி (Swati), விசாகம் (Vishakha).
  - **கோழி (5 stars):** அனுஷம் (Anuradha), கேட்டை (Jyeshtha), மூலம் (Mula), பூராடம் (Purva Ashadha), உத்திராடம் (Uttara Ashadha).
  - **மயில் (6 stars):** திருவோணம் (Shravana), அவிட்டம் (Dhanishta), சதயம் (Shatabhisha), பூரட்டாதி (Purva Bhadrapada), உத்திரட்டாதி (Uttara Bhadrapada), ரேவதி (Revati).
  - *Permanent Invariant:* This single bird remains the user's permanent bird for their entire lifetime regardless of waxing or waning moon.
- **App-help bucket:** 🟢 App-assistable — Core natal bird calculator.
- **Implemented?:** ✅ Already shipped in `PakshiCalculator.birthBirdFromNakshatraAndPaksha`.
- **Corroborates / diverges:** **Diverges** on two counts (see CONF-PP-001 for 5-6-5-5-6 star groupings vs shipped 5-5-5-5-7, and CONF-PP-002 for permanent single-table mapping vs shipped dual-table moon swap).
- **Rough app idea (optional):** Settings toggle allowing user to audit natal bird between classical Pulippani vs 2025 Workshop lineage.
- **Source ref:** 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 29:00 – 34:00).

#### Practice — பெயர் முதல் எழுத்து வழி வளர்பிறை-தேய்பிறை பக்ஷி முறை (Peyar Mudhal Ezhuthu Pakshi / Name Initial Dual-Phase Bird Determination)
- **Purpose / benefit (the why):** Provides exact bird derivation for individuals without horoscopes or unknown birth stars.
- **How it's practiced (brief mechanics):**
  - For non-horoscope users, the bird is derived from the first letter of their spoken name, and **swaps** between Valarpirai and Theipirai:
  - **வளர்பிறை (Shukla Paksha):**
    * வல்லூறு: அ, ஆ, ஐ, ஔ (and uyirmei variants: க, கா, கை, கௌ...)
    * ஆந்தை: இ, ஈ (and uyirmei: கி, கீ...)
    * காகம்: உ, ஊ (and uyirmei: கு, கூ...)
    * கோழி: எ, ஏ (and uyirmei: கெ, கே...)
    * மயில்: ஒ, ஓ (and uyirmei: கொ, கோ...)
  - **தேய்பிறை (Krishna Paksha):**
    * மயில்: எ, ஏ
    * கோழி: அ, ஆ, ஐ, ஔ
    * வல்லூறு: இ, ஈ
    * காகம்: ஒ, ஓ
    * ஆந்தை: உ, ஊ
- **App-help bucket:** 🟢 App-assistable — Onboarding fallback when user selects "I don't know my birth star / time".
- **Implemented?:** ⬜ Not yet (app currently defaults to Ashwini/Bright Half).
- **Corroborates / diverges:** Explains why historical texts mentioned bird-swapping between lunar halves — it was exclusively meant for the Name-Letter system, not Janma Nakshatra!
- **Rough app idea (optional):** Add a "Find by Name" input field in Onboarding/Settings that automatically switches active bird during full/new moon.
- **Source ref:** 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 34:01 – 51:00).

---

### 3. நாழிகை-ஜாம காலப் பகுப்பு & 5 தொழில்கள் (Time Mathematics & The Five Bird States)

#### Practice — 60 நாழிகை / 10 ஜாம உள்ளூர் உதய காலக் கணிதம் (Local Sunrise 10-Yama Chronobiology)
- **Purpose / benefit (the why):** Segments the 24-hour diurnal cycle into exact bio-energetic periods anchored to solar dawn.
- **How it's practiced (brief mechanics):**
  - 1 Day = 60 நாழிகை = 24 hours.
  - Divided into 10 ஜாமம் (5 Daytime Yamas + 5 Nighttime Yamas).
  - 1 ஜாமம் = 6 நாழிகை = 144 minutes = 2 hours 24 minutes.
  - Daytime yamas start precisely at local sunrise ($T_{\text{sunrise}}$):
    * Yama 1: $T + 0\text{m}$ to $T + 144\text{m}$
    * Yama 2: $T + 144\text{m}$ to $T + 288\text{m}$
    * Yama 3: $T + 288\text{m}$ to $T + 432\text{m}$
    * Yama 4: $T + 432\text{m}$ to $T + 576\text{m}$
    * Yama 5: $T + 576\text{m}$ to $T + 720\text{m}$
  - Nighttime yamas start precisely at local sunset ($T_{\text{sunset}}$), running 5 consecutive 144-minute periods until next dawn.
- **App-help bucket:** 🟢 App-assistable — Engine time-slicing math.
- **Implemented?:** ✅ Already shipped in `YamaCalculator` and `calculation-methodology.md` §3 (NOAA Solar position algorithm).
- **Corroborates / diverges:** **Corroborates** `calculation-methodology.md` exactly. The teacher explicitly emphasizes anchoring to local sunrise rather than a rigid 6:00 AM clock.
- **Rough app idea (optional):** Shipped engine already implements this.
- **Source ref:** 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 51:01 – 60:20).

#### Practice — 5 தொழில் பலம் & ஒதுக்கீட்டு விதிமுறை (Five Bird Activity States & Mutual Exclusion Law)
- **Purpose / benefit (the why):** Defines the exact energy availability and capability ratings for each bird across yamas.
- **How it's practiced (brief mechanics):**
  - **அரசு (Ruling):** 100% Power — Peak vitality, executive commands, starting high-stakes ventures.
  - **ஊண் (Eating):** 80% Power — Ingestion, nourishing, strengthening, steady progress.
  - **நடை (Walking):** 50% Power — Average, routine, sluggish progress, delays.
  - **துயில் (Sleeping):** 10% Power — Comatose, passive, minimal vitality, avoid major action.
  - **சாவு (Dying):** 0% Power — Complete inertia, total obstruction, strict avoidance of commitments.
  - *Mutual Exclusion Law:* In any single yama, each bird occupies exactly one distinct state, and all 5 states are filled simultaneously across the 5 birds.
- **App-help bucket:** 🟢 App-assistable — Real-time state display and percentage bars.
- **Implemented?:** ✅ Shipped in `PakshiCalculator` (returns `PakshiState.ruling`, `eating`, `walking`, `sleeping`, `dying`).
- **Corroborates / diverges:** **Corroborates** `calculation-methodology.md` §2 and `PakshiDayResult`.
- **Rough app idea (optional):** Render power percentages (100%, 80%, 50%, 10%, 0%) alongside state badges in the daily timeline.
- **Source ref:** 🥇 2025 Workshop Day 1 (`pp-class-01.md` @ 60:21 – 68:28).

#### Practice — அமாவாசை-பௌர்ணமி 1 நாழிகை திதி எல்லை விதி (The 24-Minute / 1-Nazhigai Thithi Boundary Rule)
- **Purpose / benefit (the why):** Resolves ambiguous boundary edge-cases when transitioning between waxing (Shukla) and waning (Krishna) fortnights on Full Moon and New Moon days.
- **How it's practiced (brief mechanics):**
  - **Sunrise Transition:** If Pournami or Amavasya thithi extends for at least **24 minutes (1 நாழிகை)** after local sunrise, the entire daytime period (5 day yamas) is governed by that thithi's fortnight (Pournami = Valarpirai; Amavasya = Theipirai).
  - **Sunset Transition:** If Pournami or Amavasya thithi extends for at least **24 minutes** past local sunset, the entire nighttime period (5 night yamas) is governed by that thithi's fortnight.
  - If the thithi expires before 24 minutes, the subsequent fortnight rules immediately from sunrise/sunset.
- **App-help bucket:** 🟢 App-assistable — Automated astronomical edge-case handling in `LunarPhaseCalculator`.
- **Implemented?:** ⬜ Not yet explicitly formalized with the 24-minute threshold in `LunarPhaseCalculator`.
- **Corroborates / diverges:** Refines `calculation-methodology.md` with an exact authentic 24-minute window rule.
- **Rough app idea (optional):** Incorporate 24-minute solar horizon threshold check in `LunarPhaseCalculator.phaseForDate()`.
- **Source ref:** 🥇 2025 Workshop Day 4 (`pp-class-04.md` @ 22:51 – 31:00).

#### Practice — பிரதமை-அஷ்டமி-நவமி-கரிநாள் பக்ஷி விலக்கின்மை விதி (Prathamai, Astami, Navami, Kari Naal Exemption)
- **Purpose / benefit (the why):** Clarifies that traditional astrological taboos against Prathamai (1st lunar day), Astami (8th), Navami (9th), and Kari Naal (inauspicious solar days) DO NOT apply to Panja Pakshi.
- **How it's practiced (brief mechanics):**
  - Unlike classical Jyotish electional astrology (Muhurtam) which shuns Astami and Navami for beginnings, Panja Pakshi operates purely on solar-lunar bio-cycles.
  - As long as one's bird is in **அரசு (Ruling)** or **ஊண் (Eating)** state, actions executed on Astami, Navami, Prathamai, and Kari Naal succeed without impediment.
- **App-help bucket:** 🟢 App-assistable — Educational tooltip reassuring user when high-power pakshi occurs on Astami/Navami.
- **Implemented?:** ⬜ Not yet surfaced in UI.
- **Corroborates / diverges:** Corroborates independent functioning of Panja Pakshi vs conventional panchangam taboos.
- **Rough app idea (optional):** "Fearless Action" badge when Ruling/Eating coincides with Astami/Navami.
- **Source ref:** 🥇 2025 Workshop Day 4 (`pp-class-04.md` @ 31:01 – 36:00).

---

### 4. அதிகார, படுபக்ஷி & தன்ய நாட்கள் (Special Operating Days: Ruling, Downtime & Shunya)

#### Practice — வளர்பிறை & தேய்பிறை அதிகார பக்ஷி நாட்கள் (Adhikara Ruling Power Days)
- **Purpose / benefit (the why):** Identifies the 2 to 3 days each week where a bird holds sovereign authority and maintains high vitality across all 5 yamas (day or night).
- **How it's practiced (brief mechanics):**
  - **வளர்பிறை அதிகாரம் (Waxing Sovereign Days):**
    * வல்லூறு: ஞாயிறு (Day), செவ்வாய் (Day), வெள்ளி (Night)
    * ஆந்தை: திங்கள் (Day), புதன் (Day), சனி (Night)
    * காகம்: ஞாயிறு (Night), செவ்வாய் (Night), வியாழன் (Day)
    * கோழி: திங்கள் (Night), புதன் (Night), வெள்ளி (Day)
    * மயில்: வியாழன் (Night), சனி (Day)
  - **தேய்பிறை அதிகாரம் (Waning Sovereign Days):**
    * வல்லூறு: ஞாயிறு (Night), வெள்ளி (Day)
    * ஆந்தை: புதன் (Night) + வியாழன் (Day) — *continuous 24h from Wed 6 PM to Thu 6 PM!*
    * காகம்: புதன் (Day), வியாழன் (Night)
    * கோழி: திங்கள் (Night) + செவ்வாய் (Day) — *continuous 24h from Mon 6 PM to Tue 6 PM!* + ஞாயிறு (Day)
    * மயில்: திங்கள் (Day), சனி (Day)
  - On these days, even minor/walking states are elevated, making them prime days for life-changing milestones.
- **App-help bucket:** 🟢 App-assistable — Calendar highlights, weekly power-day tags.
- **Implemented?:** ⬜ Not yet tagged in UI.
- **Corroborates / diverges:** Corroborates the day-group table foundations in `calculation-methodology.md`.
- **Rough app idea (optional):** Crown icon (👑) on calendar days where user's bird has Adhikara status.
- **Source ref:** 🥇 2025 Workshop Day 2 (`pp-class-02.md` @ 02:41 – 14:32).

#### Practice — வளர்பிறை & தேய்பிறை படுபக்ஷி நாட்கள் (Padu Pakshi Complete Downtime Days)
- **Purpose / benefit (the why):** Protects the user from severe failure, financial loss, or health complications by identifying days where their bird takes complete leave ("லீவு").
- **How it's practiced (brief mechanics):**
  - On Padu Pakshi days, the bird is completely inactive across all 10 yamas (day and night). Avoid contracts, large payments, surgical procedures, and new launches.
  - **வளர்பிறை படுபக்ஷி (Waxing Downtime Days):**
    * வல்லூறு: வியாழன் (Thursday), சனி (Saturday)
    * ஆந்தை: ஞாயிறு (Sunday), வெள்ளி (Friday)
    * காகம்: திங்கள் (Monday)
    * கோழி: செவ்வாய் (Tuesday)
    * மயில்: புதன் (Wednesday)
  - **தேய்பிறை படுபக்ஷி (Waning Downtime Days):**
    * வல்லூறு: செவ்வாய் (Tuesday)
    * ஆந்தை: திங்கள் (Monday)
    * காகம்: ஞாயிறு (Sunday), வியாழன் (Thursday)
    * கோழி: சனி (Saturday)
    * மயில்: புதன் (Wednesday), வெள்ளி (Friday) — *Peacock has Wednesday as Padu Pakshi in BOTH waxing and waning!*
- **App-help bucket:** 🟢 App-assistable — High-priority calendar warning / red-flag alerts.
- **Implemented?:** ⬜ Not yet flagged in UI.
- **Corroborates / diverges:** New distinct operational concept extending the shipped engine.
- **Rough app idea (optional):** Red alert banner: *"Today is your bird's Padu Pakshi day — avoid new risks; maintain routine only."*
- **Source ref:** 🥇 2025 Workshop Day 2 (`pp-class-02.md` @ 16:01 – 23:45).

#### Practice — தமிழ் மாத 24 தன்ய நாட்கள் (The 24 Monthly Dhanya Shunya Days)
- **Purpose / benefit (the why):** Invariable solar calendar days where the entire Panja Pakshi biological field goes dormant. Universal downtime days for all 5 birds.
- **How it's practiced (brief mechanics):**
  - Fixed on specific dates of the 12 Tamil solar months (never changes year to year):
    * சித்திரை: 3, 20 | வைகாசி: 9, 22 | ஆனி: 8, 22
    * ஆடி: 7, 20 | ஆவணி: 7, 18 | புரட்டாசி: 9, 26
    * ஐப்பசி: 8, 19 | கார்த்திகை: 8, 14 | மார்கழி: 8, 26
    * தை: 8, 15 | மாசி: 15, 24 | பங்குனி: 18, 24
  - On Dhanya days, bird state tables are not consulted; users switch to the **Hora system**.
- **App-help bucket:** 🟢 App-assistable — Calendar annotation and automatic fallback to Hora view.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Authentic Tamil Siddha solar calendar integration.
- **Rough app idea (optional):** Calendar badge showing "Dhanya Day (System Downtime) — Switch to Hora Guide".
- **Source ref:** 🥇 2025 Workshop Day 2 (`pp-class-02.md` @ 23:46 – 32:00).

#### Practice — மாற்று ஹோரை முறை & 7 கிரக காரகத்துவங்கள் (Remedial Planetary Hora Fallback Protocol)
- **Purpose / benefit (the why):** Enables auspicious action when one's bird is in Padu Pakshi, in a Dying/Sleeping state, or on a Dhanya day, by switching to the 1-hour planetary Hora rhythm.
- **How it's practiced (brief mechanics):**
  - Standard planetary Hora order starting at sunrise ($T_{\text{sunrise}}$):
    $$\text{Sun} \rightarrow \text{Venus} \rightarrow \text{Mercury} \rightarrow \text{Moon} \rightarrow \text{Saturn} \rightarrow \text{Jupiter} \rightarrow \text{Mars} \rightarrow \dots$$
  - **Planetary Portfolios:**
    * **சூரிய ஹோரை (Sun):** Government, administrative authority, superiors, father, initial medicine dose, ancestral property, kuladeivam worship.
    * **சந்திர ஹோரை (Moon):** Water, travel planning/departure, passport/visa, shifting homes, maternal affairs, counseling, livestock/dairy.
    * **செவ்வாய் ஹோரை (Mars):** Electricity, machinery, land deals, heavy vehicles. *Strict warning:* Avoid disputes, arguments, or foul language.
    * **புதன் ஹோரை (Mercury):** Paperwork, agreements, bank accounts, IT/digital credentials, mediation/compromise, bikes/autos, electronics.
    * **குரு ஹோரை (Jupiter):** Universal benefic — suitable for all auspicious actions and spiritual initiatives.
    * **சுக்கிர ஹோரை (Venus):** Gold, diamonds, garments, luxury stores, marriage proposals, muhurtam, beauty, fragrances.
    * **சனி ஹோரை (Saturn):** Discarding waste, cleaning property, hiring manual laborers, scrap/iron recycling, servicing machinery.
  - *Synthesis:* A task carried out during your bird's Ruling/Eating yama AND matching a beneficial Hora achieves double potency.
- **App-help bucket:** 🟢 App-assistable — Multi-layer widget combining Bird Yama + Current Planetary Hora.
- **Implemented?:** ⬜ App has partial Hora logic, but not integrated into the Pakshi screen.
- **Corroborates / diverges:** Corroborates classical planetary hora cycles and provides practical bridge with Pakshi states.
- **Rough app idea (optional):** Display active Hora inside the Yama timeline block with a "Harmony Rating" (e.g. "Ruling + Guru Hora = ⭐️⭐️⭐️⭐️⭐️").
- **Source ref:** 🥇 2025 Workshop Day 2 (`pp-class-02.md` @ 32:01 – 48:00).

---

### 5. நட்பு-பகை உறவு வட்டங்கள் & திசை உத்திகள் (Inter-Bird Dynamics & Tactical Positioning)

#### Practice — வளர்பிறை & தேய்பிறை பக்ஷி நட்பு-பகை அமைப்புகள் (Waxing & Waning Friendship-Enmity Matrices)
- **Purpose / benefit (the why):** Manages team selection, business partnerships, hiring, and personal relationships by understanding natural resonance or friction between birds.
- **How it's practiced (brief mechanics):**
  - **வளர்பிறை (Shukla):**
    * வல்லூறு: நட்பு (மயில், ஆந்தை) | பகை (காகம், கோழி)
    * ஆந்தை: நட்பு (வல்லூறு, காகம்) | பகை (மயில், கோழி)
    * காகம்: நட்பு (ஆந்தை, கோழி) | பகை (வல்லூறு, மயில்)
    * கோழி: நட்பு (மயில், காகம்) | பகை (வல்லூறு, ஆந்தை)
    * மயில்: நட்பு (வல்லூறு, கோழி) | பகை (ஆந்தை, காகம்)
  - **தேய்பிறை (Krishna):**
    * வல்லூறு: நட்பு (மயில், காகம்) | பகை (ஆந்தை, கோழி)
    * ஆந்தை: நட்பு (கோழி, காகம்) | பகை (வல்லூறு, மயில்)
    * காகம்: நட்பு (ஆந்தை, வல்லூறு) | பகை (மயில், கோழி)
    * கோழி: நட்பு (மயில், ஆந்தை) | பகை (காகம், வல்லூறு)
    * மயில்: நட்பு (வல்லூறு, கோழி) | பகை (ஆந்தை, காகம்)
  - **நிரந்தர நட்பு (Permanent Allies):** வல்லூறு ↔ மயில், ஆந்தை ↔ காகம், கோழி ↔ மயில்.
  - **முற்றிலும் பகை (Permanent Bitter Enemies):** வல்லூறு ↔ கோழி, ஆந்தை ↔ மயில், காகம் ↔ மயில்.
- **App-help bucket:** 🟢 App-assistable — Relationship audit / compatibility checker.
- **Implemented?:** ⬜ Diverges from shipped `pakshi_attributes.dart` (see CONF-PP-003).
- **Corroborates / diverges:** Diverges significantly from Pulippani's static matrix in `pakshi_attributes.dart`.
- **Rough app idea (optional):** Contact relationship tagging ("Tag partner/colleague with their bird to see daily synergy score").
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 02:46 – 18:20).

#### Practice — பக்ஷி திசைகள் & விவாத/பேச்சுவார்த்தை திசை உத்தி (Tactical Directional Alignment in Negotiations)
- **Purpose / benefit (the why):** Secures psychological and energetic dominance in meetings, arbitration, dispute settlement, and high-stakes negotiations.
- **How it's practiced (brief mechanics):**
  - **திசைகள் (Cardinal Directions):**
    * வளர்பிறை: வல்லூறு=கிழக்கு (East), ஆந்தை=தெற்கு (South), காகம்=மேற்கு (West), கோழி=வடக்கு (North), மயில்=ஆகாயம்/மையம் (Center).
    * தேய்பிறை: வல்லூறு=கிழக்கு (East - permanent), ஆந்தை=வடக்கு (North), காகம்=தெற்கு (South), கோழி=மையம் (Center), மயில்=மேற்கு (West).
  - **கள வியூகம் (Field Strategy):**
    * Choose a meeting time when your bird is in **அரசு (Ruling)** or **ஊண் (Eating)** state.
    * Stand or sit firmly aligned with your bird's ruling cardinal direction.
    * Position the opponent/counterparty facing the cardinal direction of the bird that is currently in **துயில் (Sleeping)** or **சாவு (Dying)** state.
    * The opponent's reasoning becomes sluggish and defenseless, while your arguments carry compelling authority.
- **App-help bucket:** 🟢 App-assistable — Real-time tactical compass widget showing "Sit here / Place counterparty there".
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Diverges from static directions in `pakshi_attributes.dart` (see CONF-PP-005).
- **Rough app idea (optional):** "Meeting Tactician" compass mode showing user's optimal seating direction and opponent's vulnerable direction.
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 18:21 – 31:30).

#### Practice — தர்ம நெறி & கர்ம வினை சமன்பாட்டு எச்சரிக்கை (Karmic Invariant & Ethical Guardrail)
- **Purpose / benefit (the why):** Mandatory ethical boundary preventing the misuse of Panja Pakshi for malicious dominance, exploitation, or harm.
- **How it's practiced (brief mechanics):**
  - Panja Pakshi accelerates energetic reactions.
  - Per Newton's Third Law and Siddha karmic doctrine: Any harm or exploitation engineered against another rebounds twofold upon the practitioner and their lineage.
  - The system must only be engaged for righteous, fair, protective, and constructive life purposes.
- **App-help bucket:** 🔴 Document-only — Foundational moral guardrail.
- **Implemented?:** ⬜ Not yet surfaced.
- **Corroborates / diverges:** Reinforces the sacred lineage oath taught at the beginning of workshop.
- **Rough app idea (optional):** Ethical disclaimer shown during first activation of competitive/directional features.
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 31:31 – 36:40).

---

### 6. 5 பக்ஷிகளின் ஆழமான உளவியல் குணங்கள் (Psychological Archetypes of the 5 Birds)

#### Practice — வல்லூறு ஆளுமை & நிர்வாக சுயதிருத்த மேலாண்மை (Vulture Psychological Archetype & Autonomy Management)
- **Purpose / benefit (the why):** Enhances self-awareness for Vulture natives, capitalizing on natural executive prowess while guarding against arrogance and quick-money traps.
- **How it's practiced (brief mechanics):**
  - **Core Strengths:** Exceptional administrative acumen, leadership drive, relentless desire to be #1, fiercely autonomous, high sense of honor and ancestral pride.
  - **Vulnerabilities:** Hates micromanagement; reacts explosively to unsolicited nagging. Prone to hasty decisions, impatience, and falling for get-rich-quick schemes (MLM, risky speculations) due to overconfidence. Frequently betrayed or maligned by close associates.
  - **Self-Correction:** Demand clear structure upfront; cultivate patient deliberation; never invest in shortcuts; guard personal secrets even from intimate circles.
- **App-help bucket:** 🟡 App-augmentable — Self-reflection profile and behavioral coaching prompts.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Greatly enriches the brief one-line nature description in `pakshi_attributes.dart`.
- **Rough app idea (optional):** "Archetype Insights" screen displaying psychological blindspots and daily mindfulness tips.
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 36:41 – 43:30).

#### Practice — ஆந்தையின் 3 உளவியல் பிரிவுகள் & உணர்ச்சி சமநிலை (Owl 3-Tier Psychological Sub-Archetypes)
- **Purpose / benefit (the why):** Provides tailored self-correction protocols for the 3 distinct sub-types of Owl natives.
- **How it's practiced (brief mechanics):**
  - **Type 1 (Practical Fast-Learner):** Quick on uptake, highly business-oriented, sharp speech. Quick temper that dissipates in 5 minutes. Vulnerable to financial missteps when rushing without senior counsel.
  - **Type 2 (Motherly Empath):** Soft-spoken, self-sacrificing, unable to say "No". Absorbs others' grief while hiding an inner emotional tsunami. Suffers deep heartbreaks from ungrateful beneficiaries.
  - **Type 3 (Imaginative Perfectionist):** Impeccable taste, but plagued by overthinking and hyper-possessiveness. Interprets innocent actions as rejection. Expresses affection through clumsy anger, acquiring an undeserved domineering reputation.
  - **Self-Correction:** Learn to say "No"; establish emotional boundaries; replace possessive attachment with detached goodwill.
- **App-help bucket:** 🟡 App-augmentable — Archetype quiz / self-identification guide.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Deeper psychological granularity than any classical English textbook.
- **Rough app idea (optional):** Personalized profile screen explaining which of the 3 Owl sub-archetypes matches the user best.
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 43:31 – 55:00).

#### Practice — காகத்தின் 2 ஆளுமை பிரிவுகள் & நிறை-குறை விதி (Crow 2-Tier Psychological Archetype & 'Virtue-Only' Speech Rule)
- **Purpose / benefit (the why):** Protects Crow natives from creating inadvertent enemies and relationship breakdowns.
- **How it's practiced (brief mechanics):**
  - **Type 1 (Resilient Commander):** Enormous work capacity, commands respect, solves complex crises. Flaw: Habits of unsolicited criticism and pointing out others' faults under the guise of helping, which breeds deep resentment.
  - **Master Rule:** **நிறை கண்டால் வெற்றி, குறை கண்டால் தோல்வி!** (Acknowledge virtues = success; highlight flaws = ruin). Crow natives must strictly refrain from unsolicited fault-finding.
  - **Type 2 (Charismatic Resolute):** Highly magnetic, captivating presence. Extreme loyalty but prone to intense suspicion if betrayed. Vulnerability: Inadvertent romantic complications across age brackets due to innate charisma.
  - **Self-Correction:** Speak praise exclusively; maintain strict personal boundaries; curb obsessive investigative suspicion.
- **App-help bucket:** 🟡 App-augmentable — Daily prompt: *"Focus today on praising others; refrain from unsolicited critique."*
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Unique lineage teaching absent in standard astrological digests.
- **Rough app idea (optional):** Daily Crow notification: *"See virtues today to unlock victory."*
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 55:01 – 64:30).

#### Practice — கோழியின் 2 ஆளுமை பிரிவுகள் & 30 வருட நினைவாற்றல் மேலாண்மை (Rooster 2-Tier Psychological Archetype & 30-Year Ledger)
- **Purpose / benefit (the why):** Guides Rooster natives to release long-held emotional grudges and overcome cyclical lethargy.
- **How it's practiced (brief mechanics):**
  - **Type 1 (Quiet Ledger-Keeper):** Stoic exterior hiding an elephantine memory. Keeps decades of grievances filed away and unloads them with forensic date/time precision during marital arguments ("30 வருஷ டேட்டா!"). Experiences sudden severe fatigue after intense work bouts. Self-destructive when angry.
  - **Type 2 (Dignified Mentor):** Lineage pride, reverence for teachers, broad multi-disciplinary intellect. Mentors others effectively but risks marital discord by neglecting family priorities for external counseling.
  - **Self-Correction:** Practice emotional forgiveness; close old memory files; avoid co-signing loans or financial guarantees.
- **App-help bucket:** 🟡 App-augmentable — Journaling and emotional release tools.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Deep psychological diagnosis of the Rooster archetype.
- **Rough app idea (optional):** Periodic prompt encouraging letting go of old grievances.
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 64:31 – 73:20).

#### Practice — மயிலின் 3 ஆளுமை பிரிவுகள் & நிதி ஒழுங்குமுறை (Peacock 3-Tier Psychological Archetype & Financial Discipline)
- **Purpose / benefit (the why):** Empowers Peacock natives to conquer crippling self-doubt and establish rigorous financial management.
- **How it's practiced (brief mechanics):**
  - **Type 1 (Judicial Intellect with Self-Doubt):** Quiet, delivers courtroom-grade judgments when speaking. Reluctant to walk alone (craves companionship). Paralyzed by second-guessing in personal decisions; shuns leadership due to fear of criticism. Often survived childhood health crises.
  - **Type 2 (Dynamic Dynamo):** Firecracker energy ("பட்டாசு மாதிரி"), extraordinary rebound velocity from setbacks. Vulnerable to sabotage by close circle members. Stubborn obstinacy.
  - **Type 3 (The Serene Duck / Philanthropist):** Calm surface hiding constant mental churning ("வாத்து போல் இரு"). Multi-talented, hyper-generous, values people over money. Flaw: Chronic absence of bookkeeping, leading to wealth leakage.
  - **Self-Correction:** Step into solitary action; embrace executive leadership; enforce strict accounting for every rupee.
- **App-help bucket:** 🟡 App-augmentable — Financial tracking reminders and self-confidence affirmations.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Expands Peacock characterization far beyond classical literature.
- **Rough app idea (optional):** Budgeting prompt + independence affirmation for Peacock profiles.
- **Source ref:** 🥇 2025 Workshop Day 3 (`pp-class-03.md` @ 73:21 – 84:00).

---

### 7. பக்ஷி ஆற்றல் பெருக்கும் கருவிகள் & வாழ்வியல் பயன்பாடுகள் (Empowerment Tools & Life Applications)

#### Practice — 5 பக்ஷி மூல மந்திரங்கள் & தினசரி ஜெப எண்ணிக்கை (Root Bird Beejakshara Mantras & Daily Japa Counts)
- **Purpose / benefit (the why):** Recalibrates the internal mental frequency, infusing the natal bird with vital force, especially during Padu Pakshi or declining states.
- **How it's practiced (brief mechanics):**
  - Chanted silently or softly with internal rhythm (லயம்):
  - **வல்லூறு (34 முறை):** `ஓம் சூல பாஸ்கர ஹேம ரூப பவுமனே பார்கவாய நமோ நம நமஸ்துதே`
  - **ஆந்தை (33 முறை):** `ஓம் ஆங்கிரசாயச க்ருதாஞ்சலிகரம் சுபம் சித்ர வஸ்த்ரனே க்ருபானகம் வரதம் பீதாம்பரதரம் ஞானானந்த மயம் சுபம்`
  - **காகம் (28 முறை / வாய்மொழி வகுப்பில் தொடர் ஜெபம்):** `ஓம் வர்துலாகார மஸ்தகம் சீர் சஞ்ச வர்துலாகாரம் பூஷிதாங்கஞ்ச பீதாம்பரதரம் தேவம் க்ருதாஞ்சலி கரம் சுபம்`
  - **கோழி (36 முறை):** `ஓம் நீல ரத்ன கட்க சூல கதா பாணிம் விசித்ர மகுட பேதம் குரு சுத்தௌ பாஸ்கரம் மஹம் பஜோ`
  - **மயில் (30 முறை):** `ஓம் சந்திர பிம்பதரம் சக்தி சூல பீடம் பிரம்ம புத்ரம் கிருபா மூர்த்திம் நீலோத்பல தரம் சுபம் ஞானானந்த மயம் சுபம்`
- **App-help bucket:** 🟡 App-augmentable — In-app Japa counter with audio pronunciation guide.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Direct esoteric mantra formulas. Oral workshop suggested continuous/unlimited japa for Crow, while the Master's book explicitly fixes Crow japa at exactly 28 repetitions.
- **Rough app idea (optional):** Digital tap-counter for the prescribed daily repetitions (34, 33, 28, 36, 30).
- **Source ref:** 🥇 2025 Workshop Day 4 (`pp-class-04.md` @ 36:01 – 43:30) & 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` p. 44).

#### Practice — பக்ஷி விருட்சங்கள், அன்னங்கள் & பஞ்ச நாதங்கள் (Sacred Trees, Rice Offerings, and Pancha Nadhas)
- **Purpose / benefit (the why):** Physical and auditory grounding elements that harmonize the practitioner's biological field with their elemental bird.
- **How it's practiced (brief mechanics):**
  - **விருட்சங்கள் (Sacred Trees):** Meditating under or keeping bark/leaves of:
    * வல்லூறு: ஆலமரம் (Banyan) | ஆந்தை: நெல்லி (Amla) | காகம்: வன்னி (Vanni) | கோழி: வாதநாராயணன் (Delonix elata) | மயில்: அரசு (Peepal/Bodhi)
  - **அன்னங்கள் (Rice Offerings & Diet):** Consuming and offering to others:
    * வல்லூறு: கடுகு சாதம் (Mustard rice) | ஆந்தை: புளி சாதம் (Tamarind rice) | காகம்: உளுந்தஞ்சாதம் (Black gram rice) | கோழி: பாசிப்பயறு சாதம் (Moong dal rice) | மயில்: எள்ளஞ்சாதம் (Sesame rice)
  - **பஞ்ச நாதங்கள் (Auditory Sound Healing):** Listening to soothing tones of:
    * வல்லூறு: மத்தளம் (Maddalam / Percussion) | ஆந்தை: சங்கு நாதம் (Conch shell) | காகம்: செம்பு/பித்தளை கருவிகள் (Bell metal / Brass cymbals) | கோழி: மூங்கில் புல்லாங்குழல் (Bamboo flute) | மயில்: நரம்பு மீட்டல் கருவிகள் (Veena / String instruments)
- **App-help bucket:** 🟢 App-assistable — Audio player for meditative Pancha Nadha ambient tracks; diet suggestions on power days.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Enriches the physical correspondence catalog of Panja Pakshi.
- **Rough app idea (optional):** Background soundscape player featuring bird-specific instruments (e.g. Bamboo flute for Rooster, Veena for Peacock).
- **Source ref:** 🥇 2025 Workshop Day 4 (`pp-class-04.md` @ 43:31 – 48:40).

#### Practice — பக்ஷி கிரக நிறங்கள் & ஆடை வண்ண பயன்பாடு (Planetary Bird Colors & Chromotherapy)
- **Purpose / benefit (the why):** Uses specific color wavelengths to stimulate focus, calm emotional churn, and fortify bird authority.
- **How it's practiced (brief mechanics):**
  - Wear clothes, carry accessories (e.g. handkerchief), or meditate on these colors:
  - **வல்லூறு (Guru):** சந்தன நிறம், மஞ்சள், பொன்னிறம் / தங்கம் (Sandal, Yellow, Gold).
  - **ஆந்தை (Sukran):** வெண்மை, பளபளப்பு, வெண்பட்டு (Pure White, Silk, Shimmering textures).
  - **காகம் (Sevvai):** ஆழ்ந்த சிவப்பு, எண்ணெய் சிவப்பு, மெரூன் (Deep Red, Crimson, Maroon).
  - **கோழி (Budhan):** அனைத்து விதமான பச்சை நிறங்கள் (All shades of Green: parrot, olive, emerald, aqua).
  - **மயில் (Shani):** கருப்பு, கருநீலம் (Black, Navy Blue, Midnight Blue).
- **App-help bucket:** 🟢 App-assistable — Dynamic theme accenting based on user's birth bird and daily power colors.
- **Implemented?:** ⬜ App uses fixed palette currently.
- **Corroborates / diverges:** Diverges from static colors in `pakshi_attributes.dart` (where Vulture was black, Rooster yellow, Crow white).
- **Rough app idea (optional):** Daily color recommendation card in morning digest.
- **Source ref:** 🥇 2025 Workshop Day 5 (`pp-class-05.md` @ 03:01 – 08:30).

#### Practice — பக்ஷி முறைப்படி திருமண வரன் & காதல் பொருத்தம் (Matrimonial & Relationship Compatibility via Bird Kinship)
- **Purpose / benefit (the why):** Evaluates marital and romantic harmony without requiring complex 10-porutham astrological charts.
- **How it's practiced (brief mechanics):**
  - **Enemy Birds (பகை பக்ஷி வரன்):** Highly discouraged for marriage. Inherent clash in psychological temperament, communication friction, and ego collisions (e.g. Ashwini Vulture with Anuradha Rooster = mutual enemies in both moon phases).
  - **Neutral Birds (சராசரி பக்ஷி வரன்):** Utilitarian, moderate harmony; requires conscious effort and compromise.
  - **Friendly Birds (நட்பு பக்ஷி வரன்):** Ideal marital compatibility. Spontaneous understanding, enduring mutual respect, and emotional warmth (e.g. Vulture with Peacock).
- **App-help bucket:** 🟢 App-assistable — Bird-based matrimonial matching calculator.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Pure Panja Pakshi compatibility paradigm independent of conventional Gana/Rasi poruthams.
- **Rough app idea (optional):** "Relationship Compatibility" feature comparing two users' birth stars.
- **Source ref:** 🥇 2025 Workshop Day 5 (`pp-class-05.md` @ 16:16 – 28:00).

#### Practice — தங்கம், ஆபரணம் & புத்தாடை வாங்கும் சுபநேர விதி (Muhurtam for Purchasing Gold, Jewelry & Luxury Garments)
- **Purpose / benefit (the why):** Ensures purchased gold, jewelry, and luxury assets stay permanently in the household and multiply, rather than being pawned or lost to debts.
- **How it's practiced (brief mechanics):**
  - **Favorable Days:** ஞாயிறு (Sunday), திங்கள் (Monday), புதன் (Wednesday), வியாழன் (Thursday), வெள்ளி (Friday).
  - **Favorable Hours:** Execute purchase exclusively during your bird's **அரசு (Ruling)** or **ஊண் (Eating)** yamas.
  - **Hora Alignment:** Choose an hour where the active Hora is **சூரியன், சந்திரன், புதன், குரு, or சுக்கிரன்**.
  - Combining bird Ruling/Eating with auspicious Horas guarantees enduring domestic prosperity.
- **App-help bucket:** 🟢 App-assistable — Auspicious Gold/Jewelry Muhurtam Finder.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Integrates bird states with classical planetary hora electional rules.
- **Rough app idea (optional):** "Auspicious Purchase Finder" filtering days for Gold / Vehicle / Real Estate buying.
- **Source ref:** 🥇 2025 Workshop Day 5 (`pp-class-05.md` @ 28:01 – 32:30).

---

### 8. நூல் சார்ந்த தனித்துவப் பிரயோகங்கள், வாஸ்து & தன வசிய தாந்த்ரீகம் (Book-Exclusive Esoteric Practices, Vastu & Wealth Tantra)

#### Practice — திதி & லக்ன/ராசி பக்ஷி நிர்ணய முறை (Tithi & Lagna/Rasi Bird Determination)
- **Purpose / benefit (the why):** Determines operative bird energy when birth star is unavailable, or for horary divination (பிரசன்னம்) and daily ritual election.
- **How it's practiced (brief mechanics):**
  - **திதி பக்ஷி (Tithi Pakshi - Book pp. 19–20):**
    * வளர்பிறை (Shukla): பிரதமை–திரிதியை = வல்லூறு | சதுர்த்தி–சஷ்டி = ஆந்தை | சப்தமி–நவமி = காகம் | தசமி–துவாதசி = கோழி | திரயோதசி–பௌர்ணமி = மயில்.
    * தேய்பிறை (Krishna): பிரதமை–திரிதியை = மயில் | சதுர்த்தி–சஷ்டி = கோழி | சப்தமி–நவமி = காகம் | தசமி–துவாதசி = ஆந்தை | திரயோதசி–அமாவாசை = வல்லூறு.
  - **லக்ன / இராசி பக்ஷி (Lagna / Rasi Pakshi - Book p. 21):**
    * மேஷம், விருச்சிகம் (Mars): காகம் (Fire)
    * ரிஷபம், துலாம் (Venus): ஆந்தை (Water)
    * மிதுனம், கன்னி (Mercury): கோழி (Air)
    * தனுசு, மீனம் (Jupiter): வல்லூறு (Earth)
    * மகரம், கும்பம் (Saturn): மயில் (Ether)
    * கடகம் (Moon) & சிம்மம் (Sun): Aligned by elemental triplicity / tatva in horary judgment.
- **App-help bucket:** 🟢 App-assistable — Alternate bird derivation selector and horary/Prasanna chart calculator.
- **Implemented?:** ⬜ Current app only supports Nakshatra and Name Initial derivation.
- **Corroborates / diverges:** Expands the input modalities of the engine beyond Janma Nakshatra and Nama initial.
- **Rough app idea (optional):** "Prasanna Bird Mode" calculating instant Tithi/Lagna bird for horary inquiries.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 19–21).

#### Practice — பக்ஷி 40+ தத்துவ காரகங்கள் & பஞ்ச பிராண விரிவு (Comprehensive 40+ Karakatvas & Pancha Prana Matrix)
- **Purpose / benefit (the why):** Maps human psychosomatic architecture, organs, elements, deities, and subtle pranas to the 5 birds, enabling precise diagnostic and remedial applications.
- **How it's practiced (brief mechanics):**
  - Meditate on or align actions with the multi-dimensional correspondence grid (Book pp. 31–40):
    * **வல்லூறு (Earth / நிலம் / பிரித்வி):** பிரம்மா | இச்சா சக்தி | ரிக் வேதம் | சாந்த குணம் | நாசி / வாசனை | சுவை: இனிப்பு | தாது: மாமிசம்/சதை | பிராணன்: பிராணன் & நாகன் | கோசம்: அன்னமய கோசம் | சிவ முகம்: சத்யோஜாதம் | பீஜம்: 'ந' (Panchakshara 108 japa).
    * **ஆந்தை (Water / நீர் / அப்பு):** விஷ்ணு | கிரியா சக்தி | யஜுர் வேதம் | சாத்வீக குணம் | நாக்கு / சுவை | சுவை: துவர்ப்பு | தாது: இரத்தம்/சுக்கிலம் | பிராணன்: அபானன் & கூர்மன் | கோசம்: பிராணமய கோசம் | சிவ முகம்: வாமதேவம் | பீஜம்: 'ம' (Panchakshara 108 japa).
    * **காகம் (Fire / நெருப்பு / தேயு):** ருத்ரன் | ஞான சக்தி | சாம வேதம் | தாமஸ குணம் | கண் / பார்வை | சுவை: கார்ப்பு | தாது: மச்சை/எலும்பு | பிராணன்: வியானன் & கிருகரன் | கோசம்: மனோமய கோசம் | சிவ முகம்: அகோரம் | பீஜம்: 'சி' (Panchakshara 108 japa).
    * **கோழி (Air / காற்று / வாயு):** மகேஸ்வரன் | ஆதி சக்தி | அதர்வண வேதம் | ரஜோ குணம் | தோல் / தொடுஉணர்வு | சுவை: கசப்பு/புளிப்பு | தாது: தோல்/நரம்பு | பிராணன்: உதானன் & தேவதத்தன் | கோசம்: விஞ்ஞானமய கோசம் | சிவ முகம்: தத்புருஷம் | பீஜம்: 'வா' (Panchakshara 108 japa).
    * **மயில் (Ether / ஆகாயம் / ஆகாசம்):** சதாசிவன் | பரா சக்தி | பிரணவ வேதம் | நிர்குண தத்துவம் | செவி / ஒலி | சுவை: உவர்ப்பு | தாது: சுக்கிலம்/ஜீவன் | பிராணன்: சமானன் & தனஞ்சயன் | கோசம்: ஆனந்தமய கோசம் | சிவ முகம்: ஈசானம் | பீஜம்: 'ய' (Panchakshara 108 japa).
- **App-help bucket:** 🟢 App-assistable — Interactive multi-dimensional correspondence lookup table.
- **Implemented?:** ⬜ Partially shipped in static `pakshi_attributes.dart` (limited to 6 attributes).
- **Corroborates / diverges:** Vastly enriches attributes; corroborates workshop oral teaching with codified lineage charts.
- **Rough app idea (optional):** Deep-dive "Bird Profile Anatomy" tab revealing esoteric tatvas, chakras, deities, and pranas.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 31–40).

#### Practice — சண்முக எந்திரம் & 1008 உருவேற்றும் சித்தி முறை (Shanmukha Yantra Consecration & 1008 Siddhi Attainment)
- **Purpose / benefit (the why):** Consecrates the bird's occult geometric circuit (Shanmukha / Shatkona Yantra) onto metal to achieve Siddhi (mastery) over the 5 bird energies.
- **How it's practiced (brief mechanics):**
  - Engrave or draw the Shanmukha Yantra (six-pointed star / Hexagram) on a copper or silver plate (Book pp. 16–18).
  - Inscribe the bird's presiding Panchakshara letter (`ந`, `ம`, `சி`, `வா`, `ய`) in the central bindu and petals.
  - Sit facing your bird's cardinal direction on an auspicious ruling day during the bird's **அரசு (Ruling)** yama.
  - Light a pure ghee lamp, offer the prescribed bird flower/incense, and chant the natal root mantra for exactly **1008 repetitions**.
  - Wear or place in the altar; serves as a perpetual bio-magnetic amplifier shield.
- **App-help bucket:** 🟡 App-augmentable — Yantra visualization diagrams, step-by-step consecration checklist, and 1008-japa digital counter.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Direct esoteric siddhi practice specific to this master's lineage.
- **Rough app idea (optional):** "Yantra Siddhi Guide" showing printable yantra geometry and 1008-mala timer.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 16–18).

#### Practice — பக்ஷி மூலிகைகள், எந்திரங்கள் & பஞ்ச மண் பரிகாரம் (Bird Herbs, Yantras & Sacred Soil Remedies)
- **Purpose / benefit (the why):** Remedial botanical, yantric, and telluric interventions to repair damaged bio-fields and neutralize karmic afflictions.
- **How it's practiced (brief mechanics):**
  - **Mooligai (Herbs) & Presiding Yantras (Book pp. 41–42):**
    * **வளர்பிறை (Shukla):**
      - வல்லூறு: அரைக்கீரை (Herbal intake/talisman) | பிரம்ம கணபதி எந்திரம் (Brahma Ganapati Yantra).
      - ஆந்தை: சிறுகீரை | சுதர்சன எந்திரம் (Sudarshana Yantra).
      - காகம்: சாரணை | ஏரொளி எந்திரம் (Eroli Yantra).
      - கோழி: தகரை | சரவணபவ சட்கோண எந்திரம் (Saravanabhava Shatkona Yantra).
      - மயில்: மாங்குலியம் | மச்ச எந்திரம் (Macha Yantra).
    * **தேய்பிறை (Krishna):**
      - மயில்: நாய்க்கடுகு | வித்யா எந்திரம் (Vidya Yantra).
      - கோழி: அரைக்கீரை | லட்சுமி குபேர எந்திரம் (Lakshmi Kubera Yantra).
      - காகம்: அவுரி | சிதம்பர சக்கரம் (Chidambara Chakra).
      - ஆந்தை: குப்பைமேனி | சக்தி எந்திரம் (Shakti Yantra).
      - வல்லூறு: தாயிரேகை | சிதம்பர சக்கரம் (Chidambara Chakra).
  - **பஞ்ச மண் (Five Sacred Soils - p. 43):**
    * வல்லூறு (Earth): காளையின் கொம்பிலுள்ள மண் (Soil from a bull's horn).
    * ஆந்தை (Water): கடல் மண் (Sea sand / ocean sediment).
    * காகம் (Fire): மலை மண் (Mountain peak soil / rock dust).
    * கோழி (Air): குளத்தின் மண் (Lake/pond bed mud).
    * மயில் (Ether): சிவாலயத்திலுள்ள மண் (Soil from a Shiva temple sanctum/compound).
- **App-help bucket:** 🟡 App-augmentable — Herbal identification guides and remedy instructions.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Precise esoteric herb and yantra linkages recorded in the authoritative written text.
- **Rough app idea (optional):** "Botanical & Yantric Remedies" catalog indexed by bird and moon phase.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 41–43).

#### Practice — பக்ஷி தொழில் & வாழ்வியல் வழிகாட்டல் (Vocational Guidance & Occupational Alignment)
- **Purpose / benefit (the why):** Directs native toward vocations and industries aligned with their bird's innate elemental nature, maximizing effortless professional success and financial flow.
- **How it's practiced (brief mechanics):**
  - Select career paths corresponding to bird elemental rulership (Book pp. 22–25):
    * **வல்லூறு (Earth):** ரியல் எஸ்டேட், நிலம், விவசாயம், சுரங்கம், சிவில் இன்ஜினியரிங், கட்டுமான ஒப்பந்தங்கள், மண்பாண்டங்கள், செங்கல் உற்பத்தி, உணவு தானிய வர்த்தகம் (Real estate, land, farming, mining, civil engineering, construction contracting, brick production, grain commerce).
    * **ஆந்தை (Water):** கப்பல் போக்குவரத்து, கடல்சார் தொழில், மீன்வளம், இரசாயனம், மருத்துவம், மருந்தகம், பால் பண்ணை, திரவ வர்த்தகம், வாசனை திரவியங்கள் (Shipping, marine trades, fisheries, chemicals, medicine, pharmacy, dairy farming, beverage trade, perfumery).
    * **காகம் (Fire):** மெக்கானிக்கல் இன்ஜினியரிங், மின்சாரம், எலக்ட்ரானிக்ஸ், ராணுவம், காவல் துறை, சமையல் கலை, ஹோட்டல் தொழில், தீயணைப்பு, உலோகத் தொழில், எரிபொருள் வர்த்தகம் (Mechanical engineering, electrical/electronics, defense, police, culinary arts, hospitality, metal smelting, energy/fuels).
    * **கோழி (Air):** விமானப் போக்குவரத்து, தபால்/கொரியர், தகவல் தொடர்பு, பத்திரிகை, ஊடகம், தகவல் தொழில்நுட்பம் (IT), தரகு வர்த்தகம், எழுத்தாளர், பேச்சாளர், கணக்காளர் (Aviation, logistics/courier, telecommunications, journalism, media, IT, brokerage, writing, public speaking, auditing).
    * **மயில் (Ether):** நீதித்துறை, வக்கீல், நீதிபதி, அரசு நிர்வாகம், உயர் அரசியல், ஜோதிடம், ஆன்மீக குரு, ஆராய்ச்சி, வேதாந்தம், கோயில் பணிகள், கலைகள் (Judiciary, advocacy, magistrates, civil service administration, high-level politics, astrology, spiritual teaching, philosophical research, temple administration, fine arts).
- **App-help bucket:** 🟢 App-assistable — Career alignment assessment module in user profile.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Standardizes vocational correspondences across classical elemental categories.
- **Rough app idea (optional):** "Vocation & Career Alignment" analysis in Natal Bird dashboard.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 22–25).

#### Practice — பக்ஷி உடல் பலவீனங்கள் & நோயியல் தற்காப்பு (Physical Vulnerabilities & Health Preservation — 🔴 Document-Only)
- **Purpose / benefit (the why):** Non-diagnostic, classical anatomical mapping highlighting bodily organs and physiological systems sensitive to elemental imbalances.
- **How it's practiced (brief mechanics):**
  - Awareness of congenital physical vulnerabilities (Book pp. 26–28):
    * **வல்லூறு (Earth):** எலும்பு முறிவுகள், மூட்டு வலிகள், பற்கள், தசைக் கட்டிகள், தசை நாண்கள், உடல் பருமன் (Bones, skeletal system, joints, teeth, muscular stiffness, obesity).
    * **ஆந்தை (Water):** சளி, கபம், சைனஸ், சிறுநீரகம், நீரிழிவு, இரத்த ஓட்டக் கோளாறுகள், நீர்ச்சத்து குறைபாடு (Phlegm/Kapha, sinus congestion, kidneys, urinary system, diabetes, circulatory disorders).
    * **காகம் (Fire):** பித்தம், அல்சர், இரத்த அழுத்தம் (BP), கண் கோளாறுகள், தலைவலி, தோல் எரிச்சல், விபத்து காயங்கள் (Pitta disorders, gastric ulcers, hypertension, ophthalmic issues, migraine, skin rashes, burn injuries).
    * **கோழி (Air):** வாயு தொல்லை, பக்கவாதம், நரம்புத் தளர்ச்சி, மூச்சுக்குழாய் அழற்சி, ஆஸ்துமா, குடல் புழுக்கள் (Vata ailments, neurological disorders, tremors, bronchitis, asthma, digestive spasms).
    * **மயில் (Ether):** மன அழுத்தம், தூக்கமின்மை, மூளை நரம்பு பாதிப்பு, காது கேளாமை, வலிப்பு, காரணமற்ற அச்சம் (Mental depression, insomnia, cerebral disorders, hearing impairments, epilepsy, unexplained psychosomatic anxieties).
  - Remediation: Strict avoidance of surgeries and risky treatments during bird **துயில் (Sleeping)** and **சாவு (Dying)** periods; strengthen through pranayama and diet.
- **App-help bucket:** 🔴 Self-achieved / document-only — Sensitive physiological and medical content; non-directive reference only.
- **Implemented?:** ⬜ Strictly excluded from automated algorithmic diagnosis.
- **Corroborates / diverges:** Deepens classical Ayur-Pakshi diagnostic framework.
- **Rough app idea (optional):** Knowledge-only reference article on bird physical constitution.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 26–28).

#### Practice — மனையடி சாஸ்திரம் & பக்ஷி முகூர்த்தம் (House Foundation, Construction & Grihapravesha Muhurtham)
- **Purpose / benefit (the why):** Guarantees longevity, peace, wealth, and freedom from ancestral/structural defects when laying foundation stones or moving into residential properties.
- **How it's practiced (brief mechanics):**
  - **நட்சத்திர பக்ஷி அதிகார நாள் (Ruling Power Day):** Lay foundation (கால் போடுதல்) or perform Grihapravesha on a day when the owner's birth bird is in sovereign power (Book pp. 50–52):
    1. **அரசு–அரசு (Ruling sub-ruling Ruling):** House stands strong for **1000 years**. Unprecedented quad-directional fame, luxury vehicles, and flourishing generations.
    2. **அரசு–ஊண் (Eating sub-ruling Ruling):** House stands strong for **600 years**.
    3. **ஊண்–அரசு (Ruling sub-ruling Eating):** House stands strong for **800 years**.
    4. **ஊண்–ஊண் (Eating sub-ruling Eating):** House stands strong for **200 years**.
  - **Strict Prohibition:** Never lay foundation or move in during **படுபக்ஷி (Padu Pakshi)** or **தன்ய (Shunya) days**, regardless of whether it is a designated Vastu day.
  - **Orientation Rule:** Regardless of plot entrance direction, face the practitioner's bird's cardinal direction during the preliminary Bhumi Puja.
  - **Rental Property Entry (வாடகை வீடு நிவாரணம்):** For individuals trapped in hardship, moving into a rented house during an aligned bird power window (Arasu-Arasu / Arasu-Oon / Oon-Arasu with Chandra & Tara Balam) neutralizes existing structural Vastu doshas and black magic/evil eye afflictions, rapidly paving the path to owning their own home.
- **App-help bucket:** 🟢 App-assistable — Construction & Grihapravesha Muhurtham Calculator.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Groundbreaking integration of micro-yama Pakshi dynamics with civil architectural foundations.
- **Rough app idea (optional):** "Vastu & Foundation Muhurtham Planner" highlighting 1000-year and 800-year structural windows.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 50–52).

#### Practice — வாஸ்து பஞ்சபூத தோஷ நிவர்த்தி பரிகாரம் (Pancha Bhoota Vastu Remediation with Sacred Soils & Mantras)
- **Purpose / benefit (the why):** Remedies architectural corner cuts and irregular plot angles without requiring structural demolition, neutralizing domestic discord and stagnancy.
- **How it's practiced (brief mechanics):**
  - Maintain 90-degree angular integrity across four directional corners (Book pp. 52–53):
    * தென்மேற்கு (நிருதி / நிலம்): South-West / Earth
    * வடகிழக்கு (ஈசானியம் / நீர்): North-East / Water
    * தென்கிழக்கு (அக்னி / நெருப்பு): South-East / Fire
    * வடமேற்கு (வாயு / காற்று): North-West / Air
    * பிரம்மபாகம் (மத்தி / ஆகாயம்): Central Void / Ether
  - For houses with cut corners (வெட்டுப்பட்ட மூலைகள்), execute elemental soil burying and mantra japa on prescribed weekdays:
    * **நிலம் (நிருதி):** செவ்வாய் (Tuesday) | ஓம் நமசிவாய (108 முறை) | யானை காலடி மண் (90g).
    * **நீர் (ஈசானியம்):** புதன் (Wednesday) | ஓம் மசிவாயந (108 முறை) | குளத்து மண் (110g).
    * **நெருப்பு (அக்னி):** வியாழன் (Thursday) | ஓம் சிவாயநம (108 முறை) | சுண்ணாம்பு சூலை மண் (40g).
    * **காற்று (வாயு):** வெள்ளி (Friday) | ஓம் வாயநமசி (108 முறை) | புற்று மண் (150g).
    * **ஆகாயம் (பிரம்மபாகம்):** சனி (Saturday) | ஓம் யநமசிவா (108 முறை) | கடல் மண் (120g).
- **App-help bucket:** 🟡 App-augmentable — Step-by-step Vastu soil remediation checklist with calendar schedule.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Rare Siddha architectural alchemy combining geometric soil grams with cyclic Panchakshara permutations.
- **Rough app idea (optional):** "Vastu Defect Remediation Assistant" tracking soil procurement and 108-japa days.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 52–53).

#### Practice — ஆரா ஹீலிங், திருஷ்டி கழித்தல் & எதிர்மறை ஆற்றல் சுத்திகரிப்பு (Aura Healing & Negative Energy Cleansing)
- **Purpose / benefit (the why):** Cleanses the human bio-field (Aura) of evil eye (கண்திருஷ்டி), psychic debris, black magic vibrations, and chronic lethargy, restoring vibrant vital radiance.
- **How it's practiced (brief mechanics):**
  - Age-stratified physical purification rituals (Book p. 54):
    * **பெரியவர்கள் (Adults):** Apply Panchagavya on scalp, take a bath. On Friday, purchase a solid chunk of படிகாரம் (Alum), wave around head clockwise, and cast into glowing embers while chanting:
      `ஓம் சவ்வும் போதானந்தமா நில்லு நில்லு சுவாஹா` (until the alum melts completely).
    * **இளைஞர்கள் (Youths):** Place sacred cow dung (பசுஞ்சாணம்) on the crown chakra for 3 consecutive days prior to bathing. While fumigating with Sambrani (benzoin dhoop), chant 16 times:
      `ஓம் ஆம் க்லீம் ஸர்வசக்தி கணாதீச மாம் ரக்ஷ ரக்ஷ மம ஸான்னித்யம் குரு குரு அனுகிரக சுவாஹா`.
    * **குழந்தைகள் (Children):** Bathe in water mixed with Gomayam (cow urine) for 3 days. While fumigating with Sambrani, chant 8 times:
      `ஓம் ஹ்ரீம் கம் ஹ்ரீம் தும் துர்காபுத்ராய சக்தி ஹஸ்தாய மாத்ருவத்ஸலாய மஹா கணபதயே நம`.
- **App-help bucket:** 🟡 App-augmentable — Aura healing ritual instructions and mantra audio player.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Classical lineage purification protocol combining organic alchemical elements with protective mantras.
- **Rough app idea (optional):** Aura Cleansing reminder for New Moon / Friday evenings.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` p. 54).

#### Practice — இராசி வாரியாக பணம் எண்ணும் முறை & குபேர வசிய தாந்த்ரீகம் (Rasi-Based Money Counting Rituals & Wealth Attraction)
- **Purpose / benefit (the why):** Establishes psychological and energetic reverence towards currency notes, eliminating poverty consciousness and creating perpetual financial magnetism (குபேர வசியம்).
- **How it's practiced (brief mechanics):**
  - Grouped by zodiac triplicity / mobility (Book pp. 55–57):
    * **சர இராசிகள் (Chara Rasis — மேஷம், கடகம், துலாம், மகரம்):**
      - Direction: Face North (வடக்கு).
      - Asana: Sit on white silk cloth (வெண்பட்டு துணி).
      - Action: Blow on left palm 3 times, chant "ஓம்" 3 times.
      - Before counting (3 times): `ஓம் சரமாதா ஜோதிர் ஸ்ரீம் அதியோக கர வசி வசியூம் ஐம் ஸ்ரீம் சுவாஹா`.
      - When placing cash (3 times): `ஓம் யக்க ராஜ நிரந்தர வாச அனுகிரக வர வரத சித்திரஸ்து`.
      - Cash box sachet: Wrap Lotus petals (தாமரை இதழ்), poolankizhangu (பூலாங்கிழங்கு), and neeradimuthu or karboga rice in yellow cloth; place with cash.
    * **ஸ்திர இராசிகள் (Sthira Rasis — ரிஷபம், சிம்மம், விருச்சிகம், கும்பம்):**
      - Direction: Face East (கிழக்கு).
      - Rules: Never count while standing, chewing food, or moistening fingers with saliva.
      - Action: Chant "ஓம்" 3 times, then chant (3 times): `ஓம் ஸ்திர ராஜாய வசியூம் தன மாதாய ஐம் ஸ்ரீம் ஹ்ரீம் பூர் வசி வசி ஸ்வாஹா`.
      - When placing cash (5 times): `ஓம் பானு பாசுவர பூர்புவ ஸ்வாஹா நிரந்தர தனவாச அனுகிரக தயாபரா இரட்சகம் நமாம்யகம்`.
      - Cash box sachet: Bundle valampuri/edampuri shells and sunflower seeds.
    * **உபய இராசிகள் (Ubhaya Rasis — மிதுனம், கன்னி, தனுசு, மீனம்):**
      - Direction: Face West (மேற்கு).
      - Asana: Sit on blue cloth (நீல நிற துணி); mind free of anxiety.
      - Action: Rub hands 3 times, place left hand down and right hand on top, chant "ஓம்" 5 times, blow on hands.
      - Chant before counting (3 times): `ஓம் உபயராஜ உப தேவதாப்யோ தன ஐம் ஸ்ரீம் வசி ஸ்வாஹா`.
      - Sachet: Nayuruvi root (நாயுருவி வேர்), kasturi turmeric (கஸ்தூரி மஞ்சள்), athimadhuram (அதிமதுரம் 1 துண்டு) bundled in yellow cloth with 1 chant of: `ஓம் ஸ்ரீம் ஸ்ரீம் ஐம் ஸ்ரீம் அதியோக விருட்ச தன சித்தினே நமஸ்துப்யம்`.
- **App-help bucket:** 🟢 App-assistable — Personalized Money Protocol Card based on user's Moon/Ascendant sign.
- **Implemented?:** ⬜ Not yet implemented.
- **Corroborates / diverges:** Unique tantric wealth preservation protocol codified in the master's text.
- **Rough app idea (optional):** "Prosperity Ritual Guide" in Financial Astrology section.
- **Source ref:** 🥇 Master's 56-page book (`panja_pakashi_aarudan.pdf` pp. 55–57).

---
