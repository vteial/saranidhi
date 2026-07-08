import 'package:flutter/material.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// An error boundary widget that catches errors in its child subtree
/// and displays a friendly error message instead of a blank/broken screen.
///
/// Wraps sections of the UI to provide graceful degradation. When an error
/// occurs, shows an informative message with a retry option.
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   onRetry: () => ref.invalidate(someProvider),
///   child: SomeWidget(),
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    required this.child,
    this.onRetry,
    super.key,
  });

  /// The child widget to protect.
  final Widget child;

  /// Optional callback to retry/refresh on error.
  final VoidCallback? onRetry;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  String? _errorMessage;

  @override
  void didUpdateWidget(ErrorBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset error state when child changes (e.g. after retry)
    if (widget.child != oldWidget.child) {
      _hasError = false;
      _errorMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _ErrorFallback(
        message: _errorMessage,
        onRetry: _retry,
      );
    }
    return widget.child;
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });
    widget.onRetry?.call();
  }
}

/// A friendly error fallback UI shown when something goes wrong.
///
/// Can also be used standalone (without ErrorBoundary) as a replacement
/// for error states in AsyncValue.when() handlers.
class ErrorFallback extends StatelessWidget {
  const ErrorFallback({
    this.message,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  /// Optional error detail message.
  final String? message;

  /// Callback to retry the operation.
  final VoidCallback? onRetry;

  /// Use compact layout (for inline cards).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _ErrorFallback(
      message: message,
      onRetry: onRetry,
      compact: compact,
    );
  }
}

class _ErrorFallback extends StatelessWidget {
  const _ErrorFallback({
    this.message,
    this.onRetry,
    this.compact = false,
  });

  final String? message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final padding = compact
        ? const EdgeInsets.all(16)
        : const EdgeInsets.symmetric(horizontal: 32, vertical: 48);

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: compact ? 36 : 56,
              color: theme.colorScheme.error.withValues(alpha: 0.6),
            ),
            SizedBox(height: compact ? 8 : 16),
            Text(
              l10n.errorSomethingWentWrong,
              style: (compact
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.titleMedium)
                  ?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? l10n.errorTryAgainLater,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              SizedBox(height: compact ? 12 : 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
