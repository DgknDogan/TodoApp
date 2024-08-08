import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifiacitons() async {
    AndroidInitializationSettings initSettingsAndroid =
        const AndroidInitializationSettings("ic_stat_done");

    var initSettings = InitializationSettings(android: initSettingsAndroid);

    await notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {},
    );
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notifications.show(
      id,
      title,
      body,
      notifiactionDetails(),
      payload: "asdasd",
    );
  }

  notifiactionDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.max,
        priority: Priority.max,
        color: Colors.black,
        icon: "ic_stat_done",
      ),
    );
  }
}
