import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const _themeKey = 'app_theme_mode';

/// Provides and persists the current [AppThemeMode].
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  AppThemeMode build() {
    _loadFromPrefs();
    return AppThemeMode.light;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);
    if (saved != null) {
      state = AppThemeMode.fromString(saved);
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}
