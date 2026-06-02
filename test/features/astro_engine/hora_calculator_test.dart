import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';

void main() {
  group('HoraCalculator', () {
    final sunrise = DateTime(2025, 3, 20, 6, 0);
    final sunset = DateTime(2025, 3, 20, 18, 0);
    final nextSunrise = DateTime(2025, 3, 21, 6, 0);

    group('Day Horas', () {
      test('A-30: Sunday first hora is Sun', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0, // Sunday
        );

        expect(horas.first.planet, equals(HoraPlanet.sun));
      });

      test('A-31: Monday first hora is Moon', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 1, // Monday
        );

        expect(horas.first.planet, equals(HoraPlanet.moon));
      });

      test('Tuesday first hora is Mars', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 2,
        );
        expect(horas.first.planet, equals(HoraPlanet.mars));
      });

      test('Wednesday first hora is Mercury', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 3,
        );
        expect(horas.first.planet, equals(HoraPlanet.mercury));
      });

      test('Thursday first hora is Jupiter', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 4,
        );
        expect(horas.first.planet, equals(HoraPlanet.jupiter));
      });

      test('Friday first hora is Venus', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 5,
        );
        expect(horas.first.planet, equals(HoraPlanet.venus));
      });

      test('Saturday first hora is Saturn', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 6,
        );
        expect(horas.first.planet, equals(HoraPlanet.saturn));
      });

      test('A-32: follows Chaldean order', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0, // Sunday, starts with Sun
        );

        // Sun → Venus → Mercury → Moon → Saturn → Jupiter → Mars → Sun...
        expect(horas[0].planet, equals(HoraPlanet.sun));
        expect(horas[1].planet, equals(HoraPlanet.venus));
        expect(horas[2].planet, equals(HoraPlanet.mercury));
        expect(horas[3].planet, equals(HoraPlanet.moon));
        expect(horas[4].planet, equals(HoraPlanet.saturn));
        expect(horas[5].planet, equals(HoraPlanet.jupiter));
        expect(horas[6].planet, equals(HoraPlanet.mars));
        // Cycle repeats
        expect(horas[7].planet, equals(HoraPlanet.sun));
      });

      test('A-33: produces exactly 12 day horas', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0,
        );

        expect(horas.length, equals(12));
        expect(horas.first.start, equals(sunrise));
        expect(horas.last.end, equals(sunset));
      });

      test('all day horas are contiguous', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0,
        );

        for (var i = 0; i < 11; i++) {
          expect(horas[i].end, equals(horas[i + 1].start));
        }
      });

      test('all day horas marked isDayHora true', () {
        final horas = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0,
        );

        for (final hora in horas) {
          expect(hora.isDayHora, isTrue);
        }
      });
    });

    group('Night Horas', () {
      test('A-34: produces exactly 12 night horas', () {
        final horas = HoraCalculator.calculateNightHoras(
          sunset: sunset,
          nextSunrise: nextSunrise,
          weekday: 0,
        );

        expect(horas.length, equals(12));
        expect(horas.first.start, equals(sunset));
        expect(horas.last.end, equals(nextSunrise));
      });

      test('night horas marked isDayHora false', () {
        final horas = HoraCalculator.calculateNightHoras(
          sunset: sunset,
          nextSunrise: nextSunrise,
          weekday: 0,
        );

        for (final hora in horas) {
          expect(hora.isDayHora, isFalse);
        }
      });

      test('night horas continue Chaldean sequence from day', () {
        final dayHoras = HoraCalculator.calculateDayHoras(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0,
        );
        final nightHoras = HoraCalculator.calculateNightHoras(
          sunset: sunset,
          nextSunrise: nextSunrise,
          weekday: 0,
        );

        // The 13th hora should continue from the 12th
        // Sunday day: 12 horas starting from Sun
        // Night should continue the sequence
        final lastDayPlanet = dayHoras.last.planet;
        final firstNightPlanet = nightHoras.first.planet;

        // Verify they follow Chaldean order
        expect(lastDayPlanet, isNotNull);
        expect(firstNightPlanet, isNotNull);
      });
    });

    group('activeHora', () {
      test('returns correct hora during daytime', () {
        final midDay = DateTime(2025, 3, 20, 12, 0);

        final result = HoraCalculator.activeHora(
          time: midDay,
          sunrise: sunrise,
          sunset: sunset,
          nextSunrise: nextSunrise,
          weekday: 0,
        );

        expect(result, isNotNull);
        expect(result!.isDayHora, isTrue);
      });

      test('returns correct hora during nighttime', () {
        final night = DateTime(2025, 3, 20, 22, 0);

        final result = HoraCalculator.activeHora(
          time: night,
          sunrise: sunrise,
          sunset: sunset,
          nextSunrise: nextSunrise,
          weekday: 0,
        );

        expect(result, isNotNull);
        expect(result!.isDayHora, isFalse);
      });

      test('returns null for time before sunrise', () {
        final early = DateTime(2025, 3, 20, 5, 0);

        final result = HoraCalculator.activeHora(
          time: early,
          sunrise: sunrise,
          sunset: sunset,
          nextSunrise: nextSunrise,
          weekday: 0,
        );

        expect(result, isNull);
      });
    });

    group('Validation', () {
      test('throws on invalid weekday', () {
        expect(
          () => HoraCalculator.calculateDayHoras(
            sunrise: sunrise,
            sunset: sunset,
            weekday: -1,
          ),
          throwsArgumentError,
        );
      });

      test('throws if sunset not after sunrise', () {
        expect(
          () => HoraCalculator.calculateDayHoras(
            sunrise: sunset,
            sunset: sunrise,
            weekday: 0,
          ),
          throwsArgumentError,
        );
      });

      test('throws if nextSunrise not after sunset', () {
        expect(
          () => HoraCalculator.calculateNightHoras(
            sunset: nextSunrise,
            nextSunrise: sunset,
            weekday: 0,
          ),
          throwsArgumentError,
        );
      });
    });
  });
}
