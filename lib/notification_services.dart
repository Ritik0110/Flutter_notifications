import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging message = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin local =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await message.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission Granetd");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional Permission");
    } else {
      AppSettings.openNotificationSettings();
      print("permission Denied");
    }
  }

  void initLocalNotification(RemoteMessage message) async {
    var androidSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings = const DarwinInitializationSettings();
    var settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await local.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {});
  }

  Future notifyMessage(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        "High importance notifications",
        importance: Importance.max);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      channelDescription: 'Default notification channel',
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true);

    NotificationDetails details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    Future.delayed(Duration.zero, () {
      local.show(
          0, message.notification!.title, message.notification!.body, details);
    });
  }

  void firebaseInit() async {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      initLocalNotification(message);
      notifyMessage(message);
    });
  }

  Future<String> getToken() async {
    String? token1 = await message.getToken();
    return token1!;
  }

  void isTokenRefresh() {
    message.onTokenRefresh.listen((event) {
      print(event);
    });
  }
}
