import 'dart:convert';
import '../Modals/ServiceModal.dart';
import 'BaseUrl.dart';
import 'package:http/http.dart' as http;

class ServiceFetcher {
  Future<List<Service>> fetchServices(String categoryId) async {
    final url = '$getServiceByCategoriesID/$categoryId';

    try {
      print("🔄 Sending request to URL: $url");
      final response = await http.get(Uri.parse(url));
      print("📦 API response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 302) {
        final decodedResponse = json.decode(response.body);
        print("🧩 Decoded JSON: $decodedResponse");

        if (decodedResponse['data'] is List) {
          final List<dynamic> data = decodedResponse['data'];
          print("✅ Data length: ${data.length}");

          return data.expand<Service>((json) {
            try {
              return [Service.fromJson(json)];
            } catch (e) {
              print("❌ Error parsing service: $e");
              return [];
            }
          }).toList();
        } else {
          print('❗ Error: "data" is not a list');
          return [];
        }
      } else {
        print('❗ Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('❌ Exception fetching services: $e');
      return [];
    }
  }
}
