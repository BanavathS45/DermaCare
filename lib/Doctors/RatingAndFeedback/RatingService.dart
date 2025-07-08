import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'RatingModal.dart'; // Your model

Future<RatingSummary> fetchAndSetRatingSummary(
    String hospitalId, String doctorId) async {
  final url = Uri.parse('${clinicUrl}/averageRatings/$hospitalId/$doctorId');
  final doctorController = Get.find<DoctorController>();

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        final ratingSummary = RatingSummary.fromJson(jsonResponse['data']);

        // ✅ Update observables
        doctorController.doctorRatings[doctorId] =
            ratingSummary.overallDoctorRating ?? 0.0;
        doctorController.doctorCommentCounts[doctorId] =
            ratingSummary.comments?.length ?? 0;

        return ratingSummary; // ✅ Return actual data
      } else {
        throw Exception('API returned failure');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching ratings: $e');
    throw Exception('Failed to fetch ratings');
  }
}
