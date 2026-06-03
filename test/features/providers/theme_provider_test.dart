import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/theme/app_theme.dart';

void main() {
  group('ThemeAccent', () {
    test('has exactly 4 values', () {
      expect(ThemeAccent.values.length, equals(4));
    });

    test('each accent has a non-transparent seed color', () {
      for (final accent in ThemeAccent.values) {
        expect(accent.seedColor.alpha, greaterThan(0));
      }
    });

    test('display names are non-empty', () {
      for (final accent in ThemeAccent.values) {
        expect(accent.displayName.isNotEmpty, isTrue);
      }
    });

    test('default is defaultPurple', () {
      expect(ThemeAccent.defaultPurple.displayName, equals('Default'));
    });
  });

  group('ThemeBrightness', () {
    test('has exactly 3 values', () {
      expect(ThemeBrightness.values.length, equals(3));
    });

    test('flutterMode maps correctly', () {
      expect(ThemeBrightness.light.flutterMode, equals(ThemeMode.light));
      expect(ThemeBrightness.dark.flutterMode, equals(ThemeMode.dark));
      expect(ThemeBrightness.system.flutterMode, equals(ThemeMode.system));
    });

    test('display names are non-empty', () {
      for (final b in ThemeBrightness.values) {
        expect(b.displayName.isNotEmpty, isTrue);
      }
    });
  });

  group('AppTheme', () {
    test('lightTheme returns valid ThemeData for each accent', () {
      for (final accent in ThemeAccent.values) {
        final theme = AppTheme.lightTheme(accent);
        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.brightness, equals(Brightness.light));
      }
    });

    test('darkTheme returns valid ThemeData for each accent', () {
      for (final accent in ThemeAccent.values) {
        final theme = AppTheme.darkTheme(accent);
        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.brightness, equals(Brightness.dark));
      }
    });

    test('tap target size is padded for accessibility', () {
      final theme = AppTheme.lightTheme(ThemeAccent.defaultPurple);
      expect(
        theme.materialTapTargetSize,
        equals(MaterialTapTargetSize.padded),
      );
    });

    test('total theme variants is 8 (4 accents x 2 brightness)', () {
      var count = 0;
      for (final accent in ThemeAccent.values) {
        AppTheme.lightTheme(accent);
        AppTheme.darkTheme(accent);
        count += 2;
      }
      expect(count, equals(8));
    });
  });
}
