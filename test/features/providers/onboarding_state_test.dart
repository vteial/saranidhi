import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';

void main() {
  group('OnboardingState', () {
    test('initial state defaults', () {
      const state = OnboardingState();
      expect(state.currentStep, equals(0));
      expect(state.displayName, equals(''));
      expect(state.selectedNakshatra, isNull);
      expect(state.birthBird, isNull);
      expect(state.latitude, isNull);
      expect(state.longitude, isNull);
      expect(state.locationName, isNull);
      expect(state.storageMode, equals('local'));
      expect(state.isSaving, isFalse);
    });

    test('totalSteps is 5', () {
      const state = OnboardingState();
      expect(state.totalSteps, equals(5));
    });

    test('copyWith updates only specified fields', () {
      const state = OnboardingState();
      final updated = state.copyWith(
        displayName: 'Ravi',
        currentStep: 2,
        birthBird: PakshiBird.peacock,
      );

      expect(updated.displayName, equals('Ravi'));
      expect(updated.currentStep, equals(2));
      expect(updated.birthBird, equals(PakshiBird.peacock));
      expect(updated.storageMode, equals('local')); // unchanged
      expect(updated.latitude, isNull); // unchanged
    });

    test('copyWith with location', () {
      const state = OnboardingState();
      final updated = state.copyWith(
        latitude: 13.08,
        longitude: 80.27,
        locationName: 'Chennai',
      );

      expect(updated.latitude, equals(13.08));
      expect(updated.longitude, equals(80.27));
      expect(updated.locationName, equals('Chennai'));
    });

    test('copyWith with storage mode', () {
      const state = OnboardingState();
      final updated = state.copyWith(storageMode: 'gdrive');
      expect(updated.storageMode, equals('gdrive'));
    });

    test('copyWith with isSaving', () {
      const state = OnboardingState();
      final saving = state.copyWith(isSaving: true);
      expect(saving.isSaving, isTrue);
    });
  });

  group('allNakshatras', () {
    test('contains exactly 27 nakshatras', () {
      expect(allNakshatras.length, equals(27));
    });

    test('all entries are unique', () {
      expect(allNakshatras.toSet().length, equals(27));
    });

    test('all entries are non-empty strings', () {
      for (final n in allNakshatras) {
        expect(n.isNotEmpty, isTrue);
      }
    });

    test('sorted alphabetically', () {
      final sorted = List<String>.from(allNakshatras)..sort();
      expect(allNakshatras, equals(sorted));
    });

    test('each nakshatra maps to a valid bird', () {
      for (final nakshatra in allNakshatras) {
        final bird = PakshiCalculator.birthBirdFromNakshatraSafe(nakshatra);
        expect(bird, isNotNull, reason: '$nakshatra should map to a bird');
      }
    });
  });
}
