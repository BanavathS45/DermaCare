import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchService {
  final String apiKey = "YOUR_GOOGLE_PLACES_API_KEY"; // Replace with your API key
  String sessionToken = '1234567890';
  final uuid = Uuid();

  // Method to fetch suggestions based on input text
  Future<List<dynamic>> fetchSuggestions(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        return json.decode(response.body)['predictions'];
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return [];
    }
  }
}
