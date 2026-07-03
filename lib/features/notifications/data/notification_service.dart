import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:saranidhi/features/notifications/domain/notification_scheduler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service wrapping `flutter_local_notifications` for real OS-level scheduling.
///
/// Handles:
/// - Plugin initialization with platform-specific settings
/// - Permission requests (iOS/macOS)
/// - Scheduling notifications at exact times (zonedSchedule)
/// - Cancelling all scheduled notifications
/// - Notification channel configuration (Android)
///
/// **Platform behavior:**
/// - iOS/macOS: Requests permission on first schedule attempt
/// - Android: Uses "saranidhi_yama" channel for yama alerts
/// - Web: All operations are no-ops (web has no local notifications)
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notification plugin with platform settings.
  ///
  /// Call once at app startup (e.g., in main.dart before runApp).
  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    // Initialize timezone database
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
    debugPrint('[Notifications] Initialized');
  }

  /// Request notification permission from the user.
  ///
  /// On iOS/macOS, shows the system permission dialog.
  /// On Android 13+, requests POST_NOTIFICATIONS permission.
  /// Returns true if permission granted.
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    if (Platform.isIOS || Platform.isMacOS) {
      final result = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final result = await android?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  /// Schedule a single notification at an exact time.
  Future<void> scheduleNotification(ScheduledNotification notification) async {
    if (kIsWeb || !_initialized) return;

    final scheduledDate = tz.TZDateTime.from(
      notification.scheduledTime,
      tz.local,
    );

    // Don't schedule if time has already passed
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedule a batch of notifications.
  Future<void> scheduleAll(List<ScheduledNotification> notifications) async {
    for (final notification in notifications) {
      await scheduleNotification(notification);
    }
    debugPrint(
      '[Notifications] Scheduled ${notifications.length} notifications',
    );
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    if (kIsWeb || !_initialized) return;
    await _plugin.cancelAll();
    debugPrint('[Notifications] Cancelled all');
  }

  /// Cancel a specific notification by ID.
  Future<void> cancel(int id) async {
    if (kIsWeb || !_initialized) return;
    await _plugin.cancel(id);
  }

  /// Get count of pending (scheduled) notifications.
  Future<int> pendingCount() async {
    if (kIsWeb || !_initialized) return 0;
    final pending = await _plugin.pendingNotificationRequests();
    return pending.length;
  }

  /// Platform-specific notification display details.
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'saranidhi_yama',
        'Yama Transitions',
        channelDescription:
            'Notifications for Panja Pakshi bird state transitions',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
      ),
    );
  }
}
