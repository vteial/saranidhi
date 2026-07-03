import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// A single "best time" entry for one day.
class BestTimeEntry {
  const BestTimeEntry({
    required this.date,
    required this.rulingYamaStart,
    required this.rulingYamaEnd,
    required this.yamaNumber,
  });

  final DateTime date;
  final DateTime rulingYamaStart;
  final DateTime rulingYamaEnd;
  final int yamaNumber;
}

/// Provider that scans the next 7 days and finds when the user's birth bird
/// is in Ruling state.
final bestTimesProvider = FutureProvider<List<BestTimeEntry>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final profiles = await db.select(db.profiles).get();
  if (profiles.isEmpty) return [];

  final profile = profiles.first;
  if (profile.birthBird == null) return [];

  final birthBird = PakshiBird.values
      .where((b) => b.name == profile.birthBird)
      .firstOrNull;
  if (birthBird == null) return [];

  final lat = profile.locationLat ?? 13.08;
  final lng = profile.locationLng ?? 80.27;
  const utcOffset = 5.5;

  final entries = <BestTimeEntry>[];
  final today = DateTime.now();

  for (var i = 0; i < 7; i++) {
    final date = today.add(Duration(days: i));
    final sunResult = SunriseCalculator.calculate(
      date: date,
      latitude: lat,
      longitude: lng,
      utcOffset: utcOffset,
    );
    if (sunResult == null) continue;

    final yamaResult = YamaCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
    );

    final weekday = PakshiCalculator.dartWeekdayToSunBased(date.weekday);
    final lunarPhase = LunarPhaseCalculator.phaseForDate(date);
    final pakshiDay = PakshiCalculator.calculate(
      weekday: weekday,
      lunarPhase: lunarPhase,
    );

    // Find which yama the birth bird is Ruling
    for (final yama in yamaResult.yamas) {
      final state = pakshiDay.stateForBird(birthBird, yama.index);
      if (state == PakshiState.ruling) {
        entries.add(
          BestTimeEntry(
            date: date,
            rulingYamaStart: yama.start,
            rulingYamaEnd: yama.end,
            yamaNumber: yama.index.index + 1,
          ),
        );
        break; // Only first ruling yama per day
      }
    }
  }

  return entries;
});

/// Card showing "Best Times This Week" — when the user's birth bird
/// is in Ruling state over the next 7 days.
class BestTimesCard extends ConsumerWidget {
  const BestTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestTimesAsync = ref.watch(bestTimesProvider);
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final theme = Theme.of(context);

    return bestTimesAsync.when(
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();

        final birthBird = dashboardAsync.value?.birthBird;
        final birdEmoji = birthBird != null
            ? BirdEmoji.forBird(birthBird)
            : '\u{1F426}';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(birdEmoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Best Times This Week',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...entries.map(
                  (entry) => _BestTimeRow(entry: entry, theme: theme),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BestTimeRow extends StatelessWidget {
  const _BestTimeRow({required this.entry, required this.theme});

  final BestTimeEntry entry;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = entry.date.year == now.year &&
        entry.date.month == now.month &&
        entry.date.day == now.day;

    final dayLabel = isToday
        ? 'Today'
        : DateFormat('EEE, MMM d').format(entry.date);

    final timeRange =
        '${_formatTime(entry.rulingYamaStart)} – ${_formatTime(entry.rulingYamaEnd)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              dayLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.access_time,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            timeRange,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Y${entry.yamaNumber}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
