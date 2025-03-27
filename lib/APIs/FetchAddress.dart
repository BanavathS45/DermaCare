import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Modals/AddressModal.dart';
import 'BaseUrl.dart';

class Fetchaddress {
    Future<AddressModel?> fetchFirstAddress(String mobileNumber) async {
    String apiUrl = '$getCustomer/$mobileNumber';

    print("getCustomerUrl: $apiUrl");

    try {
      final response = await http.get(Uri.parse(apiUrl));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if data contains a list of addresses
        if (data['addresses'] != null && data['addresses'] is List) {
          List<dynamic> addressList = data['addresses'];

          print("addressList: ${addressList}");

          // Return the first address as AddressModel
          if (addressList.isNotEmpty) {
            return AddressModel.fromJson(addressList.first);
          }
        }
      } else {
        print('Failed to fetch addresses. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching addresses: $e');
    }
    return null; // Return null if no address is found
  }
}