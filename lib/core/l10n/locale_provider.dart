import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

/// Supported application locales.
enum AppLocale {
  english('en', 'English'),
  tamil('ta', 'தமிழ்');

  const AppLocale(this.code, this.displayName);

  final String code;
  final String displayName;

  Locale get locale => Locale(code);
}

/// Provides and persists the current locale selection.
final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    _loadFromPrefs();
    return AppLocale.english;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null) {
      final locale = AppLocale.values.firstWhere(
        (l) => l.code == code,
        orElse: () => AppLocale.english,
      );
      state = locale;
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.code);
  }
}
