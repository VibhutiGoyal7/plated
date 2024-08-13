import 'package:Payrio/utils/Helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../view/screens/profileSection/profile_screen.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PushNotificationService {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {

        print("PushNotificationService:: ${message.toString()}");
        sendBroadcast(
          BroadcastMessage(
            name: "de.kevlatus.flutter_broadcasts_example.demo_action",
          ),
        );
        _handleMessage(message.data);
      },
    );

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print("PushNotificationServiceOnMessage:: ${message.data['status']}");
        sendBroadcast(
          BroadcastMessage(
            name: "de.kevlatus.flutter_broadcasts_example.demo_action",
          ),
        );
        _showNotification(message);
      },
    );

    enableIOSNotifications();
    await getToken();
    await registerNotificationListeners();
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    bool isSaved = await Helper.saveDeviceToken(token);

    if (isSaved) {
      print('Token saved successfully.');
    } else {
      print('Failed to save token.');
    }
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@drawable/launch_background');
    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationClick(details.payload);
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print("message?.data :: ${message?.data}");
      _showNotification(message);
    });
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

  void _showNotification(RemoteMessage? message) {
    final notification = message?.notification;
    final android = message?.notification?.android;

    if (notification != null && android != null) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidNotificationChannel().id,
            androidNotificationChannel().name,
            channelDescription: androidNotificationChannel().description,
            icon: "notification",
          ),
        ),
        payload: message?.data.toString(),
      );
    }
  }

  void _handleMessage(Map<String, dynamic> data) {
    Navigator.push(
      navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  void _handleNotificationClick(String? payload) {
    if (payload != null) {
      final data = _parsePayload(payload);
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  Map<String, dynamic> _parsePayload(String payload) {
    final List<String> str = payload.replaceAll('{', '').replaceAll('}', '').split(',');
    final Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      final List<String> s = str[i].split(':');
      result[s[0].trim()] = s[1].trim();
    }
    return result;
  }
}