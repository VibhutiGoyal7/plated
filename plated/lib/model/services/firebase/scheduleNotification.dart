import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotification() async {
  final now = tz.TZDateTime.now(tz.local);
  final scheduledTime = now.add(Duration(seconds: 10)); // 10s delay for quick testing

  print("📆 Current time: $now");
  print("✅ Scheduling notification at: $scheduledTime");

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This should trigger in 10 seconds',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("🚀 Notification scheduled successfully!");
  } catch (e) {
    print("❌ Error scheduling notification: $e");
  }
}


Future<void> testInstantNotification() async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'Test Notification',
    'If you see this, local notifications are working!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'Test Channel',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}


