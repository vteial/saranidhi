# Astro Engine Golden Fixture Dataset

> Canonical path: `test/golden/README.md`  
> Governed by: [`.kiro/specs/golden-fixture-gate/requirements.md`](../../.kiro/specs/golden-fixture-gate/requirements.md) (`TSK-golden-01`)

This directory contains the frozen, path-independent correctness dataset for Saranidhi's astronomical and astrological calculation engines (`lib/features/astro_engine/domain/`).

## Provenance & Purpose

Saranidhi's core value is calculation correctness (Jean Meeus Moon longitude + Lahiri Ayanamsa → birth star → birth bird; the Swara clock; Hora/Tattva cycles; and the Integrated Aruḍam composite).

While unit tests assert individual method contracts, this golden fixture provides an end-to-end reconcile: a frozen set of inputs mapped to known-correct outputs. Any calculation drift fails closed in local validation and Tier-1 CI.

### Sections & Doctrinal Citations
- **`moonLongitude`**: Jean Meeus *Astronomical Algorithms* (Chapter 47, truncated ELP 2000/82) continuous lunar longitude calculations (tolerance: `±1e-6°`).
- **`nakshatra`**: Lahiri Ayanamsa + Moon longitude mapped to the 27 Nakshatras and the canonical Siddha 5-6-5-5-6 permanent birth-bird table (`CONF-PP-001`, `CONF-PP-002`).
- **`swara`**: Weekday Udhaya dawn nostril seed (`CONF-013`) and the 1-hour / 24-cycle alternating swara clock (`CONF-014`).
- **`hora`**: Planetary Hours sequence using the classical Chaldean order (`CONF-014`).
- **`tattva`**: 5-element cycles within each 144-minute daylight Yama segment (`CONF-012`).
- **`oracle`**: Integrated Aruḍam composite evaluation across moment harmony, breath alignment, and the Rahu Kaal 10% floor lockout (`CONF-014`, `CONF-015`, `CONF-PP-004`, `PP-ORACLE`).

## Regeneration Discipline (R4)

⚠️ **MANUAL RUN ONLY — NEVER AUTOMATIC, NEVER RUN IN CI.**

Changing a golden expected value is a **human decision** that must be recorded in the PR (and, when doctrinal, in the Decision Journal and relevant CONF document). Implementing agents are strictly prohibited from modifying expected values to mask engine drift.

To recompute expected values from the current engine:

```bash
flutter test tool/regen_golden.dart
```

This updates `test/golden/astro_golden.json`. The commit opening or modifying any PR that touches this file must justify the change in its PR description.
