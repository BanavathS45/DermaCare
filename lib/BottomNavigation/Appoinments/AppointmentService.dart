import 'dart:convert';

import '../../APIs/BaseUrl.dart';
import 'BookingModal.dart';
import 'package:http/http.dart' as http;

import 'GetAppointmentModel.dart';

class AppointmentService {
  Future<List<Getappointmentmodel>> fetchAppointments(
      String mobileNumber) async {
    final url = '$registerUrl/getBookedServices/$mobileNumber';
    try {
      final response = await http.get(Uri.parse(url));
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        print("Booking Data: $data");

        return data.map((json) => Getappointmentmodel.fromJson(json)).toList();
      } else {
        print("Error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("Failed to fetch appointments: $e");
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
