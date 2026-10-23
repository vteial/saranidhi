# Adhikara / Padu-Pakshi Activation — Design

> Grounds the EARS DoD in the real code seam (all citations are live on `main` after PR #304).

## 1. The seam (as shipped by #304)

`lib/features/astro_engine/domain/oracle_engine.dart` — `OracleCompositeEngine.evaluate`:
- Already accepts `PakshiBird? bird` (optional, step 4 of the body).
- When `bird != null`, derives `paksha` (from the anchored sunrise via `LunarPhaseCalculator.phaseForDate`)
  and `isNight`, calls `PakshiAdhikara.statusFor(...)`, then `PakshiAdhikara.scoreModifier(status)` →
  `{adhikara: 1.15, padu: 0.5, normal: 1.0}`, and threads `adhikaraMultiplier` into
  `IntegratedArudamEngine.evaluate`.
- When `bird == null`, `adhikaraMultiplier = 1.0` (today's behaviour).

`lib/features/astro_engine/domain/integrated_arudam_engine.dart` — `IntegratedArudamEngine.evaluate`:
- Step 1 (line ~184) returns EARLY with the inauspicious **floor-lock** (`isFloorLocked: true`,
  `band: sunya`, score 10) **before** `adhikaraMultiplier` is applied (line ~222:
  `rawMoment ... * adhikaraMultiplier`). This ordering is the R3 guarantee — keep it, pin it.

`lib/features/astro_engine/domain/pakshi_adhikara.dart` — public API (pure, const-table-backed):
`isAdhikara(...)`, `isPadu(...)`, `statusFor({bird, weekday, paksha, isNight}) -> AdhikaraStatus`,
`scoreModifier(AdhikaraStatus) -> double`.

## 2. Caller data (both surfaces already have the input)

- **Prasanam** (`lib/features/prasanam/presentation/prasanam_screen.dart`): resolves
  `currentBirdState` from `dashboardData`; the species is `dashboardData.effectiveBirthBird ?? dashboardData.birthBird`
  (`PakshiBird?`) — the same field `birth_bird_card.dart` / `full_day_schedule.dart` use.
- **Home "now" card** (`lib/features/home/presentation/widgets/arudam_now_card.dart`): has `data` in scope
  with the identical `data.effectiveBirthBird ?? data.birthBird`, but calls `IntegratedArudamEngine.evaluate`
  **directly**, so it has no `adhikaraMultiplier` today.

## 3. Design decision for R2 (the two-surface divergence)

**Chosen: R2(b) — thread an `adhikaraMultiplier` into the Home card's direct
`IntegratedArudamEngine.evaluate` call using the SAME `PakshiAdhikara` derivation**, rather than
R2(a) re-routing the Home card through `OracleCompositeEngine`.

Rationale:
- The Home card deliberately uses the integrated engine directly (it needs `momentScore`/reason
  breakdown for its UI); re-routing it through the composite would be a larger, riskier refactor that
  pulls in the composite's alignment/swara resolution it does not currently own.
- To avoid duplicating the paksha/isNight derivation in two places, **extract the derivation block from
  `OracleCompositeEngine.evaluate` into a small pure helper** (e.g.
  `PakshiAdhikara.multiplierFor({bird, weekday, queryTime, sunrise, sunset}) -> double`) that both the
  composite and the Home card call. The composite's existing inline block is replaced by a call to it
  (behaviour-preserving), and the Home card gains one call + passes the result as `adhikaraMultiplier`.
- This keeps the two surfaces **provably identical** for the same inputs (R2.1) because they share one
  derivation function.

## 4. Change set

| File | Change |
|---|---|
| `pakshi_adhikara.dart` | Add pure `multiplierFor({bird, weekday, queryTime, sunrise, sunset}) -> double` wrapping the existing paksha/isNight derivation + `statusFor` + `scoreModifier`. No table change. |
| `oracle_engine.dart` | Replace the inline derivation (step 4) with `PakshiAdhikara.multiplierFor(...)` (behaviour-preserving refactor). |
| `prasanam_screen.dart` | Pass `bird: effectiveBirthBird ?? birthBird` to `OracleCompositeEngine.evaluate`. |
| `arudam_now_card.dart` | Compute `adhikaraMultiplier` via `PakshiAdhikara.multiplierFor(...)` and pass it to `IntegratedArudamEngine.evaluate`. |
| `test/...` | New golden characterisation (R5) + floor-lock-on-Adhikara-day pin (R3) + null-bird no-op pin (R1.2/R2.2); update #304 goldens where a caller now passes `bird:`. |
| `pakshi_calculator.dart` | **UNCHANGED** (R4 firewall). |

## 5. Invariants to pin with tests
- **Floor-lock wins** over ×1.15 (R3): Adhikara day + Rahu window → still score 10 / sunya / locked.
- **Null bird = no-op** (R1.2/R2.2): un-onboarded profile → byte-identical verdict to pre-activation.
- **Normal day = ×1.0** (RQ): non-Adhikara, non-Padu day unchanged.
- **Two surfaces agree** (R2.1): same (bird, weekday, paksha, day/night) → same multiplier on both paths.
- **Sequence byte-unchanged** (R4): `git diff` empty for `pakshi_calculator.dart`; the #304 28-instance
  SHA-256 regression test still passes.

## 6. Tamil (RT)
Default to **no new user-facing string** — activation only shifts the existing numeric band/verdict the
user already sees. If the design later adds an "Adhikara / Padu day" badge, it is EN + pure Tamil; the
REPORT states which case applied.
