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

      if (response.statusCode == 200 && decoded['success'] == true) {
        final List<dynamic> data = decoded['data'];
        print('📦 Data list contains ${data.length} items');

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
            "hospitalLogo": base64Logo,
            "hospitalName": item['hospitalName'],
            "hospitalId": item['hospitalId'],
            "serviceName": item['serviceName'],
            "subServiceName": item['subServiceName'],
            "cost": "₹${item['subServicePrice']}",
            "recommended": item['recommandation'] ?? false,
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
