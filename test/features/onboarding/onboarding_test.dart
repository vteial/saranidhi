import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';

void main() {
  group('Onboarding', () {
    group('Birth bird from nakshatra (Task 6.6)', () {
      test('all 27 nakshatras map to a valid bird', () {
        for (final nakshatra in allNakshatras) {
          final bird = PakshiCalculator.birthBirdFromNakshatra(nakshatra);
          expect(bird, isA<PakshiBird>());
        }
      });

      test('Ashwini maps to Vulture', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Ashwini'),
          equals(PakshiBird.vulture),
        );
      });

      test('Revati maps to Peacock', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Revati'),
          equals(PakshiBird.peacock),
        );
      });
    });

    group('allNakshatras list', () {
      test('contains exactly 27 nakshatras', () {
        expect(allNakshatras.length, equals(27));
      });

      test('all entries are unique', () {
        expect(allNakshatras.toSet().length, equals(27));
      });

      test('starts with Ashwini', () {
        expect(allNakshatras.first, equals('Ashwini'));
      });

      test('ends with Revati', () {
        expect(allNakshatras.last, equals('Revati'));
      });
    });

    group('OnboardingState', () {
      test('initial state has step 0', () {
        const state = OnboardingState();
        expect(state.currentStep, equals(0));
        expect(state.totalSteps, equals(4));
      });

      test('copyWith works correctly', () {
        const state = OnboardingState();
        final updated = state.copyWith(displayName: 'Test', currentStep: 2);

        expect(updated.displayName, equals('Test'));
        expect(updated.currentStep, equals(2));
        expect(updated.storageMode, equals('local'));
      });
    });
  });
}
