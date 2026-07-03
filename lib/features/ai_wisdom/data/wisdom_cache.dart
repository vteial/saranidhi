import 'package:shared_preferences/shared_preferences.dart';

/// Caches the daily wisdom insight to avoid regenerating on every app open.
///
/// Cache expires at midnight — a new insight is generated each day.
/// Also invalidates when locale changes (Tamil ↔ English).
class WisdomCache {
  const WisdomCache._();

  static const _cacheKey = 'cached_wisdom_insight';
  static const _cacheDateKey = 'cached_wisdom_date';
  static const _cacheLocaleKey = 'cached_wisdom_locale';

  /// Returns cached wisdom if still valid (same day), otherwise null.
  static Future<String?> getCached() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDate = prefs.getString(_cacheDateKey);
    final todayKey = _todayKey();

    if (cachedDate == todayKey) {
      return prefs.getString(_cacheKey);
    }
    return null; // Cache expired (new day)
  }

  /// Returns the locale of the cached wisdom (or null if no cache).
  static Future<String?> getCachedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cacheLocaleKey);
  }

  /// Stores wisdom with today's date stamp and locale.
  static Future<void> cache(String wisdom, {String locale = 'en'}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, wisdom);
    await prefs.setString(_cacheDateKey, _todayKey());
    await prefs.setString(_cacheLocaleKey, locale);
  }

  /// Clears the cache (forces regeneration).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheDateKey);
    await prefs.remove(_cacheLocaleKey);
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }
}
