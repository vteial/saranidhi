import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_flame_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/trend_widget.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/yama_accuracy_widget.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

/// The Home/Dashboard screen.
///
/// Displays streak flame, 7-day ribbon, 30-day trend, and Yama accuracy.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: const BrandedAppBar(title: 'Saranidhi'),
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
                Text('Error loading dashboard: $error'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(dashboardDataProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Streak flame
          StreakFlameWidget(streak: data.streak),
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
    );
  }
}
