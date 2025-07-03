import 'package:cutomer_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Future<void> scheduleVideoCallNotification({
//   required String title,
//   required String body,
//   required DateTime videoCallTime,
// }) async {
//   final scheduledTime = videoCallTime.subtract(const Duration(minutes: 5));

//   var flutterLocalNotificationsPlugin;
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     title,
//     body,
//     tz.TZDateTime.from(scheduledTime, tz.local),
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'video_call_channel',
//         'Video Call Notifications',
//         channelDescription: 'Alert for video call before 5 min',
//         importance: Importance.max,
//         priority: Priority.high,
//         sound: RawResourceAndroidNotificationSound('video_alert'),
//         playSound: true,
//       ),
//     ),
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//   );
// }

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterTts flutterTts = FlutterTts();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleVideoCallNotification({
  required String title,
  required String body,
  required DateTime videoCallTime,
}) async {
  try {
    print('[🔔] scheduleVideoCallNotification called');
    print('[📅] Video call time: $videoCallTime');

    final alertTime = videoCallTime.subtract(const Duration(minutes: 5));
    final now = DateTime.now();
    final delay = alertTime.difference(now);

    print('[⏱️] Alert time: $alertTime');
    print('[⏳] Time remaining: ${delay.inSeconds} seconds');

    // If alertTime is in the past or within 1 min, trigger now
    if (delay.inSeconds <= 60) {
      print(
          '[⚠️] Alert time is in the past or too close. Triggering immediately.');

      // Show text notification now
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'video_call_voice',
            'Video Call Voice Alerts',
            channelDescription: 'Voice reminder',
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
          ),
        ),
      );

      // Speak immediately
      await flutterTts.speak(body);
    } else {
      // Schedule notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(alertTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'video_call_voice',
            'Video Call Voice Alerts',
            channelDescription: 'Voice reminder 5 min before call',
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('[✅] Text notification scheduled.');

      // Delay voice separately
      await Future.delayed(delay);
      print('[🔊] Speaking voice alert...');
      await flutterTts.speak(body);
    }
  } catch (e, stackTrace) {
    print('[❌] Error in scheduleVideoCallNotification: $e');
    print(stackTrace);
  }
}
