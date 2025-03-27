import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding

class AddressAPI {
  Future<http.Response> onConfirmAddress(
      AddressModel address, String mobileNumber) async {
    // URL of your API
    String url = '$baseUrl/save-address?mobileNumber=$mobileNumber';

    print("[LOG - ${DateTime.now()}] Preparing request for URL: $url");

    try {
      // Convert AddressModel to JSON
      Map<String, dynamic> addressData = address.toJson();
      String addressJson = jsonEncode(addressData);

      // Send a POST request
      print(
          "[LOG - ${DateTime.now()}] Sending POST request with data: $addressJson");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: addressJson, // Encode the data as JSON
      );

      // Log the response
      print(
          "[LOG - ${DateTime.now()}] Received response with status code: ${response.statusCode}");
      print("[LOG - ${DateTime.now()}] Response body: ${response.body}");

      return response;
    } catch (error) {
      print("[LOG - ${DateTime.now()}] Error sending address: $error");
      rethrow; // Re-throw the error to be handled by the caller
    }
  }
}
