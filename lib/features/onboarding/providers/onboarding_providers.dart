import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_trigger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _onboardingCompleteKey = 'onboarding_complete';

/// Whether onboarding has been completed.
final onboardingCompleteProvider =
    NotifierProvider<OnboardingCompleteNotifier, bool>(
      OnboardingCompleteNotifier.new,
    );

class OnboardingCompleteNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadFromPrefs();
    return false; // Default: not completed
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> markComplete() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Resets onboarding state — used when all data is cleared.
  Future<void> reset() async {
    state = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompleteKey);
  }
}

/// Onboarding form state.
class OnboardingState {
  const OnboardingState({
    this.currentStep = 0,
    this.displayName = '',
    this.selectedNakshatra,
    this.birthBird,
    this.latitude,
    this.longitude,
    this.locationName,
    this.storageMode = 'local',
    this.isSaving = false,
  });

  final int currentStep;
  final String displayName;
  final String? selectedNakshatra;
  final PakshiBird? birthBird;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String storageMode;
  final bool isSaving;

  int get totalSteps => 4; // Welcome, Birth Star, Location, Storage Mode

  OnboardingState copyWith({
    int? currentStep,
    String? displayName,
    String? selectedNakshatra,
    PakshiBird? birthBird,
    double? latitude,
    double? longitude,
    String? locationName,
    String? storageMode,
    bool? isSaving,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      displayName: displayName ?? this.displayName,
      selectedNakshatra: selectedNakshatra ?? this.selectedNakshatra,
      birthBird: birthBird ?? this.birthBird,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      storageMode: storageMode ?? this.storageMode,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Manages the onboarding flow state.
final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );

class OnboardingNotifier extends Notifier<OnboardingState> {
  static const _uuid = Uuid();

  @override
  OnboardingState build() => const OnboardingState();

  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setDisplayName(String name) {
    state = state.copyWith(displayName: name);
  }

  void setNakshatra(String nakshatra) {
    PakshiBird? bird;
    final validBird = PakshiCalculator.birthBirdFromNakshatraSafe(nakshatra);
    bird = validBird;
    state = state.copyWith(selectedNakshatra: nakshatra, birthBird: bird);
  }

  void setLocation({
    required double latitude,
    required double longitude,
    String? name,
  }) {
    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
      locationName: name,
    );
  }

  void setStorageMode(String mode) {
    state = state.copyWith(storageMode: mode);
  }

  /// Saves the onboarding profile to the database and marks complete.
  Future<void> saveProfile() async {
    state = state.copyWith(isSaving: true);

    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();

    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: id,
            displayName: Value(state.displayName),
            birthStarNakshatra: Value(state.selectedNakshatra),
            birthBird: Value(state.birthBird?.name),
            locationLat: Value(state.latitude),
            locationLng: Value(state.longitude),
            storageMode: Value(state.storageMode),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // Push new profile to iCloud if sync enabled
    final profile = await (db.select(db.profiles)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (profile != null) {
      await ref.read(syncTriggerServiceProvider).onProfileUpdated(profile);
    }

    await ref.read(onboardingCompleteProvider.notifier).markComplete();
    state = state.copyWith(isSaving: false);
  }
}

/// List of all 27 Nakshatras for selection (alphabetical order).
const List<String> allNakshatras = [
  'Anuradha',
  'Ardra',
  'Ashlesha',
  'Ashwini',
  'Bharani',
  'Chitra',
  'Dhanishta',
  'Hasta',
  'Jyeshtha',
  'Krittika',
  'Magha',
  'Mrigashira',
  'Mula',
  'Punarvasu',
  'Purva Ashadha',
  'Purva Bhadrapada',
  'Purva Phalguni',
  'Pushya',
  'Revati',
  'Rohini',
  'Shatabhisha',
  'Shravana',
  'Swati',
  'Uttara Ashadha',
  'Uttara Bhadrapada',
  'Uttara Phalguni',
  'Vishakha',
];
