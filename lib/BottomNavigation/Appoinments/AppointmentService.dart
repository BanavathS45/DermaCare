import 'dart:convert';

import '../../APIs/BaseUrl.dart';
import 'BookingModal.dart';
import 'package:http/http.dart' as http;

import 'GetAppointmentModel.dart';

class AppointmentService {
  Future<List<Getappointmentmodel>> fetchAppointments(
      String mobileNumber) async {
    final url = '$registerUrl/getBookedServices/$mobileNumber';
    print("🔍 Service – Response url: ${url}");

    try {
      final response = await http.get(Uri.parse(url));
      print("🔍 Service – Response code: ${response.statusCode}");
      print("🔍 Service – Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        print("📥 Service – Received ${data.length} booking items");

        return data.map((e) => Getappointmentmodel.fromJson(e)).toList();
      } else {
        print("⚠️ Service – HTTP error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Service – fetchAppointments Exception: $e");
      return [];
    }
  }

  Future<Getappointmentmodel?> fetchAppointmentById(String appID) async {
    final url = '$registerUrl/getBookedService/$appID';

    try {
      final response = await http.get(Uri.parse(url));
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final dynamic data = responseData['data'];
        print("Booking Data: $data");

        if (data != null) {
          // Assuming data is a JSON object for a single appointment
          return Getappointmentmodel.fromJson(data);
        } else {
          print("No data found in response");
          return null;
        }
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Failed to fetch appointment: $e");
      return null;
    }
  }
}
