import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'RatingModal.dart'; // Your model

Future<RatingSummary> fetchRatingSummary(String hospitalId, String doctorId) async {
  final url = Uri.parse('${clinicUrl}/averageRatings/$hospitalId/$doctorId');
  print('Status Code: url ${url}');

  final response = await http.get(url);

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);

    if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
      try {
        return RatingSummary.fromJson(jsonResponse['data']);
      } catch (e) {
        throw Exception('Parsing error: $e');
      }
    } else {
      throw Exception(
          'API returned failure: ${jsonResponse['message'] ?? 'Unknown error'}');
    }
  } else {
    throw Exception('HTTP error: ${response.statusCode}');
  }
}
