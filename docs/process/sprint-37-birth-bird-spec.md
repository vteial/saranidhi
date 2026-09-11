[← Back to Sprint Tracker](sprint-tracker.md)

# Sprint 37 — Birth-Bird Engine Correction (v1.7.0) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup** (Saranidhi local dev
> = pure Antigravity IDE on the owner's Mac). Implement with local `flutter analyze` +
> `flutter test` GREEN before opening the PR (core-calc change → CI-only is not
> sufficient, per the v1.2.1 lesson). Kiro Web reviews the PR. All doctrine here is
> **owner-confirmed** via CONF-PP-001…005 in
> [`docs/research/panja-pakshi-workshop-knowledge.md`](../research/panja-pakshi-workshop-knowledge.md).

## 0. Prerequisite — environment + known-GREEN baseline (do FIRST)

- **Working Flutter toolchain** per [`docs/process/dev-setup.md`](dev-setup.md)
  (macOS: Flutter stable ≥3.44 / Dart ≥3.12.1). One-time per machine — this spec does
  NOT repeat setup; follow that doc if anything is missing.
- **Pre-flight (before touching any Sprint 37 code)** — establish a known-green baseline
  so we never change a core calc on top of an already-red suite (v1.2.1 lesson):
  ```bash
  flutter --version          # confirm stable ≥3.44 / Dart ≥3.12.1
  flutter doctor -v          # env sane (Chrome for web, etc.)
  flutter pub get            # deps + codegen
  flutter analyze            # expect: no issues
  flutter test               # expect: all passing (this is the baseline to protect)
  ```
  If `analyze`/`test` are NOT already green on a clean `main` checkout, STOP and report
  it before starting — the birth-bird change must build on a green baseline.

## 1. Why (the bug)

The shipped `PakshiCalculator` derives the birth bird from a **Pulippani 5-5-5-5-7**
nakshatra partition and a **dual bright/dark table** (Krishna births read a reversed
"dark" table). The lineage-unanimous truth (2025 workshop + master's 56-pg book p.7 +
1930 *Pancha Pakshi Rathinam* pp.46–47) is **5-6-5-5-6** with a **single permanent
birth-star table**. Consequence: users born under **Pooram / Visakam / Uthiradam**, and
**all Krishna-paksha births**, can get the WRONG bird — which cascades into every state,
yama, and oracle result. Verified: owner (Pushya, Krishna) is mis-computed as **Cock**;
correct is **Owl**.

Authority: recorded workshop video + master's book + classical texts **override** the
modern secondary source (Pulippani/vedastro). Owner adjudicated.

## 2. Task 37.1 — Nakshatra partition → 5-6-5-5-6

**File:** `lib/features/astro_engine/domain/pakshi_calculator.dart` (bright sets ~l.619–659).

The **single permanent (bright) table** becomes:

| Bird | Nakshatras (canonical 5-6-5-5-6) | Count |
|------|----------------------------------|:-----:|
| **Vulture** (Earth) | Ashwini, Bharani, Krittika, Rohini, Mrigashira | 5 |
| **Owl** (Water) | Ardra, Punarvasu, Pushya, Ashlesha, Magha, **Purva Phalguni (Pooram)** | 6 |
| **Crow** (Fire) | Uttara Phalguni, Hasta, Chitra, Swati, **Vishakha (Visakam)** | 5 |
| **Rooster/Cock** (Air) | Anuradha, Jyeshtha, Mula, Purva Ashadha, **Uttara Ashadha (Uthiradam)** | 5 |
| **Peacock** (Ether) | Shravana, Dhanishta, Shatabhisha, Purva Bhadrapada, Uttara Bhadrapada, Revati | 6 |

**The 3 stars that move vs shipped:**
- **Purva Phalguni (Pooram):** Crow → **Owl**
- **Vishakha (Visakam):** Rooster → **Crow**
- **Uttara Ashadha (Uthiradam):** Peacock → **Rooster**

