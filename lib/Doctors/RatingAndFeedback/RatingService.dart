import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'RatingModal.dart'; // Your model

Future<RatingSummary> fetchAndSetRatingSummary(
    String hospitalId, String doctorId) async {
  final url = Uri.parse('${clinicUrl}/averageRatings/$hospitalId/$doctorId');

  print("urlurl ${url}");
  final doctorController = Get.find<DoctorController>();

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // ✅ Ensure correct type mapping
      final success = jsonResponse['success'] == true;
      final data = jsonResponse['data'];

      if (success && data != null) {
        // Convert Map<dynamic, dynamic> -> Map<String, dynamic>
        final dataMap = Map<String, dynamic>.from(data);

        // Also ensure comments are correctly typed
        if (dataMap['comments'] != null && dataMap['comments'] is List) {
          dataMap['comments'] = (dataMap['comments'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }

        final ratingSummary = RatingSummary.fromJson(dataMap);

        print(
            '✅ Fetched ratings: ${ratingSummary.comments.map((e) => e.customerMobileNumber)}');

        // Update observables in controller
        doctorController.doctorRatings[doctorId] =
            ratingSummary.overallDoctorRating;
        doctorController.doctorCommentCounts[doctorId] =
            ratingSummary.comments.length;

        return ratingSummary;
      } else {
        throw Exception('API returned failure: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching ratings: $e');
    throw Exception('Failed to fetch ratings: $e');
  }
}
