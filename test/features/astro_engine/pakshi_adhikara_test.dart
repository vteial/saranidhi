import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_adhikara.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

void main() {
  group('PakshiAdhikara (CONF-PP-007 / Kottumozhi Sathya pp. 14, 17, 18, 22)', () {
    group('Shukla (Valarpirai / Waxing) Adhikara blocks (p. 22)', () {
      test('Vulture: Sun-day, Tue-day, Fri-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 0, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 2, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 5, paksha: LunarPhase.waxing, isNight: true), isTrue);

        // Non-adhikara windows
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 0, paksha: LunarPhase.waxing, isNight: true), isFalse);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 1, paksha: LunarPhase.waxing, isNight: false), isFalse);
      });

      test('Owl: Mon-day, Wed-day, Sat-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.owl, weekday: 1, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.owl, weekday: 3, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.owl, weekday: 6, paksha: LunarPhase.waxing, isNight: true), isTrue);

        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.owl, weekday: 1, paksha: LunarPhase.waxing, isNight: true), isFalse);
      });

      test('Crow: Thu-day, Sun-night, Tue-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.crow, weekday: 4, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.crow, weekday: 0, paksha: LunarPhase.waxing, isNight: true), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.crow, weekday: 2, paksha: LunarPhase.waxing, isNight: true), isTrue);

        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.crow, weekday: 4, paksha: LunarPhase.waxing, isNight: true), isFalse);
      });

      test('Rooster: Fri-day, Mon-night, Wed-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 5, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 1, paksha: LunarPhase.waxing, isNight: true), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 3, paksha: LunarPhase.waxing, isNight: true), isTrue);

        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 5, paksha: LunarPhase.waxing, isNight: true), isFalse);
      });

      test('Peacock: Sat-day, Thu-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.peacock, weekday: 6, paksha: LunarPhase.waxing, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.peacock, weekday: 4, paksha: LunarPhase.waxing, isNight: true), isTrue);

        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.peacock, weekday: 6, paksha: LunarPhase.waxing, isNight: true), isFalse);
      });
    });

    group('Krishna (Theipirai / Waning) Adhikara blocks (p. 17)', () {
      test('Vulture: Fri-day, Sun-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 5, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 0, paksha: LunarPhase.waning, isNight: true), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.vulture, weekday: 5, paksha: LunarPhase.waning, isNight: true), isFalse);
      });

      test('Owl: Thu-day, Wed-night (continuous 24h)', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.owl, weekday: 4, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.owl, weekday: 3, paksha: LunarPhase.waning, isNight: true), isTrue);
      });

      test('Crow: Wed-day, Thu-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.crow, weekday: 3, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.crow, weekday: 4, paksha: LunarPhase.waning, isNight: true), isTrue);
      });

      test('Rooster: Sun-day, Tue-day, Mon-night', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 0, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 2, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.rooster, weekday: 1, paksha: LunarPhase.waning, isNight: true), isTrue);
      });

      test('Peacock: Mon-day, Sat-day', () {
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.peacock, weekday: 1, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.peacock, weekday: 6, paksha: LunarPhase.waning, isNight: false), isTrue);
        expect(PakshiAdhikara.isAdhikara(bird: PakshiBird.peacock, weekday: 1, paksha: LunarPhase.waning, isNight: true), isFalse);
      });
    });

    group('Padu-Pakshi (Downtime) days (p. 18)', () {
      test('Shukla: Vulture(Thu,Sat), Owl(Sun,Fri), Crow(Mon), Rooster(Tue), Peacock(Wed)', () {
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.vulture, weekday: 4, paksha: LunarPhase.waxing), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.vulture, weekday: 6, paksha: LunarPhase.waxing), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.vulture, weekday: 0, paksha: LunarPhase.waxing), isFalse);

        expect(PakshiAdhikara.isPadu(bird: PakshiBird.owl, weekday: 0, paksha: LunarPhase.waxing), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.owl, weekday: 5, paksha: LunarPhase.waxing), isTrue);

        expect(PakshiAdhikara.isPadu(bird: PakshiBird.crow, weekday: 1, paksha: LunarPhase.waxing), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.rooster, weekday: 2, paksha: LunarPhase.waxing), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.peacock, weekday: 3, paksha: LunarPhase.waxing), isTrue);
      });

      test('Krishna: Vulture(Tue), Owl(Mon), Crow(Sun,Thu), Rooster(Sat), Peacock(Wed,Fri)', () {
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.vulture, weekday: 2, paksha: LunarPhase.waning), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.owl, weekday: 1, paksha: LunarPhase.waning), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.crow, weekday: 0, paksha: LunarPhase.waning), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.crow, weekday: 4, paksha: LunarPhase.waning), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.rooster, weekday: 6, paksha: LunarPhase.waning), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.peacock, weekday: 3, paksha: LunarPhase.waning), isTrue);
        expect(PakshiAdhikara.isPadu(bird: PakshiBird.peacock, weekday: 5, paksha: LunarPhase.waning), isTrue);
      });
    });

    group('statusFor and scoreModifier', () {
      test('resolves adhikara, padu, and normal appropriately', () {
        // Cock on Friday day in Shukla -> adhikara
        expect(
          PakshiAdhikara.statusFor(bird: PakshiBird.rooster, weekday: 5, paksha: LunarPhase.waxing, isNight: false),
          AdhikaraStatus.adhikara,
        );

        // Cock on Tuesday in Shukla -> padu
        expect(
          PakshiAdhikara.statusFor(bird: PakshiBird.rooster, weekday: 2, paksha: LunarPhase.waxing, isNight: false),
          AdhikaraStatus.padu,
        );

        // Cock on Monday daytime in Shukla -> normal (Monday night is Adhikara, but Monday daytime is normal)
        expect(
          PakshiAdhikara.statusFor(bird: PakshiBird.rooster, weekday: 1, paksha: LunarPhase.waxing, isNight: false),
          AdhikaraStatus.normal,
        );
      });

      test('scoreModifier returns correct multipliers', () {
        expect(PakshiAdhikara.scoreModifier(AdhikaraStatus.adhikara), 1.15);
        expect(PakshiAdhikara.scoreModifier(AdhikaraStatus.padu), 0.5);
        expect(PakshiAdhikara.scoreModifier(AdhikaraStatus.normal), 1.0);
      });
    });

    group('multiplierFor (CONF-PP-007 activation helper)', () {
      final shuklaDate = DateTime(2025, 1, 10, 8, 30); // Friday, Shukla
      final sunrise = DateTime(2025, 1, 10, 6);
      final sunset = DateTime(2025, 1, 10, 18);

      test('returns 1.15 when bird is in Adhikara block', () {
        // Cock on Friday daytime in Shukla -> Adhikara
        final multiplier = PakshiAdhikara.multiplierFor(
          weekday: 5,
          queryTime: shuklaDate,
          bird: PakshiBird.rooster,
          sunrise: sunrise,
          sunset: sunset,
        );
        expect(multiplier, 1.15);
      });

      test('returns 0.5 when bird is in Padu downtime', () {
        // Tuesday in Shukla (Jan 7, 2025): Cock is Padu
        final tuesday = DateTime(2025, 1, 7, 10);
        final tuesdaySunrise = DateTime(2025, 1, 7, 6);
        final tuesdaySunset = DateTime(2025, 1, 7, 18);

        final multiplier = PakshiAdhikara.multiplierFor(
          weekday: 2,
          queryTime: tuesday,
          bird: PakshiBird.rooster,
          sunrise: tuesdaySunrise,
          sunset: tuesdaySunset,
        );
        expect(multiplier, 0.5);
      });

      test('returns 1.0 when bird is normal', () {
        // Wednesday daytime in Shukla (Jan 8, 2025): Cock is normal
        final wednesday = DateTime(2025, 1, 8, 10);
        final wedSunrise = DateTime(2025, 1, 8, 6);
        final wedSunset = DateTime(2025, 1, 8, 18);

        final multiplier = PakshiAdhikara.multiplierFor(
          weekday: 3,
          queryTime: wednesday,
          bird: PakshiBird.rooster,
          sunrise: wedSunrise,
          sunset: wedSunset,
        );
        expect(multiplier, 1.0);
      });

      test('returns 1.0 when bird is null (null-bird no-op invariant)', () {
        final multiplier = PakshiAdhikara.multiplierFor(
          weekday: 5,
          queryTime: shuklaDate,
          bird: null,
          sunrise: sunrise,
          sunset: sunset,
        );
        expect(multiplier, 1.0);
      });

      test('returns 1.0 when sunrise or sunset is null', () {
        expect(
          PakshiAdhikara.multiplierFor(
            weekday: 5,
            queryTime: shuklaDate,
            bird: PakshiBird.rooster,
            sunrise: null,
            sunset: sunset,
          ),
          1.0,
        );
        expect(
          PakshiAdhikara.multiplierFor(
            weekday: 5,
            queryTime: shuklaDate,
            bird: PakshiBird.rooster,
            sunrise: sunrise,
            sunset: null,
          ),
          1.0,
        );
      });
    });
  });
}
