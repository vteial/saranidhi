import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _accentKey = 'theme_accent';
const _brightnessKey = 'theme_brightness';

/// Combined theme state.
class ThemeState {
  const ThemeState({
    this.accent = ThemeAccent.defaultPurple,
    this.brightness = ThemeBrightness.system,
  });

  final ThemeAccent accent;
  final ThemeBrightness brightness;
}

/// Provides and persists the current theme configuration.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    _loadFromPrefs();
    return const ThemeState();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final accentName = prefs.getString(_accentKey);
    final brightnessName = prefs.getString(_brightnessKey);

    final accent = accentName != null
        ? ThemeAccent.values.firstWhere(
            (e) => e.name == accentName,
            orElse: () => ThemeAccent.defaultPurple,
          )
        : ThemeAccent.defaultPurple;

    final brightness = brightnessName != null
        ? ThemeBrightness.values.firstWhere(
            (e) => e.name == brightnessName,
            orElse: () => ThemeBrightness.system,
          )
        : ThemeBrightness.system;

    state = ThemeState(accent: accent, brightness: brightness);
  }

  Future<void> setAccent(ThemeAccent accent) async {
    state = ThemeState(accent: accent, brightness: state.brightness);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accentKey, accent.name);
  }

  Future<void> setBrightness(ThemeBrightness brightness) async {
    state = ThemeState(accent: state.accent, brightness: brightness);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_brightnessKey, brightness.name);
  }
}
