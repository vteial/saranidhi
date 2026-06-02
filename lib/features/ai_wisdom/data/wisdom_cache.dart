import 'package:shared_preferences/shared_preferences.dart';

/// Caches the daily wisdom insight to avoid regenerating on every app open.
///
/// Cache expires at midnight — a new insight is generated each day.
class WisdomCache {
  const WisdomCache._();

  static const _cacheKey = 'cached_wisdom_insight';
  static const _cacheDateKey = 'cached_wisdom_date';

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

  /// Stores wisdom with today's date stamp.
  static Future<void> cache(String wisdom) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, wisdom);
    await prefs.setString(_cacheDateKey, _todayKey());
  }

  /// Clears the cache (forces regeneration).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheDateKey);
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
