import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsService {
  // Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the push notification service
  Future<void> initialize() async {
    // Request permission for iOS devices
    await _requestPermission();

    // Initialize local notifications for foreground messages
    _initializeLocalNotifications();

    // Handle notification when the app is in the foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    // Handle notification when the app is opened via background notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    // Handle notification when the app is terminated and opened via push notification
    _handleTerminatedNotification();
  }

  // Request permission for push notifications (iOS specific)
  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("User granted permission");
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print("User denied permission");
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.notDetermined) {
        print("User has not yet granted permission");
      }
    }
  }

  // Initialize Flutter local notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Handle foreground notification
  void _handleForegroundNotification(RemoteMessage message) {
    print(
        "Received a notification in foreground: ${message.notification?.title}");

    // Show local notification
    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }

  // Show a local notification in foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel Name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  // Handle background/terminated notification
  void _handleNotificationOpen(RemoteMessage message) {
    print("User opened a notification: ${message.notification?.title}");

    // Handle redirection or data fetching based on the notification
    if (message.data.isNotEmpty) {
      print("Notification Data: ${message.data}");
      // Navigate to a specific page or perform any action here
    }
  }

  // Handle terminated state notifications
  Future<void> _handleTerminatedNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("App opened from terminated state due to notification");
      _handleNotificationOpen(initialMessage);
    }
  }

  // Get the device FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Set foreground message handling preferences for iOS
  void configureForegroundNotificationPresentationOptions() {
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
