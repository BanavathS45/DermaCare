import 'dart:convert';

import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ConfirmBooking/Consultations.dart';
import '../OTP/OtpScreen.dart';
import '../Registration/RegisterScreen.dart';
import 'LoginService.dart';
import 'package:http/http.dart' as http;

class SiginSignUpController extends GetxController {
  var getOTPButton = "SIGN IN".obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final LoginApiService _loginapiService = LoginApiService();

  bool agreeToTerms = true; // Initialize to false to require agreement
  String? phoneNumber;

  String? validatedata(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter your $fieldName";
    }
    if (value.length < 3) {
      return "$fieldName must be at least 3 characters long";
    }
    if (value.length > 20) {
      return "$fieldName must not exceed 20 characters";
    }

    final alphabetRegex = RegExp(r"^[a-zA-Z\s]+$"); // Only letters & spaces
    if (!alphabetRegex.hasMatch(value)) {
      return "Only alphabets are allowed in $fieldName";
    }
    return null; // ✅ Valid input
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your age";
    }

    final numericRegex = RegExp(r'^\d+$'); // Only digits
    if (!numericRegex.hasMatch(value)) {
      return "Age must be a number";
    }

    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return "Enter a valid age";
    }
    if (age > 120) {
      return "Age must be less than or equal to 120";
    }

    return null; // ✅ Valid
  }

  String? validateMobileNumber(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return "Enter a valid mobile number";
    } else if (!GetUtils.isPhoneNumber(value)) {
      return "Enter a valid mobile number";
    } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return "Mobile number must start with 6-9";
    } else if (value.length != 10) {
      return "Mobile number must be exactly 10 digits long";
    }
    return null; // No error
  }

  void submitForm(BuildContext context) async {
    if (formKey.currentState!.validate() && agreeToTerms) {
      getOTPButton.value = "Signing in...";
      isLoading.value = true;

      final fullname = nameController.text.trim();
      final mobileNumber = mobileController.text.trim();

      try {
        // STEP 1: Check if user already exists
        final response = await http.get(
          Uri.parse('${registerUrl}/getBasicDetails/$mobileNumber'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // STEP 2: Navigate based on user data availability
          if (data != null && data['success'] == true && data['data'] != null) {
            // ✅ Existing user – go to ConsultationsType
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isAuthenticated', true);
            await prefs.setString('username', fullname);
            await prefs.setString('mobileNumber', mobileNumber);

            Get.offAll(() => ConsultationsType(
                  mobileNumber: mobileNumber,
                  username: fullname,
                ));
          } else {
            // 🆕 New user – go to registration
            Get.to(RegisterScreen(
              fullName: fullname,
              mobileNumber: mobileNumber,
            ));
          }
        } else {
          // Unexpected response
          Get.snackbar("Error", "Failed to verify user. Try again later.");
        }
      } catch (e) {
        Get.snackbar("Exception", e.toString());
      } finally {
        getOTPButton.value = "SIGN IN";
        isLoading.value = false;
      }
    }

    if (!agreeToTerms) {
      errorMessage.value = "Please agree to terms and conditions";
    }
  }
}
