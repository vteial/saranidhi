import 'package:flutter/material.dart';

import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Simple card showing today's average breath hold duration.
///
/// Displays "No entries yet today" if there are no entries.
class HoldTimeCard extends StatelessWidget {
  const HoldTimeCard({
    required this.avgHoldMs,
    required this.entryCount,
    super.key,
  });

  /// Average hold duration in milliseconds (null if no hold data).
  final double? avgHoldMs;

  /// Number of entries today.
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final String displayText;
    if (avgHoldMs == null || entryCount == 0) {
      displayText = l10n.noEntriesToday;
    } else {
      final seconds = (avgHoldMs! / 1000).toStringAsFixed(1);
      displayText = l10n.avgHold(seconds, entryCount);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Text('\uD83E\uDEE1', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todaysHold,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
