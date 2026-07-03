import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/l10n/locale_provider.dart';
import 'package:saranidhi/features/ai_wisdom/data/wisdom_cache.dart';
import 'package:saranidhi/features/ai_wisdom/domain/fallback_handler.dart';
import 'package:saranidhi/features/ai_wisdom/domain/rules_engine.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_context.dart';

/// Provides the daily wisdom insight.
///
/// Flow:
/// 1. Check cache — if valid for today AND same locale, return cached
/// 2. Build context from current state
/// 3. Run rules engine with current locale
/// 4. If rules engine fails → fallback handler with locale
/// 5. Cache result for the day
///
/// Automatically invalidates when locale changes (watches localeProvider).
final wisdomInsightProvider = FutureProvider<String>((ref) async {
  // Watch locale so wisdom refreshes when language is switched
  final appLocale = ref.watch(localeProvider);
  final locale = appLocale.code;

  // Step 1: Check cache (invalidate if locale changed)
  final cached = await WisdomCache.getCached();
  final cachedLocale = await WisdomCache.getCachedLocale();
  if (cached != null && cachedLocale == locale) return cached;

  // Step 2: Build context (simplified — uses defaults for now)
  const context = WisdomContext(currentStreak: 0, weeklyAccuracy: 0);

  // Step 3: Generate via rules engine with locale
  String wisdom;
  try {
    wisdom = RulesEngine.generate(context, locale: locale);
  } on Exception {
    // Step 4: Fallback with locale
    wisdom = FallbackHandler.todaysProverb(locale: locale);
  }

  // Step 5: Cache with locale
  await WisdomCache.cache(wisdom, locale: locale);

  // Auto-invalidate at midnight for fresh insight
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1);
  final timeUntilMidnight = midnight.difference(now);
  final timer = Timer(timeUntilMidnight, () {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);

  return wisdom;
});
