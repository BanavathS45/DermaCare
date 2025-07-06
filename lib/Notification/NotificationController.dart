import 'package:cutomer_app/Notification/Notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'NotificationModel.dart';

class NotificationController extends GetxController {
  var title = ''.obs;
  var body = ''.obs;
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // Simulated load
  }

  void fetchNotifications() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));

    // If no data from server, simulate or leave empty
    // Remove this if using real data
    notifications.clear(); // Comment this line if testing dummy
    // notifications.add(NotificationModel(
    //   title: 'Welcome!',
    //   body: 'You have no new notifications.',
    //   type: 'info',
    //   timestamp: DateTime.now(),
    // ));

    isLoading.value = false;
  }

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

    Get.to(() => NotificationScreen());
  }
}
