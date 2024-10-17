import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) =>
            onSelectNotification(response));
  }

  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'org.emarketingo.weevo',
      'Weevo App',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    FlutterRingtonePlayer().play(
        android: AndroidSounds.notification, ios: IosSounds.receivedMessage);
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch, // Notification ID
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformChannelSpecifics,
    );
  }

  static void onSelectNotification(NotificationResponse onSelected) async {
    // Handle when a user taps on the notification.

    // if (onSelected.payload != null) {
    //   print('Notification payload: ${onSelected.payload}');
    // }

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.cancel(onSelected.id!);

    await _flutterLocalNotificationsPlugin.cancel(onSelected.id!);
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle local notification in iOS when the app is in the foreground.
    // Display a snackbar with the notification details.
    // if (payload != null) {
    //   print('Notification payload: $payload');
    // }

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'org.emarketingo.weevo',
          'Weevo App',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
