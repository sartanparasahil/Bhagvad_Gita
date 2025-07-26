import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'api_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final ApiService _apiService = ApiService();

  // Initialize background service
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

    // Initialize background service
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
        notificationChannelId: 'daily_slok_background',
        initialNotificationTitle: 'Bhagavad Gita',
        initialNotificationContent: 'Daily notification service running',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  // Background service start callback
  static void onStart(ServiceInstance service) async {
    // Schedule daily notification
    await _scheduleDailyNotification();
    
    // Keep service alive
    service.on('setAsForeground').listen((event) {
      // Remove the non-existent method call
      print('Service set as foreground');
    });

    service.on('setAsBackground').listen((event) {
      // Remove the non-existent method call
      print('Service set as background');
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // iOS background callback
  static Future<bool> onIosBackground(ServiceInstance service) async {
    await _scheduleDailyNotification();
    return true;
  }

  // Schedule daily notification from background service
  static Future<void> _scheduleDailyNotification() async {
    try {
      final notifications = FlutterLocalNotificationsPlugin();
      
      // Set notification time to 9 AM
      final now = DateTime.now();
      final scheduledDate = DateTime(now.year, now.month, now.day, 9, 0, 0);
      
      // If it's already past 9 AM today, schedule for tomorrow
      final targetDate = scheduledDate.isBefore(now) 
          ? scheduledDate.add(const Duration(days: 1))
          : scheduledDate;

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
      await notifications.zonedSchedule(
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

      print('Background service: Daily notification scheduled for 9 AM');
    } catch (e) {
      print('Background service: Error scheduling notification: $e');
    }
  }

  // Start background service
  Future<void> startService() async {
    final service = FlutterBackgroundService();
    await service.startService();
  }

  // Stop background service
  Future<void> stopService() async {
    final service = FlutterBackgroundService();
    service.invoke('stopService');
  }
} 