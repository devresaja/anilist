import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<NotificationSettings> requestNotification() async {
    return await FirebaseMessaging.instance
        .requestPermission(provisional: false, alert: true);
  }

  static Future<void> initNotification() async {
    await requestNotification();

    // FROM TERMINATED
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // FROM BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // FROM FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}
    });
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == '') {}
  }
}
