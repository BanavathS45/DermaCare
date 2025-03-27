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
}

// }
