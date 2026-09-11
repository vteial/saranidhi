import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_attributes.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

void main() {
  group('PakshiAttributes', () {
    group('All birds have attributes', () {
      test('every PakshiBird has a corresponding attributes entry', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          expect(attrs.bird, equals(bird));
        }
      });

      test('every bird has a non-empty nature description', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          expect(attrs.nature.isNotEmpty, isTrue);
        }
      });

      test('every bird has at least 1 friend', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          expect(attrs.friends.isNotEmpty, isTrue);
        }
      });

      test('every bird has at least 1 enemy', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          expect(attrs.enemies.isNotEmpty, isTrue);
        }
      });

      test('no bird is its own friend or enemy', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          expect(attrs.friends.contains(bird), isFalse);
          expect(attrs.enemies.contains(bird), isFalse);
        }
      });
    });

    group('Specific bird attributes (Sprint 37 CONF-PP-003..005)', () {
      test('Vulture: Earth element, Jupiter, Waxing/Waning East, Yellow', () {
        final attrs = PakshiAttributes.forBird(PakshiBird.vulture);
        expect(attrs.element, equals(PakshiElement.earth));
        expect(attrs.planet, equals(PakshiPlanet.jupiter));
        expect(attrs.direction, equals(PakshiDirection.east));
        expect(
          attrs.directionForPhase(LunarPhase.waxing),
          equals(PakshiDirection.east),
        );
        expect(
          attrs.directionForPhase(LunarPhase.waning),
          equals(PakshiDirection.east),
        );
        expect(
          PakshiAttributes.directionFor(PakshiBird.vulture, LunarPhase.waning),
          equals(PakshiDirection.east),
        );
        expect(attrs.colour, equals(PakshiColour.yellow));
        expect(
          attrs.friends,
          containsAll([PakshiBird.peacock, PakshiBird.owl]),
        );
        expect(
          attrs.enemies,
          containsAll([PakshiBird.crow, PakshiBird.rooster]),
        );
      });

      test('Owl: Water element, Venus, Waxing South / Waning North, White', () {
        final attrs = PakshiAttributes.forBird(PakshiBird.owl);
        expect(attrs.element, equals(PakshiElement.water));
        expect(attrs.planet, equals(PakshiPlanet.venus));
        expect(attrs.direction, equals(PakshiDirection.south));
        expect(
          attrs.directionForPhase(LunarPhase.waxing),
          equals(PakshiDirection.south),
        );
        expect(
          attrs.directionForPhase(LunarPhase.waning),
          equals(PakshiDirection.north),
        );
        expect(attrs.colour, equals(PakshiColour.white));
        expect(
          attrs.friends,
          containsAll([PakshiBird.vulture, PakshiBird.crow]),
        );
        expect(
          attrs.enemies,
          containsAll([PakshiBird.peacock, PakshiBird.rooster]),
        );
      });

      test('Crow: Fire element, Mars, Waxing West / Waning South, Red', () {
        final attrs = PakshiAttributes.forBird(PakshiBird.crow);
        expect(attrs.element, equals(PakshiElement.fire));
        expect(attrs.planet, equals(PakshiPlanet.mars));
        expect(attrs.direction, equals(PakshiDirection.west));
        expect(
          attrs.directionForPhase(LunarPhase.waxing),
          equals(PakshiDirection.west),
        );
        expect(
          attrs.directionForPhase(LunarPhase.waning),
          equals(PakshiDirection.south),
        );
        expect(attrs.colour, equals(PakshiColour.red));
        expect(
          attrs.friends,
          containsAll([PakshiBird.owl, PakshiBird.rooster]),
        );
        expect(
          attrs.enemies,
          containsAll([PakshiBird.vulture, PakshiBird.peacock]),
        );
      });

      test(
        'Rooster: Air element, Mercury, Waxing North / Waning Center, Green',
        () {
          final attrs = PakshiAttributes.forBird(PakshiBird.rooster);
          expect(attrs.element, equals(PakshiElement.air));
          expect(attrs.planet, equals(PakshiPlanet.mercury));
          expect(attrs.direction, equals(PakshiDirection.north));
          expect(
            attrs.directionForPhase(LunarPhase.waxing),
            equals(PakshiDirection.north),
          );
          expect(
            attrs.directionForPhase(LunarPhase.waning),
            equals(PakshiDirection.center),
          );
          expect(attrs.colour, equals(PakshiColour.green));
          expect(
            attrs.friends,
            containsAll([PakshiBird.peacock, PakshiBird.crow]),
          );
          expect(
            attrs.enemies,
            containsAll([PakshiBird.vulture, PakshiBird.owl]),
          );
        },
      );

      test(
        'Peacock: Ether element, Saturn, Waxing Center / Waning West, Black',
        () {
          final attrs = PakshiAttributes.forBird(PakshiBird.peacock);
          expect(attrs.element, equals(PakshiElement.ether));
          expect(attrs.planet, equals(PakshiPlanet.saturn));
          expect(attrs.direction, equals(PakshiDirection.center));
          expect(
            attrs.directionForPhase(LunarPhase.waxing),
            equals(PakshiDirection.center),
          );
          expect(
            attrs.directionForPhase(LunarPhase.waning),
            equals(PakshiDirection.west),
          );
          expect(attrs.colour, equals(PakshiColour.black));
          expect(
            attrs.friends,
            containsAll([PakshiBird.vulture, PakshiBird.rooster]),
          );
          expect(attrs.enemies, containsAll([PakshiBird.owl, PakshiBird.crow]));
        },
      );
    });

    group('Friend/enemy relationships are symmetric', () {
      test('if A is friend of B, then B is friend of A', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          for (final friend in attrs.friends) {
            final friendAttrs = PakshiAttributes.forBird(friend);
            expect(
              friendAttrs.friends.contains(bird),
              isTrue,
              reason: '${friend.name} should list ${bird.name} as friend',
            );
          }
        }
      });

      test('if A is enemy of B, then B is enemy of A', () {
        for (final bird in PakshiBird.values) {
          final attrs = PakshiAttributes.forBird(bird);
          for (final enemy in attrs.enemies) {
            final enemyAttrs = PakshiAttributes.forBird(enemy);
            expect(
              enemyAttrs.enemies.contains(bird),
              isTrue,
              reason: '${enemy.name} should list ${bird.name} as enemy',
            );
          }
        }
      });
    });

    group('Unique assignments', () {
      test('each bird has a unique element', () {
        final elements = PakshiBird.values
            .map((b) => PakshiAttributes.forBird(b).element)
            .toSet();
        expect(elements.length, equals(5));
      });

      test('each bird has a unique planet', () {
        final planets = PakshiBird.values
            .map((b) => PakshiAttributes.forBird(b).planet)
            .toSet();
        expect(planets.length, equals(5));
      });

      test('each bird has a unique waxing direction', () {
        final directions = PakshiBird.values
            .map(
              (b) => PakshiAttributes.forBird(
                b,
              ).directionForPhase(LunarPhase.waxing),
            )
            .toSet();
        expect(directions.length, equals(5));
      });

      test('each bird has a unique waning direction', () {
        final directions = PakshiBird.values
            .map(
              (b) => PakshiAttributes.forBird(
                b,
              ).directionForPhase(LunarPhase.waning),
            )
            .toSet();
        expect(directions.length, equals(5));
      });

      test('each bird has a unique colour', () {
        final colours = PakshiBird.values
            .map((b) => PakshiAttributes.forBird(b).colour)
            .toSet();
        expect(colours.length, equals(5));
      });
    });

    group('Enum display names', () {
      test('all PakshiElement values have non-empty displayName', () {
        for (final e in PakshiElement.values) {
          expect(e.displayName.isNotEmpty, isTrue);
          expect(e.tamilName.isNotEmpty, isTrue);
          expect(e.emoji.isNotEmpty, isTrue);
        }
      });

      test('all PakshiPlanet values have non-empty displayName', () {
        for (final p in PakshiPlanet.values) {
          expect(p.displayName.isNotEmpty, isTrue);
          expect(p.tamilName.isNotEmpty, isTrue);
          expect(p.symbol.isNotEmpty, isTrue);
        }
      });

      test('all PakshiDirection values have non-empty displayName', () {
        for (final d in PakshiDirection.values) {
          expect(d.displayName.isNotEmpty, isTrue);
          expect(d.tamilName.isNotEmpty, isTrue);
          expect(d.emoji.isNotEmpty, isTrue);
        }
      });

      test('all PakshiColour values have non-empty displayName', () {
        for (final c in PakshiColour.values) {
          expect(c.displayName.isNotEmpty, isTrue);
          expect(c.tamilName.isNotEmpty, isTrue);
          expect(c.hexValue, isNonZero);
        }
      });
    });
  });
}
