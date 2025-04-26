import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:http/http.dart' as http;
import '../Utils/ShowSnackBar.dart';

// import 'BaseUrl.dart';

class LoginApiService {
  final String endpoint = 'sign-in-or-sign-up';

  Future<Map<String, dynamic>> signInOrSignUp(
      String fullname, String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullname,
          'mobileNumber': mobileNumber,
        }),
      );

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
