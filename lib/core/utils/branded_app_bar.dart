import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A branded AppBar with the Saranidhi logo.
///
/// On medium/large screens (>= 600px), shows logo + title together in center.
/// On small screens, shows logo as leading icon with title centered.
///
/// Supports an optional [bottom] widget (e.g. TabBar).
class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandedAppBar({required this.title, this.bottom, super.key});

  final String title;

  /// Optional widget displayed below the app bar (e.g. a [TabBar]).
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 600;

    if (isWide) {
      return AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('public/logo.svg', width: 28, height: 28),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        centerTitle: true,
        bottom: bottom,
      );
    }

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset('public/logo.svg', width: 24, height: 24),
      ),
      title: Text(title),
      centerTitle: true,
      bottom: bottom,
    );
  }
}
