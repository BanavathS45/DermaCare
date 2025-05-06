import 'package:cutomer_app/Notification/Notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Notification/NotificationModel.dart'; // Adjust your import

class NotificationController extends GetxController {
  var title = ''.obs;
  var body = ''.obs;
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    // _initializeLocalNotifications();
  }

  // void _initializeLocalNotifications() {
  //   const AndroidInitializationSettings androidSettings =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   const InitializationSettings settings =
  //       InitializationSettings(android: androidSettings);

  //   flutterLocalNotificationsPlugin.initialize(settings);
  // }

  void handleNotification(RemoteMessage message) {
    final newNotification = NotificationModel(
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      type: message.data['type'] ?? 'general',
      timestamp: DateTime.now(),
    );

    title.value = newNotification.title;
    body.value = newNotification.body;
    notifications.insert(0, newNotification);
    unreadCount.value++;

    // showLocalNotification(newNotification.title, newNotification.body);
    Get.to(() => NotificationScreen());
  }

  // void showLocalNotification(String title, String body) {
  //   flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'channel_id',
  //         'channel_name',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       ),
  //     ),
  //   );
  }

  // void markAllAsRead() {
  //   unreadCount.value = 0;
  // }

