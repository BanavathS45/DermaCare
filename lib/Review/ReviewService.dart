import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Toasters/Toaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

Future<void> submitCustomerRating(
    {required double doctorRating,
    required double hospitalRating,
    required String feedback,
    required String doctorId,
    required String customerMobileNumber,
    required String appointmentId,
    required String hospitalId}) async {
  final url = Uri.parse('${registerUrl}/submitCustomerRating');

  final Map<String, dynamic> payload = {
    "doctorRating": doctorRating,
    "hospitalRating": hospitalRating,
    "feedback": feedback,
    "doctorId": doctorId,
    "customerMobileNumber": customerMobileNumber,
    "appointmentId": appointmentId,
    "hospitalId": hospitalId,
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      showSuccessToast(msg: "Rating submitted successfully ${doctorId}");
      print('✅ Rating submitted successfully: ${response.body}');

      // ✅ Close current screen (like .pop())
      Get.back();
    } else {
      print('❌ Failed to submit rating: ${response.statusCode}');
      print('🔍 Response: ${response.body}');
    }
  } catch (e) {
    print('🚨 Error submitting rating: $e');
  }
}
