import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:cutomer_app/ServiceSumarry/ServiceIDModal.dart';

class ServiceSummaryApi {
  ServiceSummaryApi();

  Future<http.Response> fetchServiceDetailsSummary(
      String serviceDetails, String mobilenumber) async {
    final url =
        Uri.parse('${serverUrl}/customers/bookServices');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: serviceDetails,
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching service details: $e');
    }
  }

  BookingDetails parseServiceDetailsSummary(String responseBody) {
    final data = jsonDecode(responseBody);
    return BookingDetails.fromJson(data);
  }
}
