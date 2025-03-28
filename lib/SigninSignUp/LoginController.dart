import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../OTP/OtpScreen.dart';
import 'LoginService.dart';

class SiginSignUpController extends GetxController {
  var getOTPButton = "GET OTP".obs;
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
      getOTPButton.value = "Sending OTP...";
      isLoading.value = true; // Start loading
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false; // Set loading to false
      getOTPButton.value = "SENT OTP"; // Reset button text

      phoneNumber = mobileController.text.trim();
      final fullname = nameController.text.trim();
      final mobileNumber = mobileController.text.trim();
      try {
        final response =
            await _loginapiService.signInOrSignUp(fullname, mobileNumber);
        if (response['status'] == 200) {
          getOTPButton.value = "GET OTP";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => Otpscreencustomer(
                PhoneNumberstored: phoneNumber!,
                username: fullname,
              ),
            ),
          );
        } else {
          getOTPButton.value = "GET OTP";
        }
      } catch (e) {
        getOTPButton.value = "GET OTP";
      } finally {
        isLoading.value = false; // Hide loading state
      }
    }
    if (!agreeToTerms) {
      errorMessage.value = "Please agree to terms and conditions";
    }
  }
}
