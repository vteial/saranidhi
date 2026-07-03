import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/core/utils/nakshatra_l10n.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_trigger_service.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays and allows editing of the user profile.
class ProfileCard extends ConsumerStatefulWidget {
  const ProfileCard({super.key});

  @override
  ConsumerState<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends ConsumerState<ProfileCard> {
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final db = ref.read(appDatabaseProvider);
    final profiles = await db.select(db.profiles).get();
    if (profiles.isNotEmpty && mounted) {
      setState(() {
        _nameController.text = profiles.first.displayName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return FutureBuilder(
      future: ref
          .read(appDatabaseProvider)
          .select(ref.read(appDatabaseProvider).profiles)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final profile = snapshot.data!.first;
        final birdName = profile.birthBird;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(l10n.profile, style: theme.textTheme.titleSmall),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_isEditing) {
                          _saveProfile();
                        }
                        setState(() => _isEditing = !_isEditing);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Name
                if (_isEditing)
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      profile.displayName.isEmpty
                          ? l10n.notSet
                          : profile.displayName,
                    ),
                    subtitle: Text(l10n.name),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                const SizedBox(height: 8),
                // Birth Star + Bird
                ListTile(
                  leading: Text(
                    BirdEmoji.forBirdName(birdName),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    profile.birthStarNakshatra != null
                        ? NakshatraL10n.localizedDisplay(
                            profile.birthStarNakshatra!,
                            isTamil: l10n.localeName == 'ta',
                          )
                        : l10n.notSet,
                  ),
                  subtitle: Text(
                    birdName != null
                        ? l10n.birthBird(
                            _localizedBirdName(birdName, l10n),
                          )
                        : l10n.birthStar,
                  ),
                  trailing: _isEditing
                      ? IconButton(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: () => _editBirthStar(context),
                        )
                      : null,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                // Location
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    profile.locationLat != null
                        ? '${profile.locationLat!.toStringAsFixed(2)}, ${profile.locationLng!.toStringAsFixed(2)}'
                        : l10n.notSet,
                  ),
                  subtitle: Text(l10n.location),
                  trailing: _isEditing
                      ? IconButton(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: () => _editLocation(context),
                        )
                      : null,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final db = ref.read(appDatabaseProvider);
    final profiles = await db.select(db.profiles).get();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    await (db.update(db.profiles)..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(
        displayName: drift.Value(_nameController.text),
        updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );

    // Push updated profile to iCloud
    final updatedProfile = await (db.select(db.profiles)
          ..where((t) => t.id.equals(profile.id)))
        .getSingleOrNull();
    if (updatedProfile != null) {
      await ref.read(syncTriggerServiceProvider).onProfileUpdated(updatedProfile);
    }

    setState(() {});
  }

  void _editBirthStar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changeBirthStar),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.changeBirthStarWarning,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: allNakshatras.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(
                      NakshatraL10n.localizedDisplay(
                        allNakshatras[i],
                        isTamil: l10n.localeName == 'ta',
                      ),
                    ),
                    dense: true,
                    onTap: () => Navigator.of(ctx).pop(allNakshatras[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((selected) async {
      if (selected == null) return;
      final bird = PakshiCalculator.birthBirdFromNakshatraSafe(selected);
      final db = ref.read(appDatabaseProvider);
      final profiles = await db.select(db.profiles).get();
      if (profiles.isEmpty) return;

      await (db.update(
        db.profiles,
      )..where((t) => t.id.equals(profiles.first.id))).write(
        ProfilesCompanion(
          birthStarNakshatra: drift.Value(selected),
          birthBird: drift.Value(bird?.name),
          updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

      // Push updated profile to iCloud
      final updatedProfile = await (db.select(db.profiles)
            ..where((t) => t.id.equals(profiles.first.id)))
          .getSingleOrNull();
      if (updatedProfile != null) {
        await ref.read(syncTriggerServiceProvider).onProfileUpdated(
          updatedProfile,
        );
      }

      setState(() {});
    });
  }

  /// Returns the localized bird name from the stored enum name string.
  String _localizedBirdName(String birdEnumName, AppLocalizations l10n) {
    final bird = PakshiBird.values.where((b) => b.name == birdEnumName).firstOrNull;
    if (bird == null) return birdEnumName;
    return bird.localizedName(l10n);
  }

  void _editLocation(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.changeLocation),
        children: [
          for (final city in _presetCities)
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final db = ref.read(appDatabaseProvider);
                final profiles = await db.select(db.profiles).get();
                if (profiles.isEmpty) return;

                await (db.update(
                  db.profiles,
                )..where((t) => t.id.equals(profiles.first.id))).write(
                  ProfilesCompanion(
                    locationLat: drift.Value(city.lat),
                    locationLng: drift.Value(city.lng),
                    updatedAt: drift.Value(
                      DateTime.now().millisecondsSinceEpoch,
                    ),
                  ),
                );
                setState(() {});
              },
              child: Text(city.name),
            ),
        ],
      ),
    );
  }
}

class _PresetCity {
  const _PresetCity(this.name, this.lat, this.lng);
  final String name;
  final double lat;
  final double lng;
}

const _presetCities = [
  _PresetCity('Chennai', 13.08, 80.27),
  _PresetCity('Mumbai', 19.08, 72.88),
  _PresetCity('Delhi', 28.61, 77.21),
  _PresetCity('Bangalore', 12.97, 77.59),
  _PresetCity('Hyderabad', 17.39, 78.49),
  _PresetCity('Kolkata', 22.57, 88.36),
  _PresetCity('London', 51.51, -0.13),
  _PresetCity('New York', 40.71, -74.01),
  _PresetCity('Singapore', 1.35, 103.82),
  _PresetCity('Sydney', -33.87, 151.21),
];
