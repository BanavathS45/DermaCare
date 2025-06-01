import 'dart:convert';
import 'package:http/http.dart' as http;

import '../APIs/BaseUrl.dart';
import '../BottomNavigation/Appoinments/AppointmentController.dart';
import '../BottomNavigation/Appoinments/PostBooingModel.dart';

Future<Map<String, dynamic>?> postBookings(
    PostBookingModel bookingDetails) async {
  final Url = Uri.parse(BookingUrl); // Replace with your endpoint
  print("response.body Url: ${Url}");

  try {
    final response = await http.post(
      Url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bookingDetails.toJson()),
    );
    print("response.body....: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Booking posted successfully!');
      print("response.body....: ${response.body}");
      print("response.body....: ${response}");
      return jsonDecode(response.body); // Return response data
    } else {
      print('Failed to post booking. Status code: ${response.statusCode}');
      return null; // Return null in case of failure
    }
  } catch (e) {
    print("Error posting booking: $e");
    return null; // Return null in case of error
  }
}

Future<List<Map<String, dynamic>>> getBookingsByMobileNumber(
    String mobileNumber) async {
  print("dshffdfjsd ${mobileNumber}");
  // final String mobileNumber = "7842259802";
  final url = Uri.parse(
      '$GetBookings=$mobileNumber'); // Adjust param name as per your API

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("expected response format: $data");

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        print("Unexpected response format: $data");
        return [];
      }
    } else {
      print("Failed to fetch bookings. Status code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("❌ Error fetching bookings: $e");
    return [];
  }
}

// Future<List<BookingDetailsModel>> getDetailByDoctorId(String doctorId) async {
//   final url = Uri.parse('http://$wifiUrl:3000/bookings?doctorId=$doctorId');

//   try {
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => BookingDetailsModel.fromJson(json)).toList();
//     } else {
//       print("❌ Error: ${response.statusCode}");
//       return [];
//     }
//   } catch (e) {
//     print("❌ Exception: $e");
//     return [];
//   }
// }
