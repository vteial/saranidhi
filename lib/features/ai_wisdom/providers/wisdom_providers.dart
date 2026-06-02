import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/ai_wisdom/data/wisdom_cache.dart';
import 'package:saranidhi/features/ai_wisdom/domain/fallback_handler.dart';
import 'package:saranidhi/features/ai_wisdom/domain/rules_engine.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_context.dart';

/// Provides the daily wisdom insight.
///
/// Flow:
/// 1. Check cache — if valid for today, return cached
/// 2. Build context from current state
/// 3. Run rules engine
/// 4. If rules engine fails → fallback handler
/// 5. Cache result for the day
final wisdomInsightProvider = FutureProvider<String>((ref) async {
  // Step 1: Check cache
  final cached = await WisdomCache.getCached();
  if (cached != null) return cached;

  // Step 2: Build context (simplified — uses defaults for now)
  // In full implementation, this would read from streak/astro providers
  const context = WisdomContext(currentStreak: 0, weeklyAccuracy: 0);

  // Step 3: Generate via rules engine
  String wisdom;
  try {
    wisdom = RulesEngine.generate(context);
  } on Exception {
    // Step 4: Fallback
    wisdom = FallbackHandler.todaysProverb();
  }

  // Step 5: Cache
  await WisdomCache.cache(wisdom);

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
