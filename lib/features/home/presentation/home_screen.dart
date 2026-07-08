import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/home/presentation/explore_tab.dart';
import 'package:saranidhi/features/home/presentation/today_tab.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The Home/Dashboard screen.
///
/// Split into two sub-tabs:
/// - **Today** (default): focused live data for the current day.
/// - **Explore**: date navigation, historical/future schedule views.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  /// When switching to the Today tab, reset the selected date to now.
  void _onTabChanged() {
    if (!_tabController.indexIsChanging && _tabController.index == 0) {
      ref.read(selectedDateProvider.notifier).select(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: BrandedAppBar(
        title: l10n.dashboardTitle,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: [
              Tab(text: l10n.todayTab),
              Tab(text: l10n.exploreTab),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TodayTab(),
          ExploreTab(),
        ],
      ),
    );
  }
}
