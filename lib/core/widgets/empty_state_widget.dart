import 'package:flutter/material.dart';

/// A reusable empty state widget that displays an icon, title, subtitle,
/// and optional action button when a section has no data to show.
///
/// Used throughout the app for consistent empty state UX:
/// - Journal (no entries)
/// - Analytics (insufficient data)
/// - Explore tab (no historical entries)
/// - Streak (zero state)
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 64,
    this.compact = false,
    super.key,
  });

  /// The icon to display prominently.
  final IconData icon;

  /// Primary message (e.g. "No entries yet").
  final String title;

  /// Supporting guidance text.
  final String subtitle;

  /// Optional action button label.
  final String? actionLabel;

  /// Callback for optional action button.
  final VoidCallback? onAction;

  /// Icon size (default 64).
  final double iconSize;

  /// Whether to use compact spacing (for inline cards).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
        : const EdgeInsets.symmetric(horizontal: 32, vertical: 48);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          SizedBox(height: compact ? 12 : 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
