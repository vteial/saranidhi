import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/l10n/locale_provider.dart';

void main() {
  group('AppLocale', () {
    test('english has correct code and display name', () {
      expect(AppLocale.english.code, equals('en'));
      expect(AppLocale.english.displayName, equals('English'));
    });

    test('tamil has correct code and display name', () {
      expect(AppLocale.tamil.code, equals('ta'));
      expect(AppLocale.tamil.displayName, equals('தமிழ்'));
    });

    test('locale getter returns correct Locale', () {
      expect(AppLocale.english.locale.languageCode, equals('en'));
      expect(AppLocale.tamil.locale.languageCode, equals('ta'));
    });

    test('values contains exactly 2 locales', () {
      expect(AppLocale.values.length, equals(2));
    });
  });
}
