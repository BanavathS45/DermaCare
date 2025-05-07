import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../Utils/ShowSnackBar.dart';

// import 'BaseUrl.dart';

class LoginApiService {
  final String endpoint = 'sign-in-or-sign-up';

  Future<Map<String, dynamic>> sendUserDataWithFCMToken(
      String fullname, String mobileNumber) async {
    print("response for fullname ${fullname}");
    print("response for mobileNumber ${mobileNumber}");

    try {
      // Get the FCM token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token == null) {
        print("FCM Token is null. Cannot send data.");
        return {'error': 'FCM Token is null. Cannot send data.'};
      }

      print("FCM Token: $token");

      // Optional: Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print("Token refreshed: $newToken");
        // You could resend the token here if needed
      });

      // Send user data and FCM token to backend
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullname,
          'mobileNumber': mobileNumber,
          // 'fcmToken': token,
        }),
      );
      print("response for statusCode ${response.statusCode}");

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("response for login $decoded");

        // showSnackbar("Success", "${decoded['message']}", "success");
        showSnackbar("Success", "Login Successfully...!", "success");

        return decoded;
      } else {
        showSnackbar("Error", "${decoded['message']}", "error");
        return {'error': '${decoded['message']}'};
      }
    } catch (e) {
      showSnackbar("Error", "server not respond", "error");
      return {'error': 'An error occurred: $e'};
    }
  }
}
