import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/providers/location_on_open_provider.dart';
import 'package:saranidhi/core/providers/profile_location_provider.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Requests the browser geolocation once on app open (web only) and, if the
/// user has moved more than 5 km from their stored location, updates the
/// profile and refreshes location-dependent providers.
///
/// Shows a one-time SnackBar notice when the location is auto-updated so the
/// user understands why timings changed. On non-web platforms this is a no-op
/// (the geolocation facade resolves to a stub returning null).
///
/// Place near the top of the widget tree (below [ProviderScope]).
class LocationOnOpenWidget extends ConsumerStatefulWidget {
  const LocationOnOpenWidget({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<LocationOnOpenWidget> createState() =>
      _LocationOnOpenWidgetState();
}

class _LocationOnOpenWidgetState extends ConsumerState<LocationOnOpenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocation();
    });
  }

  Future<void> _checkLocation() async {
    final result = await ref.read(locationOnOpenProvider.future);
    if (!result.updated || !mounted) return;

    // Refresh location-dependent data so timings reflect the new position.
    ref.invalidate(profileLocationProvider);
    ref.invalidate(dashboardDataProvider);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.locationUpdatedNotice),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
