import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/swara_clock.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('SwaraClock', () {
    // Reference date: Sunday July 5, 2026 (Sun-based weekday 1)
    // Sunrise at 06:00:00
    final sundaySunrise = DateTime(2026, 7, 5, 6, 0);

    group('Task 42.2: Weekday Udhaya dawn seeds (CONF-013 / CONF-001)', () {
      test('all 7 weekday dawn seeds match the CONF-013 table exactly', () {
        // 1 = Sunday: Right (Solar), 1h
        final sun = SwaraClock.seedFor(
          sunBasedWeekday: 1,
          paksha: LunarPhase.waxing,
        );
        expect(sun.dawnFlow, equals(BreathFlow.solar));
        expect(sun.inceptionHours, equals(1));

        // 2 = Monday: Left (Lunar), 1h
        final mon = SwaraClock.seedFor(
          sunBasedWeekday: 2,
          paksha: LunarPhase.waxing,
        );
        expect(mon.dawnFlow, equals(BreathFlow.lunar));
        expect(mon.inceptionHours, equals(1));

        // 3 = Tuesday: Right (Solar), 2h
        final tue = SwaraClock.seedFor(
          sunBasedWeekday: 3,
          paksha: LunarPhase.waxing,
        );
        expect(tue.dawnFlow, equals(BreathFlow.solar));
        expect(tue.inceptionHours, equals(2));

        // 4 = Wednesday: Left (Lunar), 2h
        final wed = SwaraClock.seedFor(
          sunBasedWeekday: 4,
          paksha: LunarPhase.waxing,
        );
        expect(wed.dawnFlow, equals(BreathFlow.lunar));
        expect(wed.inceptionHours, equals(2));

        // 5 = Thursday Shukla (waxing): Left (Lunar), 1h
        final thuShukla = SwaraClock.seedFor(
          sunBasedWeekday: 5,
          paksha: LunarPhase.waxing,
        );
        expect(thuShukla.dawnFlow, equals(BreathFlow.lunar));
        expect(thuShukla.inceptionHours, equals(1));

        // 5 = Thursday Krishna (waning): Right (Solar), 2h
        final thuKrishna = SwaraClock.seedFor(
          sunBasedWeekday: 5,
          paksha: LunarPhase.waning,
        );
        expect(thuKrishna.dawnFlow, equals(BreathFlow.solar));
        expect(thuKrishna.inceptionHours, equals(2));

        // 6 = Friday: Left (Lunar), 2h
        final fri = SwaraClock.seedFor(
          sunBasedWeekday: 6,
          paksha: LunarPhase.waxing,
        );
        expect(fri.dawnFlow, equals(BreathFlow.lunar));
        expect(fri.inceptionHours, equals(2));

        // 7 = Saturday: Right (Solar), 1h (Day-08 video governed)
        final sat = SwaraClock.seedFor(
          sunBasedWeekday: 7,
          paksha: LunarPhase.waxing,
        );
        expect(sat.dawnFlow, equals(BreathFlow.solar));
        expect(sat.inceptionHours, equals(1));
      });
    });

    group('Task 42.3: 1h vs 2h inception duration', () {
      test('1h day (Sunday) flips flow after 1 hour', () {
        // [06:00, 07:00) is Solar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 6, 0),
            sunrise: sundaySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.solar),
        );
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 6, 59),
            sunrise: sundaySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.solar),
        );
        // At 07:00 flips to Lunar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 7, 0),
            sunrise: sundaySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.lunar),
        );
      });

      test(
        '2h day (Tuesday) holds seed flow for 2 full hours before flipping',
        () {
          // Tuesday July 7, 2026 (Sun-based weekday 3: Tuesday)
          final tuesdaySunrise = DateTime(2026, 7, 7, 6, 0);

          // Hour 0 (06:00 - 07:00): Solar
          expect(
            SwaraClock.expectedFlowAt(
              time: DateTime(2026, 7, 7, 6, 30),
              sunrise: tuesdaySunrise,
              paksha: LunarPhase.waxing,
            ),
            equals(BreathFlow.solar),
          );
          // Hour 1 (07:00 - 08:00): Solar (held!)
          expect(
            SwaraClock.expectedFlowAt(
              time: DateTime(2026, 7, 7, 7, 30),
              sunrise: tuesdaySunrise,
              paksha: LunarPhase.waxing,
            ),
            equals(BreathFlow.solar),
          );
          // Hour 2 (08:00 - 09:00): flips to Lunar
          expect(
            SwaraClock.expectedFlowAt(
              time: DateTime(2026, 7, 7, 8, 0),
              sunrise: tuesdaySunrise,
              paksha: LunarPhase.waxing,
            ),
            equals(BreathFlow.lunar),
          );
          expect(
            SwaraClock.expectedFlowAt(
              time: DateTime(2026, 7, 7, 8, 30),
              sunrise: tuesdaySunrise,
              paksha: LunarPhase.waxing,
            ),
            equals(BreathFlow.lunar),
          );
          // Hour 3 (09:00 - 10:00): flips back to Solar
          expect(
            SwaraClock.expectedFlowAt(
              time: DateTime(2026, 7, 7, 9, 30),
              sunrise: tuesdaySunrise,
              paksha: LunarPhase.waxing,
            ),
            equals(BreathFlow.solar),
          );
        },
      );

      test('Thursday Krishna (waning) holds Solar seed for 2 hours', () {
        // Thursday July 9, 2026 (Sun-based weekday 5)
        final thursdaySunrise = DateTime(2026, 7, 9, 6, 0);

        // Hour 0 (06:00 - 07:00): Solar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 9, 6, 30),
            sunrise: thursdaySunrise,
            paksha: LunarPhase.waning,
          ),
          equals(BreathFlow.solar),
        );
        // Hour 1 (07:00 - 08:00): Solar (held!)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 9, 7, 30),
            sunrise: thursdaySunrise,
            paksha: LunarPhase.waning,
          ),
          equals(BreathFlow.solar),
        );
        // Hour 2 (08:00 - 09:00): flips to Lunar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 9, 8, 30),
            sunrise: thursdaySunrise,
            paksha: LunarPhase.waning,
          ),
          equals(BreathFlow.lunar),
        );
      });

      test('Thursday Shukla (waxing) alternates hourly from Left seed', () {
        final thursdaySunrise = DateTime(2026, 7, 9, 6, 0);

        // 06:30 -> Lunar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 9, 6, 30),
            sunrise: thursdaySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.lunar),
        );
        // 07:30 -> Solar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 9, 7, 30),
            sunrise: thursdaySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.solar),
        );
        // 08:30 -> Lunar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 9, 8, 30),
            sunrise: thursdaySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.lunar),
        );
      });
    });

    group('Task 42.3: Hourly progression (§3.5 worked examples oracle)', () {
      test('Sunday (seed R, 1h) full progression matches §3.5 oracle', () {
        final sr = DateTime(2026, 7, 5, 6, 0); // Sunday
        const paksha = LunarPhase.waxing;

        // 06:30 = R (Hour 0: 06:00-07:00, seed)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 6, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
        // 07:30 = L (Hour 1: 07:00-08:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 7, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.lunar),
        );
        // 08:30 = R (Hour 2: 08:00-09:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 8, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
        // 09:30 = L (Hour 3: 09:00-10:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 9, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.lunar),
        );
        // 10:30 = R (Hour 4: 10:00-11:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 10, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
        // 11:30 = L (Hour 5: 11:00-12:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 11, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.lunar),
        );
        // 12:30 = R (Hour 6: 12:00-13:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 12, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
        // 13:00 = L (Hour 7: 13:00-14:00, elapsed=7h -> n=6 even -> opposite = Lunar)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 13, 0),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.lunar),
        );
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 13, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.lunar),
        );
        // 14:30 = R (Hour 8: 14:00-15:00)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 14, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
      });

      test('Tuesday (seed R, 2h) progression matches §3.5 oracle', () {
        final sr = DateTime(2026, 7, 7, 6, 0); // Tuesday
        const paksha = LunarPhase.waxing;

        // 07:30 = R (Hour 1: held)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 7, 7, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
        // 08:30 = L (Hour 2: first flip)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 7, 8, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.lunar),
        );
        // 09:30 = R (Hour 3: back to seed)
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 7, 9, 30),
            sunrise: sr,
            paksha: paksha,
          ),
          equals(BreathFlow.solar),
        );
      });
    });

    group(
      'Task 42.3: Day/Night boundary + pre-dawn cross-midnight continuity (CONF-001)',
      () {
        test(
          'nighttime instant returns active flow on the continuous 24h clock',
          () {
            // 23:30 on Sunday July 5 (17.5 hours after 06:00 sunrise)
            // Sunday: seed R, 1h inception.
            // elapsed = 17 hours -> n = 17 - 1 = 16 (even) -> opposite = Lunar
            final nightTime = DateTime(2026, 7, 5, 23, 30);
            final flow = SwaraClock.expectedFlowAt(
              time: nightTime,
              sunrise: sundaySunrise,
              paksha: LunarPhase.waxing,
            );
            expect(flow, equals(BreathFlow.lunar));
          },
        );

        test(
          'pre-dawn instant anchors to yesterday sunrise and continues cycle',
          () {
            // Pre-dawn: 02:00 on Sunday July 5, 2026 (before 06:00 sunrise)
            // The governing civil day began at Saturday July 4 sunrise (06:00).
            final preDawn = DateTime(2026, 7, 5, 2, 0);
            final saturdaySunrise = DateTime(2026, 7, 4, 6, 0);

            // anchorSunrise resolves Saturday sunrise
            final anchored = SwaraClock.anchorSunrise(
              time: preDawn,
              sunriseForDate: (d) => DateTime(d.year, d.month, d.day, 6, 0),
            );
            expect(anchored, equals(saturdaySunrise));

            // Elapsed from Saturday 06:00 to Sunday 02:00 = 20 hours.
            // Saturday seed: Right (Solar), 1h inception.
            // n = 20 - 1 = 19 (odd) -> same as seed (Solar).
            final flow = SwaraClock.expectedFlowAt(
              time: preDawn,
              sunrise: anchored,
              paksha: LunarPhase.waxing,
            );
            expect(flow, equals(BreathFlow.solar));
          },
        );
      },
    );

    group('Sunrise anchoring shifts block boundaries', () {
      test('shifting sunrise by 15 min shifts block boundaries by 15 min', () {
        final earlySunrise = DateTime(2026, 7, 5, 5, 45); // 05:45
        // At 06:40 (55 min after sunrise), still in first 1h block -> Solar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 6, 40),
            sunrise: earlySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.solar),
        );
        // At 06:50 (65 min after sunrise), in second block -> Lunar
        expect(
          SwaraClock.expectedFlowAt(
            time: DateTime(2026, 7, 5, 6, 50),
            sunrise: earlySunrise,
            paksha: LunarPhase.waxing,
          ),
          equals(BreathFlow.lunar),
        );
      });
    });

    group('blockAt countdown and boundaries', () {
      test(
        'blockAt returns start, end, and duration <= 60 min after inception',
        () {
          final block = SwaraClock.blockAt(
            time: DateTime(2026, 7, 5, 7, 15),
            sunrise: sundaySunrise,
            paksha: LunarPhase.waxing,
          );
          expect(block.flow, equals(BreathFlow.lunar));
          expect(block.start, equals(DateTime(2026, 7, 5, 7, 0)));
          expect(block.end, equals(DateTime(2026, 7, 5, 8, 0)));

          final minutesLeft = block.end
              .difference(DateTime(2026, 7, 5, 7, 15))
              .inMinutes;
          expect(minutesLeft, equals(45));
          expect(minutesLeft, lessThanOrEqualTo(60));
        },
      );

      test('blockAt for 2h inception returns 2h window during inception', () {
        final tuesdaySunrise = DateTime(2026, 7, 7, 6, 0);
        final block = SwaraClock.blockAt(
          time: DateTime(2026, 7, 7, 6, 45),
          sunrise: tuesdaySunrise,
          paksha: LunarPhase.waxing,
        );
        expect(block.flow, equals(BreathFlow.solar));
        expect(block.start, equals(DateTime(2026, 7, 7, 6, 0)));
        expect(block.end, equals(DateTime(2026, 7, 7, 8, 0)));
      });
    });
  });
}
