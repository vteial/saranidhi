import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/features/ai_wisdom/presentation/widgets/wisdom_card.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/home/presentation/widgets/hold_time_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_flame_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);

    return dashboardAsync.when(
      data: (data) => _TodayContent(data: data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(l10n.errorLoadingDashboard(error.toString())),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(dashboardDataProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
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
                      Expanded(child: RahuKaalCard(rahuKaal: data.rahuKaal!)),
                  ],
                ),
              )
            else ...[
              if (data.birthBird != null) BirthBirdCard(data: data),
              const SizedBox(height: 12),
              if (data.rahuKaal != null)
                RahuKaalCard(rahuKaal: data.rahuKaal!),
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
