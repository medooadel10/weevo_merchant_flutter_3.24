import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  static Future<void> iOSPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
