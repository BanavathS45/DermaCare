import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../APIs/BaseUrl.dart';
import 'DoctorModel.dart';

// class DoctorService {
//   String url = "http://192.168.1.6:3000/doctors";

class DoctorService {
  String url =
      "http://${wifiUrl}:3000/doctors"; // 👈 Use emulator/real device IP

  Future<List<HospitalDoctorModel>> fetchDoctorAndHospital() async {
    print("Calling fetchDoctorAndHospital...");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("Retrieved successfully...");
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((item) => HospitalDoctorModel.fromJson(item))
            .toList();
      } else {
        return Future.error('Error: ${response.statusCode}');
      }
    } catch (e, s) {
      print('Exception: $e');
      print('StackTrace: $s');
      return Future.error('Failed to fetch data: $e');
    }
  }

  Future<HospitalDoctorModel?> getDoctorById(String doctorId) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        var doctorJson = jsonData.firstWhere(
          (item) => item['id'] == doctorId,
          orElse: () => null,
        );

        if (doctorJson != null) {
          final doctor = HospitalDoctorModel.fromJson(doctorJson);

          // ✅ Print doctor details
          print("✅ Doctor Found:");
          print("ID: ${doctor.id}");
          print("Name: ${doctor.doctor.name}");
          print("Specialization: ${doctor.doctor.specialization}");
          print("Hospital: ${doctor.hospital.name}");
          print("City: ${doctor.hospital.city}");

          return doctor;
        } else {
          print("❌ Doctor with ID $doctorId not found.");
          return null;
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error in getDoctorById: $e");
      return null;
    }
  }
}

// }
