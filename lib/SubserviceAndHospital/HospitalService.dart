import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cutomer_app/APIs/BaseUrl.dart';

class HospitalService {
  Future<List<Map<String, dynamic>>> fetchHospitalCards(subServiceId) async {
    final url = Uri.parse('$registerUrl/getSubServiceInfo/$subServiceId');
    print('📤 Sending GET request to: $url');

    try {
      final response = await http.get(url);
      print('📥 Response status: ${response.statusCode}');

      final decoded = json.decode(response.body);
      print('🔓 Decoded response: $decoded');

      if (response.statusCode == 200) {
        final List<dynamic> data = decoded['data'];
        print('📦 Data list contains ${decoded.length} items');

        List<Map<String, dynamic>> result = [];

        for (var item in data) {
          String base64Logo = '';
          try {
            final logo = item['hospitalLogo'] ?? '';
            if (logo.startsWith('http')) {
              final imageResponse = await http.get(Uri.parse(logo));
              final contentType = imageResponse.headers['content-type'] ?? '';
              if (imageResponse.statusCode == 200 &&
                  contentType.startsWith('image/')) {
                base64Logo = base64Encode(imageResponse.bodyBytes);
              } else {
                print('⚠️ Invalid image content from URL: $logo');
              }
            } else if (logo.length > 100) {
              base64Logo = logo;
            } else {
              print('⚠️ Invalid logo format or too short: $logo');
            }
          } catch (imgErr) {
            print('❌ Error handling logo: $imgErr');
          }

          result.add({
            "hospitalId": item['hospitalId'] ?? "",
            "hospitalName": item['hospitalName'] ?? "",
            "hospitalLogo": base64Logo,
            "recommanded":
                item['recommanded'] ?? false, // match backend spelling

            "serviceName": item['serviceName'] ?? "",
            "subServiceName": item['subServiceName'] ?? "",
            "subServicePrice": (item['subServicePrice'] ?? 0).toDouble(),

            "price": (item['price'] ?? 0).toDouble(),
            "discountedCost": (item['discountedCost'] ?? 0).toDouble(),
            "taxAmount": (item['taxAmount'] ?? 0).toDouble(),
            "discountPercentage": (item['discountPercentage'] ?? 0).toInt(),
            "hospitalOverallRating":
                (item['hospitalOverallRating'] ?? 0).toDouble(),

            "website": item['website'] ?? "",
            "consultationFee": (item['consultationFee'] ?? 0).toDouble(),
            "walkthrough": item['walkthrough'] ?? "",
          });
        }

        // ✅ Fix: Return result here
        return result;
      } else {
        final errorMsg = decoded['message'] ?? 'Failed to load hospital data.';
        print('❌ Backend message: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('🔥 Exception caught: $e');
      throw Exception('Error fetching hospital data: ${e.toString()}');
    }
  }
}
