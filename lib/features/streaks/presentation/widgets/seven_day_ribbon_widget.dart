import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Compact 7-day calendar ribbon with status indicators.
class SevenDayRibbonWidget extends StatelessWidget {
  const SevenDayRibbonWidget({required this.ribbon, super.key});

  final List<RibbonDay> ribbon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sevenDayRibbon, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ribbon.map((day) => _DayChip(day: day)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.day});

  final RibbonDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          _localizedDayLabel(context, day.date),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _bgColor(day.status, theme),
            border: Border.all(
              color: _borderColor(day.status, theme),
              width: 2,
            ),
          ),
          child: Center(child: _icon(day.status, theme)),
        ),
      ],
    );
  }

  String _localizedDayLabel(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    return switch (date.weekday) {
      1 => l10n.dayMon,
      2 => l10n.dayTue,
      3 => l10n.dayWed,
      4 => l10n.dayThu,
      5 => l10n.dayFri,
      6 => l10n.daySat,
      7 => l10n.daySun,
      _ => '',
    };
  }

  Color _bgColor(DayStatus status, ThemeData theme) => switch (status) {
    DayStatus.aligned => theme.colorScheme.primaryContainer,
    DayStatus.unaligned => theme.colorScheme.errorContainer,
    DayStatus.noEntry => theme.colorScheme.surfaceContainerHighest,
    DayStatus.future => Colors.transparent,
  };

  Color _borderColor(DayStatus status, ThemeData theme) => switch (status) {
    DayStatus.aligned => theme.colorScheme.primary,
    DayStatus.unaligned => theme.colorScheme.error,
    DayStatus.noEntry => theme.colorScheme.outlineVariant,
    DayStatus.future => theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
  };

  Widget _icon(DayStatus status, ThemeData theme) => switch (status) {
    DayStatus.aligned => Icon(
      Icons.check,
      size: 16,
      color: theme.colorScheme.primary,
    ),
    DayStatus.unaligned => Icon(
      Icons.close,
      size: 16,
      color: theme.colorScheme.error,
    ),
    DayStatus.noEntry => Icon(
      Icons.remove,
      size: 16,
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    ),
    DayStatus.future => const SizedBox.shrink(),
  };
}
