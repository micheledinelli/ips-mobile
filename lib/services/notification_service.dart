import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationType { sound, vibration, cow }

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails({NotificationType type = NotificationType.sound}) {
    switch (type) {
      case NotificationType.sound:
        return const NotificationDetails(
            android: AndroidNotificationDetails('channelId', 'channelName',
                importance: Importance.max,
                icon: "flutter_logo",
                playSound: true),
            iOS: DarwinNotificationDetails());

      case NotificationType.cow:
        return const NotificationDetails(
            android: AndroidNotificationDetails(
                'cowChannelId', 'cowChannelName',
                importance: Importance.max,
                icon: "flutter_logo",
                playSound: true,
                sound: RawResourceAndroidNotificationSound('cow'),
                enableVibration: true),
            iOS: DarwinNotificationDetails());

      case NotificationType.vibration:
        return const NotificationDetails(
            android: AndroidNotificationDetails(
                'vibChannelId', 'vibChannelName',
                importance: Importance.max,
                icon: "flutter_logo",
                playSound: true,
                sound: RawResourceAndroidNotificationSound('vibration'),
                enableVibration: true),
            iOS: DarwinNotificationDetails());
    }
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      NotificationType type = NotificationType.sound}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails(type: type));
  }
}
