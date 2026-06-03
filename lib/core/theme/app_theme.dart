import 'package:flutter/material.dart';

/// Color accent options for the app.
enum ThemeAccent {
  defaultPurple,
  emerald,
  gold,
  purple;

  String get displayName => switch (this) {
    ThemeAccent.defaultPurple => 'Default',
    ThemeAccent.emerald => 'Emerald',
    ThemeAccent.gold => 'Gold',
    ThemeAccent.purple => 'Purple',
  };

  Color get seedColor => switch (this) {
    ThemeAccent.defaultPurple => const Color(0xFF6750A4),
    ThemeAccent.emerald => const Color(0xFF2E7D32),
    ThemeAccent.gold => const Color(0xFFFF8F00),
    ThemeAccent.purple => const Color(0xFF7B1FA2),
  };
}

/// The brightness mode (light/dark/system).
enum ThemeBrightness {
  light,
  dark,
  system;

  String get displayName => switch (this) {
    ThemeBrightness.light => 'Light',
    ThemeBrightness.dark => 'Dark',
    ThemeBrightness.system => 'System',
  };

  ThemeMode get flutterMode => switch (this) {
    ThemeBrightness.light => ThemeMode.light,
    ThemeBrightness.dark => ThemeMode.dark,
    ThemeBrightness.system => ThemeMode.system,
  };
}

/// Generates Material 3 [ThemeData] for accent + brightness combinations.
/// Total: 4 accents × 2 brightness = 8 variants + system mode.
class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme(ThemeAccent accent) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: accent.seedColor),
      fontFamily: 'Roboto',
    );
  }

  static ThemeData darkTheme(ThemeAccent accent) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent.seedColor,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Roboto',
    );
  }
}