(Sum = 5+6+5+5+6 = 27. Cross-check: Murugan's Visakam is Crow/Fire — internal corroboration.)

## 3. Task 37.2 — Single permanent birth-star table (no Krishna swap)

**File:** same, `birthBirdFromNakshatraAndPaksha` (~l.577–585) + the dark sets (~l.664–704).

- The **known-birth-star path must ignore `birthPaksha`** and always use the single 5-6-5-5-6 table above. Per lineage: *"ஜென்ம நட்சத்திரம் தெரிஞ்சவங்க தேய்பிறையை பயன்படுத்த வேண்டாம், வளர்பிறை மட்டும் பயன்படுத்தினா போதும்"* (workshop @33:00; master book p.8; *Rathinam* provides only one star table).
- **Options for the code shape** (implementer's choice, keep it clean):
  - (a) Keep `birthBirdFromNakshatraAndPaksha(nakshatra, paksha)` signature for call-site compatibility but have it ignore `paksha` and delegate to the single-table lookup; **or**
  - (b) Make `birthBirdFromNakshatra(nakshatra)` (single table) the canonical entry and update call sites; deprecate the paksha variant.
- **Delete or clearly retire the `_dark* ` reversed sets** for the birth-star path (they must not be consulted for a known birth star). If retained for reference, they must be unreachable from the birth-star derivation.
- `birthBirdFromNakshatraSafe` already used bright-only — it becomes the correct behavior; keep it.

## 4. Task 37.3 — Name-initial fallback carries the paksha swap

**File:** `lib/features/astro_engine/domain/name_bird_parser.dart` (currently first-vowel→bird, no paksha, not wired into save flow).

- The **waxing/waning bird swap applies ONLY to the name-initial (Nama Pakshi) path** (used when BOTH birth star and DOB are unknown). Per lineage: name-initial users get one bird for Valarpirai and a different bird for Theipirai.
- Add `birthBirdFromNameInitialAndPaksha(String initialLetter, LunarPhase currentPaksha)`:
  1. Map the first vowel → element → base (Valarpirai) bird (existing `NameBirdParser` logic).
  2. If current paksha is Theipirai (waning), apply the name-path swap (define the swap mapping from the corpus / classical name-Pakshi table — verify against `pp-class-01.md` @34:00–46:00 and master book p.8; document the exact swap pairs in the PR).
- Wire it as the **tertiary fallback** in the onboarding/profile derivation (nakshatra → DOB-derived nakshatra → name-initial). Confirm the actual current fallback order in `onboarding_providers.dart` before wiring.

## 5. Task 37.4 — Existing-user re-migration (ALL affected users)

**Files:** `lib/features/onboarding/domain/bird_migration_service.dart` (+ its test).

- The on-load `BirdMigrationService.recalculateIfNeeded()` is already wired (provider + `BirdMigrationOnLoadWidget` in `main.dart`) and re-derives DOB-based profiles. After the table change it will **auto-correct DOB users** on next app open. ✅
- **Owner decision — extend it to manual "known-star / no-DOB" profiles too:** currently it skips profiles lacking `birthDateEpoch`. Change it so a profile with `birthStarNakshatra` (even without DOB) is **also re-derived** via the corrected single table and updated if the stored `birthBird` differs. (The old bright-only bird for these users may be wrong under 5-6-5-5-6.)
- Preserve idempotency (no-op when already correct) and the one-time SnackBar UX.
- **Regression tests (extend `bird_migration_service_test.dart`):**
  - DOB profile with old bird (e.g. Pushya/Krishna stored "cock") → corrected to **owl** on load.
  - Manual/no-DOB profile with an affected star (e.g. Pooram stored "crow") → corrected to **owl**.
  - Already-correct profile → unchanged (idempotent).
  - Empty DB / no profile → no-op.

## 6. Tasks 37.5–37.7 — Bird attribute corrections

**File:** `lib/features/astro_engine/domain/pakshi_attributes.dart` (`_attributes` map ~l.197–254).

**CONF-PP-004 — ruling planets:**

| Bird | Shipped (wrong) | Correct |
|------|-----------------|---------|
| Vulture | Saturn | **Jupiter (Guru)** |
| Owl | Mars | **Venus (Sukran)** |
| Crow | Venus | **Mars (Sevvai)** |
| Rooster | Jupiter | **Mercury (Budhan)** |
| Peacock | Mercury | **Saturn (Shani)** |

Update the `PakshiPlanet` enum usage + any colour associations that derive from planet.

**CONF-PP-003 — friend/enemy (unified, no phase split):**

| Bird | Friends | Enemies |
|------|---------|---------|
| Vulture | **Peacock, Owl** | **Crow, Rooster** |
| (Vulture↔Peacock = permanent ally; Vulture↔Rooster = permanent enemy) | | |

> Implementer: derive the full 5-bird friend/enemy matrix from workshop Day 3
> (`pp-class-03.md` @02:46) + *Rathinam* p.46, and list the complete corrected table
> in the PR description for owner review. The row above is the anchor/known-correct case.

**CONF-PP-005 — cardinal directions (phase-dependent):**

| Bird | Valarpirai (waxing) | Theipirai (waning) |
|------|--------------------|--------------------|
| Vulture | East | East |
| Owl | South | North |
| Crow | West | South |
| Rooster | North | Center |
| Peacock | Sky/Center | West |

Direction becomes a function of `(bird, paksha)` rather than a static field; feeds the tactical/compass feature.

## 7. Task 37.8 — Tests & docs

- **Update** to the corrected values: `test/features/astro_engine/pakshi_calculator_test.dart` (encodes 5-5-5-5-7 today), `pakshi_attributes_test.dart`, `test/features/onboarding/onboarding_test.dart`.
- **Add** explicit cases: Pooram→Owl, Visakam→Crow, Uthiradam→Rooster; owner's **Pushya + Krishna → Owl** (was Cock).
- `test/widget_test.dart` overrides `birdMigrationProvider` to `noChange` — keep, or update if signature changes.
- **Docs:** rewrite `docs/research/calculation-methodology.md` §1 to the 5-6-5-5-6 single-permanent-table model; cross-link CONF-PP-001…005; update the birth-bird section of `docs/product/user-guide.md` (note existing users may see a one-time corrected bird).

## 8. Out of scope (this sprint)

- **CONF-PP-006** (equal vs classical-weighted sub-yama durations + settings toggle) — a new user option, deferred to a later sprint.
- The broader **Accuracy & Validation** 7-day 3-way comparison (separate backlog epic; needs owner data collection). This sprint is the *correction*; the *validation gate* comes after.

## 9. Definition of Done

See the Sprint 37 Delivery Checklist in [`sprint-tracker.md`](sprint-tracker.md). Key gate:
**local `flutter analyze` clean + full `flutter test` green BEFORE the PR**, and the
existing-user upgrade path tested explicitly (not just fresh onboarding).
