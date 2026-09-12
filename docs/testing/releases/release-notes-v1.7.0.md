[← Back to Smoke Test](./smoke-test-v1.7.0.md)

# Release Notes — v1.7.0-web

> Permanent record of the [GitHub Release](https://github.com/vteial/saranidhi/releases/tag/v1.7.0-web).
> The owner created the tag/release from the GitHub UI; this file is the source text
> so the release stays auditable. Backfilled from the published release at the
> process-dossier restructure (first release retrofitted into this convention).

## Tag details

| Field | Value |
|-------|-------|
| **Tag** | `v1.7.0-web` |
| **Target** | `prod` branch |
| **Title** | `v1.7.0-web — Birth-Bird Engine Correction` |

## Release notes (body)

A **correctness release** that fixes the core Panja Pakshi birth-bird calculation to match the authentic Tamil Siddha lineage, replacing an earlier modern-secondary interpretation. Grounded in the Panja Pakshi corpus audit and owner-adjudicated (CONF-PP-001…005).

### 🦅 Why this matters
Your **birth bird** is the root of the entire Panja Pakshi system — it drives your daily bird-states, yama schedule, and Oracle guidance. This release corrects how it's derived, so those results are now faithful to the classical source for **all** users.

### Fixed
- **Nakshatra → bird partition corrected to the canonical 5-6-5-5-6** (was 5-5-5-5-7). Users born under **Purva Phalguni (Pooram)**, **Vishakha (Visakam)**, or **Uttara Ashadha (Uthiradam)** now get their correct bird — **Owl**, **Crow**, and **Rooster** respectively.
- **Single permanent birth-star bird** — a known birth star yields one lifetime bird; the earlier Krishna-paksha reverse-swap has been removed.
- **Corrected bird attributes** — ruling planets (Vulture = Jupiter, Owl = Venus, Crow = Mars, Rooster = Mercury, Peacock = Saturn), unified friend/enemy relationships, and moon-phase-dependent cardinal directions.

### Changed
- **Existing users are auto-corrected on app open** — a one-time silent recalculation updates any affected stored bird (both date-of-birth and manual "I know my star" profiles), with a brief notification. No action needed.
- The waxing/waning bird swap now applies **only** to the name-initial method (used when neither birth star nor date of birth is known).

### Notes
- No new features — this is a focused accuracy/correctness release.
- Verified end-to-end on staging, including the existing-profile upgrade path (a real profile auto-correcting on app open) in both English and Tamil.

### Sprint(s)
- Sprint 37 — Birth-Bird Engine Correction

---

- **Spec + dossier:** [`sprints/sprint-37-birth-bird/`](../../process/sprints/sprint-37-birth-bird/README.md)
- **Smoke test:** [`smoke-test-v1.7.0.md`](./smoke-test-v1.7.0.md) — ✅ PASS
- **PR:** [#167](https://github.com/vteial/saranidhi/pull/167) · **Prod:** [saranidhi.vercel.app](https://saranidhi.vercel.app)
- **Full changelog:** [`CHANGELOG.md`](../../../CHANGELOG.md)
