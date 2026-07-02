import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/ai_wisdom/presentation/widgets/wisdom_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/home/presentation/widgets/hold_time_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_flame_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/trend_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/yama_accuracy_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The Home/Dashboard screen.
///
/// Displays personalized guidance hub: birth bird state, nostril dominance,
/// Rahu Kaal, full-day schedule, hold time, streak, trend, wisdom, and
/// yama accuracy.
/// Supports pull-to-refresh to reload dashboard data.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: BrandedAppBar(title: l10n.dashboardTitle),
      body: dashboardAsync.when(
        data: (data) => _DashboardContent(data: data),
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
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600; // Medium+ devices

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dashboardDataProvider);
        // Wait for the provider to settle
        await ref.read(dashboardDataProvider.future);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Birth Bird Card + Rahu Kaal (two-column on wide)
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
              // Single column on narrow
              if (data.birthBird != null) BirthBirdCard(data: data),
              const SizedBox(height: 12),
              if (data.rahuKaal != null)
                RahuKaalCard(rahuKaal: data.rahuKaal!),
            ],
            const SizedBox(height: 12),

            // Row 2: Nostril Pattern + Today's Schedule (two-column on wide)
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.yamaResult != null)
                    Expanded(child: NostrilDominanceChart(data: data)),
                  if (data.yamaResult != null &&
                      data.pakshiDay != null &&
                      data.birthBird != null)
                    const SizedBox(width: 12),
                  if (data.pakshiDay != null && data.birthBird != null)
                    Expanded(child: FullDaySchedule(data: data)),
                ],
              )
            else ...[
              // Single column on narrow
              if (data.yamaResult != null) NostrilDominanceChart(data: data),
              const SizedBox(height: 12),
              if (data.pakshiDay != null && data.birthBird != null)
                FullDaySchedule(data: data),
            ],
            const SizedBox(height: 12),

            // 5. Hold Time + Streak (two-column on wide)
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

            // 6. 7-day ribbon
            SevenDayRibbonWidget(ribbon: data.ribbon),
            const SizedBox(height: 12),

            // 7. 30-day trend
            TrendWidget(trend: data.trend),
            const SizedBox(height: 12),

            // 8. Daily Wisdom
            const WisdomCard(),
            const SizedBox(height: 12),

            // 9. Yama Coverage
            YamaAccuracyWidget(accuracy: data.yamaAccuracy),
          ],
        ),
      ),
    );
  }
}
