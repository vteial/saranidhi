import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

void main() {
  group('BirdEmoji', () {
    group('forBird', () {
      test('returns non-empty emoji for each bird', () {
        for (final bird in PakshiBird.values) {
          final emoji = BirdEmoji.forBird(bird);
          expect(emoji.isNotEmpty, isTrue, reason: '${bird.name} should have emoji');
        }
      });

      test('vulture returns eagle emoji', () {
        expect(BirdEmoji.forBird(PakshiBird.vulture), equals('\u{1F985}'));
      });

      test('owl returns owl emoji', () {
        expect(BirdEmoji.forBird(PakshiBird.owl), equals('\u{1F989}'));
      });

      test('peacock returns peacock emoji', () {
        expect(BirdEmoji.forBird(PakshiBird.peacock), equals('\u{1F99A}'));
      });
    });

    group('forBirdName', () {
      test('returns correct emoji for string name', () {
        expect(BirdEmoji.forBirdName('vulture'), equals('\u{1F985}'));
        expect(BirdEmoji.forBirdName('owl'), equals('\u{1F989}'));
        expect(BirdEmoji.forBirdName('crow'), equals('\u{1F426}'));
        expect(BirdEmoji.forBirdName('rooster'), equals('\u{1F413}'));
        expect(BirdEmoji.forBirdName('peacock'), equals('\u{1F99A}'));
      });

      test('returns default bird emoji for null', () {
        expect(BirdEmoji.forBirdName(null), equals('\u{1F426}'));
      });

      test('returns default bird emoji for unknown name', () {
        expect(BirdEmoji.forBirdName('dragon'), equals('\u{1F426}'));
      });
    });

    group('forState', () {
      test('returns non-empty emoji for each state', () {
        for (final state in PakshiState.values) {
          final emoji = BirdEmoji.forState(state);
          expect(emoji.isNotEmpty, isTrue, reason: '${state.name} should have emoji');
        }
      });

      test('ruling returns crown emoji', () {
        expect(BirdEmoji.forState(PakshiState.ruling), equals('\u{1F451}'));
      });
    });

    group('displayLabel', () {
      test('combines emoji and name', () {
        final label = BirdEmoji.displayLabel(PakshiBird.peacock);
        expect(label, contains('\u{1F99A}'));
        expect(label, contains('Peacock'));
      });
    });

    group('fullDisplay', () {
      test('combines bird + state', () {
        final display = BirdEmoji.fullDisplay(PakshiBird.vulture, PakshiState.ruling);
        expect(display, contains('\u{1F985}'));
        expect(display, contains('Vulture'));
        expect(display, contains('\u{1F451}'));
        expect(display, contains('Ruling'));
      });
    });
  });
}
