import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gradclock/screens/message_screen.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // FIX: use named parameter 'settings:'
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  if (notificationResponse.payload != null) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            MessageScreen(payload: notificationResponse.payload!),
      ),
    );
  }
}

Future<void> requestPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required tz.TZDateTime scheduledDate,
  String? payload,
}) async {
  // FIX: use named parameters, remove deprecated uiLocalNotificationDateInterpretation
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id: id,
    title: title,
    body: body,
    scheduledDate: scheduledDate,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'gradclock_channel',
        'Gradclock Notifications',
        channelDescription: 'Notifications for Gradclock app',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: payload,
  );
}