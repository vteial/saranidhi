import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/widgets/error_boundary.dart';
import 'package:saranidhi/core/widgets/shimmer_loading.dart';
import 'package:saranidhi/features/ai_wisdom/presentation/widgets/wisdom_card.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';
import 'package:saranidhi/features/home/presentation/widgets/action_bar.dart';
import 'package:saranidhi/features/home/presentation/widgets/action_window_sheet.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/focus_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/home/presentation/widgets/hold_time_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_flame_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// The "Today" sub-tab on the Home screen.
///
/// Shows focused live data for the current day:
/// Birth Bird, Rahu Kaal, Full Day Schedule, Nostril Dominance,
/// Daily Wisdom, Hold Time + Streak, 7-Day Ribbon.
class TodayTab extends ConsumerWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return dashboardAsync.when(
      data: (data) => _TodayContent(data: data),
      loading: () => const ShimmerLoading(),
      error: (error, stack) => ErrorFallback(
        message: error.toString(),
        onRetry: () => ref.invalidate(dashboardDataProvider),
      ),
    );
  }
}

class _TodayContent extends ConsumerWidget {
  const _TodayContent({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger iCloud sync on pull-to-refresh if enabled
        final storageMode = ref.read(storageModeProvider);
        if (storageMode == StorageMode.icloud) {
          await ref.read(syncNotifierProvider.notifier).performSync();
        }
        ref.invalidate(dashboardDataProvider);
        await ref.read(dashboardDataProvider.future);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 0: Action Bar (24h timeline) + Focus Card
            if (data.actionWindowSegments != null &&
                data.actionWindowSegments!.isNotEmpty &&
                data.sunrise != null) ...[
              ActionBar(
                segments: data.actionWindowSegments!,
                dayStart: data.sunrise!,
                dayEnd: data.sunrise!.add(const Duration(hours: 24)),
                currentTime: DateTime.now(),
              ),
              const SizedBox(height: 8),
              if (data.activeActionWindow != null)
                FocusCard(
                  segment: data.activeActionWindow!,
                  onTap: () => showActionWindowSheet(
                    context,
                    segment: data.activeActionWindow!,
                    allSegments: data.actionWindowSegments!,
                  ),
                ),
              if (data.activeActionWindow != null) const SizedBox(height: 12),
            ],

            // Row 1: Birth Bird + Rahu Kaal (two-column on wide)
            if (isWide)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (data.birthBird != null)
                      Expanded(child: BirthBirdCard(data: data)),
                    if (data.birthBird != null && data.rahuKaal != null)
                      const SizedBox(width: 12),
                    if (data.rahuKaal != null)
                      Expanded(child: RahuKaalCard(
                        rahuKaal: data.rahuKaal!,
                        kuligaiKaal: data.kuligaiKaal,
                        emakandam: data.emakandam,
                        sunrise: data.sunrise,
                        sunset: data.sunset,
                        lunarPhase: data.lunarPhase,
                        activeHora: data.activeHora,
                      )),
                  ],
                ),
              )
            else ...[
              if (data.birthBird != null) BirthBirdCard(data: data),
              const SizedBox(height: 12),
              if (data.rahuKaal != null)
                RahuKaalCard(
                  rahuKaal: data.rahuKaal!,
                  kuligaiKaal: data.kuligaiKaal,
                  emakandam: data.emakandam,
                  sunrise: data.sunrise,
                  sunset: data.sunset,
                  lunarPhase: data.lunarPhase,
                  activeHora: data.activeHora,
                ),
            ],
            const SizedBox(height: 12),

            // Row 2: Full Day Schedule (always full width for readability)
            if (data.pakshiDay != null && data.birthBird != null)
              FullDaySchedule(data: data),
            if (data.pakshiDay != null && data.birthBird != null)
              const SizedBox(height: 12),

            // Row 3: Nostril Dominance
            if (data.yamaResult != null) NostrilDominanceChart(data: data),
            if (data.yamaResult != null) const SizedBox(height: 12),

            // Row 4: Daily Wisdom
            const WisdomCard(),
            const SizedBox(height: 12),

            // Row 5: Hold Time + Streak (two-column on wide)
            if (isWide)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: HoldTimeCard(
                        avgHoldMs: data.todayAvgHoldMs,
                        entryCount: data.todayEntryCount,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StreakFlameWidget(streak: data.streak),
                    ),
                  ],
                ),
              )
            else ...[
              HoldTimeCard(
                avgHoldMs: data.todayAvgHoldMs,
                entryCount: data.todayEntryCount,
              ),
              const SizedBox(height: 12),
              StreakFlameWidget(streak: data.streak),
            ],
            const SizedBox(height: 12),

            // Row 6: 7-Day Ribbon
            SevenDayRibbonWidget(ribbon: data.ribbon),
          ],
        ),
      ),
    );
  }
}
