import 'package:saranidhi/features/ai_wisdom/domain/wisdom_context.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_library.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_library_ta.dart';

/// Rules-based wisdom engine for the web platform.
///
/// Matches the current [WisdomContext] against a priority-ordered set of
/// rules to select the most relevant wisdom. Falls back to general proverbs
/// if no specific rule matches.
///
/// Supports locale-aware selection: pass `locale` ('ta' for Tamil,
/// defaults to English for any other value).
class RulesEngine {
  const RulesEngine._();

  /// Generates a wisdom insight based on the current context.
  ///
  /// Priority order:
  /// 1. Rahu Kaal (if active — override all others)
  /// 2. Streak-based (high streak encouragement or restart motivation)
  /// 3. Tattva-specific (element active)
  /// 4. Bird state-specific
  /// 5. Hora-specific
  /// 6. General fallback
  static String generate(WisdomContext context, {String locale = 'en'}) {
    final isTamil = locale == 'ta';

    // Priority 1: Rahu Kaal
    if (context.isRahuKaal) {
      return _pickByDate(
        isTamil
            ? WisdomLibraryTa.rahuKaalWisdom
            : WisdomLibrary.rahuKaalWisdom,
      );
    }

    // Priority 2: Streak-based
    if (context.currentStreak >= 5) {
      return _pickByDate(
        isTamil
            ? WisdomLibraryTa.highStreakWisdom
            : WisdomLibrary.highStreakWisdom,
      );
    }
    if (context.currentStreak == 0) {
      return _pickByDate(
        isTamil
            ? WisdomLibraryTa.noStreakWisdom
            : WisdomLibrary.noStreakWisdom,
      );
    }

    // Priority 3: Tattva
    if (context.activeTattva != null) {
      final key = context.activeTattva!.displayName;
      final entries = isTamil
          ? WisdomLibraryTa.tattvaWisdom[key]
          : WisdomLibrary.tattvaWisdom[key];
      if (entries != null && entries.isNotEmpty) {
        return _pickByDate(entries);
      }
    }

    // Priority 4: Bird state
    if (context.activeBirdState != null) {
      final key = context.activeBirdState!.name;
      final entries = isTamil
          ? WisdomLibraryTa.birdStateWisdom[key]
          : WisdomLibrary.birdStateWisdom[key];
      if (entries != null && entries.isNotEmpty) {
        return _pickByDate(entries);
      }
    }

    // Priority 5: Hora
    if (context.activeHora != null) {
      final key = context.activeHora!.displayName;
      final entries = isTamil
          ? WisdomLibraryTa.horaWisdom[key]
          : WisdomLibrary.horaWisdom[key];
      if (entries != null && entries.isNotEmpty) {
        return _pickByDate(entries);
      }
    }

    // Priority 6: General fallback
    return _pickByDate(
      isTamil ? WisdomLibraryTa.generalWisdom : WisdomLibrary.generalWisdom,
    );
  }

  /// Deterministic selection based on date (same date = same wisdom).
  static String _pickByDate(List<String> entries) {
    final today = DateTime.now();
    final daysSinceEpoch = today.difference(DateTime(2000)).inDays;
    final index = daysSinceEpoch % entries.length;
    return entries[index];
  }
}
