import 'package:flutter/material.dart';

/// All available theme modes for Saranidhi.
enum AppThemeMode {
  light,
  dark,
  emerald,
  gold;

  /// Converts string to [AppThemeMode]. Returns [light] as fallback.
  static AppThemeMode fromString(String value) {
    return AppThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemeMode.light,
    );
  }
}

/// Generates Material 3 [ThemeData] for each [AppThemeMode].
class AppTheme {
  const AppTheme._();

  static ThemeData getTheme(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => _lightTheme,
      AppThemeMode.dark => _darkTheme,
      AppThemeMode.emerald => _emeraldTheme,
      AppThemeMode.gold => _goldTheme,
    };
  }

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    fontFamily: 'Roboto',
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
  );

  static final ThemeData _emeraldTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
    fontFamily: 'Roboto',
  );

  static final ThemeData _goldTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8F00)),
    fontFamily: 'Roboto',
  );
}
