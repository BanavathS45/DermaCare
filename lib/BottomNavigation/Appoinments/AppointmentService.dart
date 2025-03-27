import 'dart:convert';

import '../../APIs/BaseUrl.dart';
import 'BookingModal.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  Future<List<AppointmentData>> fetchAppointments(String mobileNumber) async {
    final url = '$baseUrl/getBookedServices/$mobileNumber';
    try {
      final response = await http.get(Uri.parse(url));
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        print("Booking Data: $data");

        return data.map((json) {
          return AppointmentData(
            appointmentId: json['appointmentId'],
            patientName: json['patientName'],
            relationShip: json['relationShip'],
            patientNumber: json['patientNumber'],
            gender: json['gender'],
            emailId: json['emailId'],
            age: json['age'],
            customerNumber: json['customerNumber'],
            addressDto: AddressDto.fromJson(json['addressDto']),
            categoryName: json['categoryName'],
            servicesAdded: (json['servicesAdded'] as List)
                .map((item) => ServiceAdded.fromJson(item))
                .toList(),
            totalPrice: (json['totalPrice'] as num).toDouble(),
            totalDiscountAmount:
                (json['totalDiscountAmount'] as num).toDouble(),
            totalTax: (json['totalTax'] as num).toDouble(),
            payAmount: (json['payAmount'] as num).toDouble(),
            bookedAt: json['bookedAt'], totalDiscountedAmount: (json['totalDiscountedAmount'] as num).toDouble(),
          );
        }).toList();
      } else {
        print("Error: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("Failed to fetch appointments: $e");
      return [];
    }
  }
}
