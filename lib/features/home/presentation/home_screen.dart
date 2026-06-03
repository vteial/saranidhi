import 'package:flutter/material.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/ai_wisdom/presentation/widgets/wisdom_card.dart';
import 'package:saranidhi/features/home/presentation/widgets/astro_info_bar.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_flame_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/trend_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/yama_accuracy_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// The Home/Dashboard screen.
///
/// Displays streak flame, 7-day ribbon, 30-day trend, and Yama accuracy.
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
            // Astro info (sunrise, sunset, bird state)
            const AstroInfoBar(),
            const SizedBox(height: 12),

            // Streak flame
            StreakFlameWidget(streak: data.streak),
            const SizedBox(height: 12),

            // AI Wisdom Card
            const WisdomCard(),
            const SizedBox(height: 12),

            // 7-day ribbon
            SevenDayRibbonWidget(ribbon: data.ribbon),
            const SizedBox(height: 12),

            // 30-day trend
            TrendWidget(trend: data.trend),
            const SizedBox(height: 12),

            // Yama accuracy
            YamaAccuracyWidget(accuracy: data.yamaAccuracy),
          ],
        ),
      ),
    );
  }
}
