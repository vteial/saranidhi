# Saranidhi Diagnostic Dump — Design

> HOW the `diagnostic-dump` Spec is built. Grounded in the real engine APIs at HEAD `297cb46`.

## Shape

A single standalone script `tool/dump_diagnostic.dart` with a `main(List<String> args)` entrypoint —
same pattern as the existing `tool/regen_golden.dart`, so it runs with `dart run tool/...`. No Flutter
runtime needed (pure-Dart engines).

```
tool/dump_diagnostic.dart        # NEW — the CLI
test/tool/dump_diagnostic_test.dart  # NEW — shape + determinism unit test
```

## Data model (internal, serialized to JSON/MD)

```
DayRecord {
  date: ISO-8601 date
  weekday: Mon..Sun
  sunrise, sunset: local ISO time
  lunarPhase: waxing | waning
  nakshatra: name
  yamas: [YamaRecord × 10]
}
YamaRecord {
  index: 1..10
  start, end: local ISO time
  rulingBird: vulture|owl|crow|rooster|peacock
  subjectBird: (= --bird)
  subjectState: ruling|eating|walking|sleeping|dying
}
```

## Engine wiring (read-only calls)

- **Day yamas Y1–Y5 + ruling bird + state table:** `PakshiCalculator` → `PakshiDayResult`
  (`entries` for ruling bird per yama; `stateTable[birdIndex][yamaIndex]` for the subject bird's
  state). Bird index order is fixed `vulture=0, owl=1, crow=2, rooster=3, peacock=4`.
- **Night yamas Y6–Y10:** `yama_calculator.dart` `calculateNight(...) → NightYamaResult`
  (`NightYamaSegment` start/end). The night bird/state is read from the same Pakshi night model the
  engine already uses — the dump calls the engine's own night path, it does not re-derive it.
- **Sunrise/sunset:** `sunrise_calculator.dart`.
- **Lunar phase:** `lunar_phase_calculator.dart` → `LunarPhase`.
- **Nakshatra:** `nakshatra_calculator.dart`.
- **Weekday:** from the civil date (CONF-001 sunrise-anchored day boundary — the dump labels the
  civil date; it does not invent a new day-boundary rule).

> The dump **calls the shipped engines and prints what they return** — it introduces no calculation
> of its own. If an engine entrypoint needs a small public accessor to be callable from `tool/`, that
> accessor is additive and covered by R4 (no behavior change), but the preference is to use existing
> public APIs as-is; T0 confirms the exact seam before any `lib/` touch and STOPs-and-asks if a
> non-trivial `lib/` change would be required.

## CLI surface

```
dart run tool/dump_diagnostic.dart \
  --bird owl --lat 13.0827 --lng 80.2707 \
  --start 2026-10-23 [--days 7] [--format json|md] [--out path]
--help / -h   usage
```

Arg parsing: `package:args` if already a dep, else a tiny hand-rolled parser (no new dep without
owner sign-off). Invalid `--bird` / missing required arg → stderr usage + non-zero exit.

## Determinism (R2.2)

The only time-varying inputs are the requested dates and the location. No `DateTime.now()` in the
output path. JSON uses sorted keys and fixed field order. Two runs with identical args produce
byte-identical JSON — the unit test pins this.

## Testing

`test/tool/dump_diagnostic_test.dart`:
- builds the report for a fixed `(bird, lat, lng, start, days=7)` and asserts 70 yama records, every
  R1 field present and well-typed, indices 1..10 per day.
- runs the builder twice and asserts byte-identical JSON (determinism).
- asserts an invalid bird throws/exits with the valid-bird list.

## Open questions (resolve in T0, STOP-and-ask if blocking)

- **OQ-1** Night subject-bird state: confirm the exact engine accessor for the Y6–Y10 state table
  (the day path exposes `stateTable`; the night path's equivalent must be located before wiring).
- **OQ-2** Whether `package:args` is already a dev-dependency; if not, hand-roll rather than add a dep.
- **OQ-3** Location input: lat/lng flags vs. a preset-city name (`--city chennai`). Default to lat/lng
  (matches engine APIs); a city convenience map is optional and additive.
