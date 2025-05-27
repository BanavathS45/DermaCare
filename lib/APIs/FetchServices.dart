import 'dart:convert';
import 'dart:typed_data';
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

          return data.map<Service>((json) {
            try {
              return Service.fromJson(json);
            } catch (e) {
              print("❌ Error parsing service: $e");
              return Service(
                serviceId: '',
                serviceName: '',
                categoryName: '',
                categoryId: '',
                description: '',
                serviceImage: Uint8List(0),
              );
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

  Future<List<SubService>> fetchsubServices(String serviceId) async {
    final url = '$getSubServiceByServiceID/$serviceId';
    print("🔄 Sending request to URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("📦 Response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 302) {
        final decodedResponse = json.decode(response.body);
        final data = decodedResponse['data'];
        print("📦 Response status: ${data}");

        if (data != null && data['subServices'] is List) {
          final List<dynamic> subServices = data['subServices'];

          return subServices
              .map((json) {
                try {
                  return SubService.fromJson(json);
                } catch (e) {
                  print("❌ Parse error: $e");
                  return null; // ✔ allowed because of whereType below
                }
              })
              .whereType<SubService>() // ✅ filters out nulls
              .toList();
        } else {
          print("❗ 'subServices' not found or is not a list");
          return [];
        }
      } else {
        print("❗ HTTP error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Exception during fetch: $e");
      return [];
    }
  }
}
