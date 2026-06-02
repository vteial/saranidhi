import 'package:flutter/material.dart';

/// Maximum content width for large screens (desktop/tablet landscape).
const double kMaxContentWidth = 1200;

/// A responsive wrapper that constrains content to [kMaxContentWidth]
/// centered horizontally on large screens (> 1200px).
///
/// On small/medium devices, content remains full-width with no constraint.
class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        child: child,
      ),
    );
  }
}
