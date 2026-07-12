import 'package:flutter/material.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window_segment.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Shows the expansion bottom sheet with raw Pakshi/Hora/Tattva details
/// for the current action window segment.
void showActionWindowSheet(
  BuildContext context, {
  required ActionWindowSegment segment,
  required List<ActionWindowSegment> allSegments,
  PakshiBird? userBird,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _ActionWindowSheetContent(
      segment: segment,
      allSegments: allSegments,
      userBird: userBird,
    ),
  );
}

class _ActionWindowSheetContent extends StatelessWidget {
  const _ActionWindowSheetContent({
    required this.segment,
    required this.allSegments,
    this.userBird,
  });

  final ActionWindowSegment segment;
  final List<ActionWindowSegment> allSegments;
  final PakshiBird? userBird;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ListView(
          controller: scrollController,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Bird hero row (fills the empty space)
            if (userBird != null) ...[
              Row(
                children: [
                  Text(
                    BirdEmoji.forBird(userBird!),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.actionWindowSheetTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${userBird!.localizedName(l10n)} \u2014 ${l10n.actionWindowSheetSchedule}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ] else ...[
              Text(
                l10n.actionWindowSheetTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Current segment detail
            _SegmentDetailCard(
              segment: segment,
              isCurrent: true,
              theme: theme,
              l10n: l10n,
            ),
            const SizedBox(height: 14),

            // Full day schedule
            Text(
              l10n.actionWindowSheetSchedule,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            ...allSegments.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _SegmentDetailCard(
                  segment: s,
                  isCurrent: s == segment,
                  theme: theme,
                  l10n: l10n,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SegmentDetailCard extends StatelessWidget {
  const _SegmentDetailCard({
    required this.segment,
    required this.isCurrent,
    required this.theme,
    required this.l10n,
  });

  final ActionWindowSegment segment;
  final bool isCurrent;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = _colorForWindow(segment.window);
    final startTime = _formatTime(segment.start);
    final endTime = _formatTime(segment.end);
    final durationMin = segment.duration.inMinutes;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: isCurrent
            ? Border.all(color: color.withValues(alpha: 0.5), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          // Window icon
          Icon(
            _iconForWindow(segment.window),
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _localizedWindowName(segment.window, l10n),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCurrent ? color : null,
                  ),
                ),
                Text(
                  '${_localizedBirdState(segment.birdStateName, l10n)} \u2022 ${durationMin}min',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Time range
          Text(
            '$startTime\u2013$endTime',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (segment.isBlockedByRahu) ...[
            const SizedBox(width: 6),
            Icon(Icons.warning_amber, size: 16, color: Colors.red.shade400),
          ],
          if (isCurrent) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'NOW',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _colorForWindow(ActionWindow window) {
    return switch (window) {
      ActionWindow.artha => Colors.green.shade700,
      ActionWindow.kriya => Colors.blue.shade700,
      ActionWindow.yoga => Colors.purple.shade700,
    };
  }

  IconData _iconForWindow(ActionWindow window) {
    return switch (window) {
      ActionWindow.artha => Icons.bolt,
      ActionWindow.kriya => Icons.restaurant,
      ActionWindow.yoga => Icons.self_improvement,
    };
  }

  /// Returns localized window name using l10n keys.
  String _localizedWindowName(ActionWindow window, AppLocalizations l10n) {
    return switch (window) {
      ActionWindow.artha => l10n.termArtha,
      ActionWindow.kriya => l10n.termKriya,
      ActionWindow.yoga => l10n.termYoga,
    };
  }

  /// Localizes bird state names that are stored as English display names.
  /// Splits on "/" for merged segments (e.g., "Ruling/Walking" → "ஆளுகை/நடத்தல்").
  String _localizedBirdState(String rawStates, AppLocalizations l10n) {
    final parts = rawStates.split('/');
    return parts.map((s) => _singleStateLocalized(s.trim(), l10n)).join('/');
  }

  String _singleStateLocalized(String state, AppLocalizations l10n) {
    return switch (state.toLowerCase()) {
      'ruling' => l10n.ruling,
      'eating' => l10n.eating,
      'walking' => l10n.walking,
      'sleeping' => l10n.sleeping,
      'dying' => l10n.dying,
      _ => state,
    };
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
