import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'api_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final ApiService _apiService = ApiService();

  // Initialize notification service
  Future<void> initialize() async {
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  // Schedule daily notification at 9 AM
  Future<void> scheduleDailyNotification() async {
    // Cancel any existing notifications
    await _notifications.cancelAll();

    // Set notification time to 9 AM
    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, 9, 0, 0);
    
    // If it's already past 9 AM today, schedule for tomorrow
    final targetDate = scheduledDate.isBefore(now) 
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;

    print('Scheduling daily notification for: ${targetDate.toString()}');
    print('Current time: ${now.toString()}');

    // Android notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_slok_channel',
      'Daily Slok',
      channelDescription: 'Daily random slok from Bhagavad Gita',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      ongoing: false,
      autoCancel: true,
      channelShowBadge: true,
      enableLights: true,
      ledColor: Color(0xFFFF9933),
    );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification with daily repeat
    await _notifications.zonedSchedule(
      0, // Unique ID
      'Bhagavad Gita - Daily Wisdom',
      'Tap to read today\'s random slok',
      tz.TZDateTime.from(targetDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // This makes it repeat daily
    );

    print('Daily notification scheduled for 9 AM');
    print('Notification ID: 0, Target Date: ${targetDate.toString()}');
    print('Notification will repeat daily at 9 AM');
  }

  // Show notification immediately (for testing)
  Future<void> showTestNotification() async {
    try {
      // Get random slok
      final randomSlok = await _apiService.getRandomSlok();
      
      final chapterNumber = randomSlok['chapter_number'] ?? 1;
      final verseNumber = randomSlok['verse_number'] ?? 1;
      final slokText = randomSlok['slok'] ?? 'श्रीमद्भगवद्गीता';
      
      // Truncate slok text for notification
      final displayText = slokText.length > 100 
          ? '${slokText.substring(0, 100)}...' 
          : slokText;

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'daily_slok_channel',
        'Daily Slok',
        channelDescription: 'Daily random slok from Bhagavad Gita',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        1, // Different ID for test notification
        'Bhagavad Gita - Chapter $chapterNumber, Verse $verseNumber',
        displayText,
        details,
        payload: 'chapter:$chapterNumber:verse:$verseNumber',
      );

      print('Test notification sent: Chapter $chapterNumber, Verse $verseNumber');
    } catch (e) {
      print('Error showing test notification: $e');
      // Show fallback notification
      await _notifications.show(
        1,
        'Bhagavad Gita - Daily Wisdom',
        'Tap to read today\'s random slok',
        const NotificationDetails(),
      );
    }
  }

  // Schedule test notification for 1 minute from now (for testing)
  Future<void> scheduleTestNotification() async {
    // Cancel any existing notifications
    await _notifications.cancelAll();

    // Schedule notification for 1 minute from now
    final now = DateTime.now();
    final targetDate = now.add(const Duration(seconds: 1));

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_slok_channel',
      'Daily Slok',
      channelDescription: 'Daily random slok from Bhagavad Gita',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification
    await _notifications.zonedSchedule(
      2, // Different ID for test scheduled notification
      'Bhagavad Gita - Test Notification',
      'This is a test notification scheduled for 1 minute from now',
      tz.TZDateTime.from(targetDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('Test notification scheduled for ${targetDate.toString()}');
  }

  // Schedule notification for custom time (for testing)
  Future<void> scheduleNotificationForTime(DateTime targetTime) async {
    // Cancel any existing notifications
    await _notifications.cancelAll();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_slok_channel',
      'Daily Slok',
      channelDescription: 'Daily random slok from Bhagavad Gita',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification
    await _notifications.zonedSchedule(
      3, // Different ID for custom time notification
      'Bhagavad Gita - Custom Time Test',
      'Test notification at custom time',
      tz.TZDateTime.from(targetTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('Custom time notification scheduled for ${targetTime.toString()}');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('All notifications cancelled');
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final bool? result = await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();
    return result ?? false;
  }

  // Request notification permissions
  Future<void> requestPermissions() async {
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  // Manually trigger daily notification (for testing)
  Future<void> triggerDailyNotification() async {
    try {
      // Get random slok
      final randomSlok = await _apiService.getRandomSlok();
      
      final chapterNumber = randomSlok['chapter_number'] ?? 1;
      final verseNumber = randomSlok['verse_number'] ?? 1;
      final slokText = randomSlok['slok'] ?? 'श्रीमद्भगवद्गीता';
      
      // Truncate slok text for notification
      final displayText = slokText.length > 100 
          ? '${slokText.substring(0, 100)}...' 
          : slokText;

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'daily_slok_channel',
        'Daily Slok',
        channelDescription: 'Daily random slok from Bhagavad Gita',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        0, // Same ID as daily notification
        'Bhagavad Gita - Daily Wisdom (Chapter $chapterNumber, Verse $verseNumber)',
        displayText,
        details,
        payload: 'chapter:$chapterNumber:verse:$verseNumber',
      );

      print('Daily notification triggered manually: Chapter $chapterNumber, Verse $verseNumber');
    } catch (e) {
      print('Error triggering daily notification: $e');
      // Show fallback notification
      await _notifications.show(
        0,
        'Bhagavad Gita - Daily Wisdom',
        'Tap to read today\'s random slok',
        const NotificationDetails(),
      );
    }
  }
} 