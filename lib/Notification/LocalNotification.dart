import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

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

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'video_call_voice_2', // give a new ID to force sound channel update
      'Video Call Voice Alerts',
      channelDescription: 'Reminder with custom sound',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('tone1'), // no .mp3
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    if (delay.inSeconds <= 60) {
      print(
          '[⚠️] Alert time is in the past or too close. Triggering immediately.');

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(android: androidDetails),
      );
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(alertTime, tz.local),
        const NotificationDetails(android: androidDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print('[✅] Notification scheduled at: $alertTime');
    }
  } catch (e, stackTrace) {
    print('[❌] Error in scheduleVideoCallNotification: $e');
    print(stackTrace);
  }
}

// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// final FlutterTts flutterTts = FlutterTts();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> scheduleVideoCallNotification({
//   required String title,
//   required String body,
//   required DateTime videoCallTime,
// }) async {
//   try {
//     print('[🔔] scheduleVideoCallNotification called');
//     print('[📅] Video call time: $videoCallTime');

//     final alertTime = videoCallTime.subtract(const Duration(minutes: 5));
//     final now = DateTime.now();
//     final delay = alertTime.difference(now);

//     print('[⏱️] Alert time: $alertTime');
//     print('[⏳] Time remaining: ${delay.inSeconds} seconds');

//     // If alertTime is in the past or within 1 min, trigger now
//     if (delay.inSeconds <= 60) {
//       print(
//           '[⚠️] Alert time is in the past or too close. Triggering immediately.');

//       // Show text notification now
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         title,
//         body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'video_call_voice',
//             'Video Call Voice Alerts',
//             channelDescription: 'Voice reminder',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//           ),
//         ),
//       );

//       // Speak immediately
//       await flutterTts.speak(body);
//     } else {
//       // Schedule notification
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         title,
//         body,
//         tz.TZDateTime.from(alertTime, tz.local),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'video_call_voice',
//             'Video Call Voice Alerts',
//             channelDescription: 'Voice reminder 5 min before call',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//           ),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//       print('[✅] Text notification scheduled.');

//       // Delay voice separately
//       await Future.delayed(delay);
//       print('[🔊] Speaking voice alert...');
//       await flutterTts.speak(body);
//     }
//   } catch (e, stackTrace) {
//     print('[❌] Error in scheduleVideoCallNotification: $e');
//     print(stackTrace);
//   }
// }
