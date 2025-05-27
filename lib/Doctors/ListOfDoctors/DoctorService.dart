// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../../APIs/BaseUrl.dart';
// import 'DoctorModel.dart';

// // class DoctorService {
// //   String url = "http://192.168.1.6:3000/doctors";

// class DoctorService {
//   String url =
//       "http://${wifiUrl}:3000/services"; // 👈 Use emulator/real device IP

//   Future<List<ServiceModel>> fetchServices() async {
//     print("Calling fetchServices...");

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         print("Retrieved successfully...");
//         List<dynamic> jsonData = jsonDecode(response.body);
//         return jsonData
//             .map((item) => ServiceModel.fromJson(item))
//             .toList();
//       } else {
//         return Future.error('Error: ${response.statusCode}');
//       }
//     } catch (e, s) {
//       print('Exception: $e');
//       print('StackTrace: $s');
//       return Future.error('Failed to fetch data: $e');
//     }
//   }

//   Future<ServiceModel?> getDoctorById(String doctorId) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = jsonDecode(response.body);

//         var doctorJson = jsonData.firstWhere(
//           (item) => item['id'] == doctorId,
//           orElse: () => null,
//         );

//         if (doctorJson != null) {
//           final doctor = ServiceModel.fromJson(doctorJson);

//           // ✅ Print doctor details
//           print("✅ Doctor Found:");
//           print("ID: ${doctor.id}");
//           print("Name: ${doctor.doctor.name}");
//           print("Specialization: ${doctor.doctor.specialization}");
//           print("Hospital: ${doctor.hospital.name}");
//           print("City: ${doctor.hospital.city}");

//           return doctor;
//         } else {
//           print("❌ Doctor with ID $doctorId not found.");
//           return null;
//         }
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("❌ Error in getDoctorById: $e");
//       return null;
//     }
//   }
// }

// // }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../APIs/BaseUrl.dart';
import 'DoctorController.dart';
import 'DoctorModel.dart';

class DoctorService {
  // final DoctorController doctorController = Get.put(DoctorController());
  String url = "http://${wifiUrl}:3000/services"; // New hierarchical endpoint

  /// Fetches all services → hospitals → doctors from API
  Future<List<ServiceModel>> fetchServices() async {
    print("📡 Calling fetchServices...");

    try {
      final response = await http.get(Uri.parse(url));
      print("🔁 Response status: ${response.statusCode}");
      print("📦 Raw body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final jsonData = jsonDecode(response.body);
          print("✅ Decoded JSON: $jsonData");

          if (jsonData is List) {
            final services =
                jsonData.map((e) => ServiceModel.fromJson(e)).toList();
            print("📊 Parsed ${services.length} services.");
            return services;
          } else {
            throw FormatException(
                "Expected a list but got: ${jsonData.runtimeType}");
          }
        } catch (e) {
          print("❌ JSON decoding error: $e");
          return Future.error("JSON decoding failed: $e");
        }
      } else {
        print("❌ Server returned status: ${response.statusCode}");
        return Future.error('Error: ${response.statusCode}');
      }
    } catch (e, s) {
      print('❌ Outer catch Exception: $e');
      print('🪵 StackTrace: $s');
      return Future.error('Fetch failed: $e');
    }
  }

  /// Flatten all doctors from all services for listing/search
  Future<List<HospitalDoctorModel>> fetchAllDoctors() async {
    final services = await fetchServices();
    List<HospitalDoctorModel> allDoctors = [];

    for (var service in services) {
      for (var hospital in service.hospitals) {
        for (var doctor in hospital.doctors) {
          allDoctors.add(doctor);
        }
      }
    }

    return allDoctors;
  }

  /// Get doctor by their ID (from any service or hospital)
  Future<HospitalDoctorModel?> getDoctorById(String doctorId) async {
    final services = await fetchServices();

    // doctorController.setDoctorId(services.length.toString());

    for (var service in services) {
      for (var hospital in service.hospitals) {
        for (var doctor in hospital.doctors) {
          if (doctor.doctor.doctorId == doctorId) {
            print("✅ Doctor Found:");
            print("ID: ${doctor.doctor.doctorId}");
            print("Name: ${doctor.doctor.name}");
            print("Specialization: ${doctor.doctor.specialization}");
            print("Hospital: ${doctor.hospital.name}");
            print("City: ${doctor.hospital.city}");
            return doctor;
          }
        }
      }
    }

    print("❌ Doctor with ID $doctorId not found.");
    return null;
  }
  // Future<HospitalDoctorModel?> getDoctorNotification(String doctorId) async {
  //   final services = await fetchServices();

  //   // doctorController.setDoctorId(services.length.toString());

  //   for (var service in services) {
  //     for (var hospital in service.hospitals) {
  //       for (var doctor in hospital.doctors) {
  //         if (doctor.doctor.doctorId == doctorId) {
  //           print("✅ Doctor Found:");
  //           print("ID: ${doctor.doctor.doctorId}");
  //           print("Name: ${doctor.doctor.name}");
  //           print("Specialization: ${doctor.doctor.specialization}");
  //           print("Hospital: ${doctor.hospital.name}");
  //           print("City: ${doctor.hospital.city}");
  //           return doctor;
  //         }
  //       }
  //     }
  //   }

  //   print("❌ Doctor with ID $doctorId not found.");
  //   return null;
  // }
}
