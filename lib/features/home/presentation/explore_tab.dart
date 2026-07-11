import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/widgets/error_boundary.dart';
import 'package:saranidhi/core/widgets/shimmer_loading.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';
import 'package:saranidhi/features/home/presentation/widgets/best_times_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/date_selector.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/home/presentation/widgets/historical_entries_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/trend_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// The "Explore" sub-tab on the Home screen.
///
/// Provides date navigation and historical/future views:
/// Date Selector, Calendar Month View, Historical Entries,
/// Best Times This Week, 30-Day Trend, selected date's Pakshi schedule.
class ExploreTab extends ConsumerWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return dashboardAsync.when(
      data: (data) => _ExploreContent(data: data),
      loading: () => const ShimmerLoading(),
      error: (error, stack) => ErrorFallback(
        message: error.toString(),
        onRetry: () => ref.invalidate(dashboardDataProvider),
      ),
    );
  }
}

class _ExploreContent extends ConsumerWidget {
  const _ExploreContent({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;
    final isViewingToday = ref.watch(isViewingTodayProvider);

    return RefreshIndicator(
      onRefresh: () async {
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
            // Date selector row
            const DateSelector(),
            const SizedBox(height: 12),

            // Selected date's Pakshi schedule
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
                      )),
                  ],
                ),
              )
            else ...[
              if (data.birthBird != null) BirthBirdCard(data: data),
              if (data.birthBird != null) const SizedBox(height: 12),
              if (data.rahuKaal != null)
                RahuKaalCard(
                  rahuKaal: data.rahuKaal!,
                  kuligaiKaal: data.kuligaiKaal,
                  emakandam: data.emakandam,
                  sunrise: data.sunrise,
                  sunset: data.sunset,
                  lunarPhase: data.lunarPhase,
                ),
              if (data.rahuKaal != null) const SizedBox(height: 12),
            ],

            // Full day schedule for selected date
            if (data.pakshiDay != null && data.birthBird != null)
              FullDaySchedule(data: data),
            if (data.pakshiDay != null && data.birthBird != null)
              const SizedBox(height: 12),

            // Nostril dominance for selected date
            if (data.yamaResult != null) NostrilDominanceChart(data: data),
            if (data.yamaResult != null) const SizedBox(height: 12),

            // Historical entries (shown when viewing a past date)
            if (!isViewingToday) const HistoricalEntriesCard(),
            if (!isViewingToday) const SizedBox(height: 12),

            // Best times this week (shown when viewing today or future)
            if (isViewingToday) const BestTimesCard(),
            if (isViewingToday) const SizedBox(height: 12),

            // 30-day trend
            TrendWidget(trend: data.trend),
          ],
        ),
      ),
    );
  }
}
