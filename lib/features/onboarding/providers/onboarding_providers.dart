import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/astro_engine/domain/nakshatra_calculator.dart';
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
    this.birthDate,
    this.birthTimeOfDay,
    this.birthPlaceName,
    this.birthPlaceLat,
    this.birthPlaceLng,
    this.calculatedNakshatra,
    this.isNearBoundary = false,
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
  // DOB fields (Sprint 21)
  final DateTime? birthDate;
  final TimeOfDay? birthTimeOfDay;
  final String? birthPlaceName;
  final double? birthPlaceLat;
  final double? birthPlaceLng;
  // Auto-calculated result (Sprint 21)
  final NakshatraResult? calculatedNakshatra;
  final bool isNearBoundary;
  // Current location (for sunrise/sunset)
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String storageMode;
  final bool isSaving;

  int get totalSteps => 5; // Welcome, Birth Star, DOB, Location, Storage Mode

  /// Whether the nakshatra was auto-calculated from DOB.
  bool get isAutoCalculated => calculatedNakshatra != null;

  OnboardingState copyWith({
    int? currentStep,
    String? displayName,
    String? selectedNakshatra,
    PakshiBird? birthBird,
    DateTime? birthDate,
    TimeOfDay? birthTimeOfDay,
    String? birthPlaceName,
    double? birthPlaceLat,
    double? birthPlaceLng,
    NakshatraResult? calculatedNakshatra,
    bool? isNearBoundary,
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
      birthDate: birthDate ?? this.birthDate,
      birthTimeOfDay: birthTimeOfDay ?? this.birthTimeOfDay,
      birthPlaceName: birthPlaceName ?? this.birthPlaceName,
      birthPlaceLat: birthPlaceLat ?? this.birthPlaceLat,
      birthPlaceLng: birthPlaceLng ?? this.birthPlaceLng,
      calculatedNakshatra: calculatedNakshatra ?? this.calculatedNakshatra,
      isNearBoundary: isNearBoundary ?? this.isNearBoundary,
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

  void setBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date);
  }

  void setBirthTime(TimeOfDay time) {
    state = state.copyWith(birthTimeOfDay: time);
  }

  void setBirthPlace({
    required double latitude,
    required double longitude,
    required String name,
  }) {
    state = state.copyWith(
      birthPlaceLat: latitude,
      birthPlaceLng: longitude,
      birthPlaceName: name,
    );
  }

  /// Calculates the birth nakshatra from DOB data and updates the
  /// selected nakshatra + birth bird accordingly.
  ///
  /// Requires at least `birthDate` to be set. If `birthTimeOfDay` is
  /// not set, defaults to 12:00 noon (midday approximation).
  void calculateFromDOB() {
    if (state.birthDate == null) return;

    // Build the UTC DateTime from DOB fields
    final date = state.birthDate!;
    final time = state.birthTimeOfDay ?? const TimeOfDay(hour: 12, minute: 0);

    // Construct birth moment in UTC (approximate — no timezone conversion
    // for birth place, as the Moon moves ~0.5°/hour which is well within
    // a nakshatra's 13.33° span for most timezone offsets)
    final birthMoment = DateTime.utc(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Calculate nakshatra
    final result = NakshatraCalculator.calculate(birthMoment);

    // Map to bird
    final bird = PakshiCalculator.birthBirdFromNakshatraSafe(
      result.standardName,
    );

    // Update state: set calculated result + override manual selection
    state = state.copyWith(
      calculatedNakshatra: result,
      isNearBoundary: result.isNearBoundary,
      selectedNakshatra: result.displayName,
      birthBird: bird,
    );
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
            birthDateEpoch: Value(
              state.birthDate?.millisecondsSinceEpoch,
            ),
            birthTime: Value(
              state.birthTimeOfDay != null
                  ? '${state.birthTimeOfDay!.hour.toString().padLeft(2, '0')}:'
                      '${state.birthTimeOfDay!.minute.toString().padLeft(2, '0')}'
                  : null,
            ),
            birthPlaceName: Value(state.birthPlaceName),
            birthPlaceLat: Value(state.birthPlaceLat),
            birthPlaceLng: Value(state.birthPlaceLng),
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
