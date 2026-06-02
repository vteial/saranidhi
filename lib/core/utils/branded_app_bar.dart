import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A branded AppBar with the Saranidhi logo.
///
/// On medium/large screens (>= 600px), shows logo + app title together.
/// On small screens, shows just the page title with logo as leading.
class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandedAppBar({required this.title, super.key});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 600;

    if (isWide) {
      // Medium/Large: logo + app name in title area
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
      );
    }

    // Small: logo as leading icon, title centered
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset('public/logo.svg', width: 24, height: 24),
      ),
      title: Text(title),
      centerTitle: true,
    );
  }
}
