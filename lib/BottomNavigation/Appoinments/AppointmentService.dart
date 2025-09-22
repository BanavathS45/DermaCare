import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'GetAppointmentModel.dart';

class AppointmentService {
  /// Fetch all bookings for a mobile number
  Future<List<Getappointmentmodel>> fetchAppointments(
      String mobileNumber) async {
    final url = '$registerUrl/getBookedServices/$mobileNumber';
    print("🔍 URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("🔍 Status code: ${response.statusCode}");
      print("🔍 Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        print("📥 Data array length: ${data.length}");

        // Safely parse each item
        return data
            .map((item) {
              try {
                return Getappointmentmodel.fromJson(item);
              } catch (e) {
                print("❌ Error parsing appointment: $e\nData: $item");
                return null;
              }
            })
            .whereType<Getappointmentmodel>()
            .toList();
      } else {
        print("⚠️ HTTP error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Exception in fetchAppointments: $e");
      return [];
    }
  }

  /// Fetch in-progress appointments
  Future<List<Getappointmentmodel>> fetchInprogressAppointments(
      String mobileNumber) async {
    final url = '$registerUrl/inprogressAppointments/$mobileNumber';
    print("🔍 URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("🔍 Status code: ${response.statusCode}");
      print("🔍 Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        print("📥 Data array length: ${data.length}");

        return data
            .map((item) {
              try {
                return Getappointmentmodel.fromJson(item);
              } catch (e) {
                print(
                    "❌ Error parsing in-progress appointment: $e\nData: $item");
                return null;
              }
            })
            .whereType<Getappointmentmodel>()
            .toList();
      } else {
        print("⚠️ HTTP error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Exception in fetchInprogressAppointments: $e");
      return [];
    }
  }

  /// Fetch a single appointment by ID
  Future<Getappointmentmodel?> fetchAppointmentById(String appID) async {
    final url = '$registerUrl/getBookedService/$appID';
    print("🔍 URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("🔍 Status code: ${response.statusCode}");
      print("🔍 Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final dynamic data = jsonData['data'];
        if (data != null) {
          return Getappointmentmodel.fromJson(data);
        } else {
          print("⚠️ No appointment data found");
          return null;
        }
      } else {
        print("⚠️ HTTP error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("❌ Exception in fetchAppointmentById: $e");
      return null;
    }
  }
}
