// ServiceFetcher.dart

import 'dart:convert';
import 'dart:typed_data';
import '../Modals/ServiceModal.dart';
import 'BaseUrl.dart';
import 'package:http/http.dart' as http;

class ServiceFetcher {
  Future<List<Service>> fetchServices(String categoryId) async {
    final url = '$getAllServiceUrl/$categoryId';

    try {
      print("Sending request to URL: $url");
      final response = await http.get(Uri.parse(url));
      print("API response status code: ${response.statusCode}");
      print("API response body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['data'] is List) {
          final List<dynamic> data = decodedResponse['data'];
          print("Decoded data: $data");

          // Map the services to the Service model
          return data.map((serviceJson) {
            Uint8List decodedImage;
            try {
              decodedImage = base64Decode(serviceJson['serviceImage'] ?? "");
            } catch (e) {
              print("Error decoding image: $e");
              decodedImage = Uint8List(0);
            }

            return Service(
              serviceName: serviceJson['serviceName'] as String? ?? "",
              categoryName: serviceJson['categoryName'] as String? ?? "",
              description: serviceJson['description'] as String? ?? "",
              minTime: serviceJson['minTime'] as String? ?? "",
              pricing: double.tryParse(serviceJson['pricing'].toString()) ?? 0.0,
              discount:
                  double.tryParse(serviceJson['discount'].toString()) ?? 0.0,
              discountCost:
                  double.tryParse(serviceJson['discountCost'].toString()) ?? 0.0,
              discountedCost: double.tryParse(
                      serviceJson['discountedCost'].toString()) ??
                  0.0,
              taxAmount:
                  double.tryParse(serviceJson['taxAmount'].toString()) ?? 0.0,
              tax: double.tryParse(serviceJson['tax'].toString()) ?? 0.0,
              finalCost:
                  double.tryParse(serviceJson['finalCost'].toString()) ?? 0.0,
              status: serviceJson['status'] as String? ?? "",
              includes: serviceJson['includes'] as String? ?? "",
              readyPeriod: serviceJson['readyPeriod'] as String? ?? "",
              viewDescription: serviceJson['viewDescription'] as String? ?? "",
              preparation: serviceJson['preparation'] as String? ?? "",
              serviceImage: decodedImage,
              serviceId: serviceJson['serviceId'] as String? ?? "",
            );
          }).toList();
        } else {
          print('Error: "data" is not a list');
          return [];
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Failed to fetch services: $e');
      return [];
    }
  }
}
