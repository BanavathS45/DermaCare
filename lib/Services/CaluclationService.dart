import 'dart:convert';
import 'package:http/http.dart' as http;
import '../APIs/BaseUrl.dart';
import '../Modals/CaluclationModel.dart';

class Caluclationservice {
  Future<Map<String, dynamic>?> calculateAppointmentCost(
      List<CaluclationModel> models) async {
    print("🛠 Calling calculateAppointmentCost API with Multiple Services...");

    List<Map<String, dynamic>> serviceListJson =
        models.map((model) => model.toJson()).toList();

    Map<String, dynamic> requestBody = {"servicesAdded": serviceListJson};

    print("📤 Sending Request JSON: ${jsonEncode(requestBody)}");

    final String apiUrl = "$baseUrl/calculateAppointmentCost";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print("✅ Full API Response: ${jsonEncode(responseData)}");
        return responseData;
      } else {
        print("❌ Failed to fetch data. Status Code: ${response.statusCode}");
        print("❌ Response Body: ${response.body}");
      }
    } catch (e) {
      print("❌ Error in API call: $e");
    }

    return null;
  }
}
