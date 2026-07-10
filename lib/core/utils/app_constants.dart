/// Centralized global application constants.
///
/// Provides a single source of truth for app-wide metadata
/// (name, version, developer info, contact details).
abstract final class AppConstants {
  /// Application name.
  static const String appName = 'Saranidhi';

  /// Application tagline.
  static const String tagline = 'The Treasure House of Breath';

  /// Current app version (semantic versioning).
  static const String appVersion = '1.2.1';

  /// Database schema version (matches app_database.dart).
  static const int schemaVersion = 3;

  /// Export format version.
  static const int exportVersion = 1;

  /// Developer name.
  static const String developerName = 'Eialarasu';

  /// Developer email.
  static const String developerEmail = 'eialarasu@gmail.com';

  /// Developer website.
  static const String developerWebsite = 'https://vteial.github.io';

  /// Privacy policy URL.
  static const String privacyPolicyUrl =
      'https://vteial.github.io/saranidhi/privacy';

  /// Copyright text.
  static const String copyright = '\u00A9 2026 Eialarasu. All rights reserved.';

  /// Default location (Chennai, India).
  static const double defaultLatitude = 13.08;
  static const double defaultLongitude = 80.27;
  static const double defaultUtcOffset = 5.5;
}
