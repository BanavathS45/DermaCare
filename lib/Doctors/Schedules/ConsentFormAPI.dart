// import 'dart:convert';
// import 'package:cutomer_app/APIs/BaseUrl.dart';
// import 'package:http/http.dart' as http;

// class ConsentFormService {
//   Future<Map<String, dynamic>?> getConsentForm({
//     required String clinicId,
//     required String subServiceId,
//   }) async {
//     print("getConsentForm clinicId : $clinicId");
//     print("getConsentForm subServiceId : $subServiceId");
//     try {
//       final url = Uri.parse(
//         "$clinicUrl/consent-form/$clinicId/subservice/$subServiceId",
//       );
//       print("getConsentForm url : $url");

//       final response = await http.get(url, headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       });
//       print("getConsentForm url : ${response.toString()}");

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body) as Map<String, dynamic>;
//       } else {
//         print("Failed with status: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching consent form: $e");
//       return null;
//     }
//   }
// }
import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:http/http.dart' as http;

class ConsentFormService {
  Future<Map<String, dynamic>?> getConsentForm({
    required String clinicId,
    required String subServiceId,
    String? procedureId, // <-- fallback procedureId
  }) async {
    print("getConsentForm clinicId : $clinicId");
    print("getConsentForm subServiceId : $subServiceId");

    try {
      // 🔹 1. Try subService-specific consent form
      final subServiceUrl = Uri.parse(
        "$clinicUrl/consent-form/$clinicId/subservice/$subServiceId",
      );
      print("Trying SubService URL : $subServiceUrl");

      final subServiceResponse = await http.get(subServiceUrl, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (subServiceResponse.statusCode == 200) {
        final data = jsonDecode(subServiceResponse.body);
        if (data != null &&
            data is Map<String, dynamic> &&
            (data['data']?['consentFormQuestions']?.isNotEmpty ?? false)) {
          return data;
        }
      }

      // 🔹 2. If subService not found → fallback to procedure-level API
      if (procedureId != null) {
        final procedureUrl =
            Uri.parse("$clinicUrl/consent-form/$clinicId/$procedureId");
        print("Fallback Procedure URL : $procedureUrl");

        final procedureResponse = await http.get(procedureUrl, headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        });

        if (procedureResponse.statusCode == 200) {
          return jsonDecode(procedureResponse.body) as Map<String, dynamic>;
        } else {
          print("Procedure fallback failed: ${procedureResponse.statusCode}");
        }
      }

      return null;
    } catch (e) {
      print("Error fetching consent form: $e");
      return null;
    }
  }
}
