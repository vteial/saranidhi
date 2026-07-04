import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';
import 'package:saranidhi/features/home/presentation/widgets/best_times_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/calendar_month_view.dart';
import 'package:saranidhi/features/home/presentation/widgets/date_selector.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/home/presentation/widgets/historical_entries_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/trend_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);

    return dashboardAsync.when(
      data: (data) => _ExploreContent(data: data),
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

            // Calendar month view
            const CalendarMonthView(),
            const SizedBox(height: 12),

            // Selected date's Pakshi schedule
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.birthBird != null)
                    Expanded(child: BirthBirdCard(data: data)),
                  if (data.birthBird != null && data.rahuKaal != null)
                    const SizedBox(width: 12),
                  if (data.rahuKaal != null)
                    Expanded(child: RahuKaalCard(rahuKaal: data.rahuKaal!)),
                ],
              )
            else ...[
              if (data.birthBird != null) BirthBirdCard(data: data),
              if (data.birthBird != null) const SizedBox(height: 12),
              if (data.rahuKaal != null)
                RahuKaalCard(rahuKaal: data.rahuKaal!),
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
