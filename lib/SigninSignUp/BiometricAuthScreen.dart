import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorService.dart';
import 'package:cutomer_app/Firebase/RequestNotificationPermissions.dart';
import 'package:cutomer_app/SigninSignUp/LoginController.dart';
import 'package:cutomer_app/SigninSignUp/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BottomNavigation/BottomNavigation.dart';
import '../ConfirmBooking/Consultations.dart';
import '../SigninSignUp/LoginScreen.dart';

class BiometricAuthScreen extends StatefulWidget {
  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  SiginSignUpController siginSignUpController = SiginSignUpController();
  final LoginApiService _loginApiService = LoginApiService();
  final DoctorService _doctorService = DoctorService();
  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    requestFCMPermission();
    getFCMToken();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      _authenticate();
    } else {
      print("❌ Device doesn't support biometrics. Redirecting to login.");
      Get.offAll(() => Loginscreen());
    }
  }

  Future<void> _authenticate() async {
    try {
      // Trigger biometric authentication
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      // Retrieve session data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final mobileNumber = prefs.getString('mobileNumber');
      final isAuthenticate = prefs.getBool('isAuthenticated') ?? false;
      final isFirstLoginDone = prefs.getBool('isFirstLoginDone') ?? false;

      // Debug logs
      print("🔐 Biometric Authenticated: $isAuthenticated");
      print("📦 Stored Username: $username");
      print("📦 Stored Mobile Number: $mobileNumber");
      print("✅ First Login Completed: $isFirstLoginDone");

      // Validate authentication and session state
      if (isAuthenticated &&
          isAuthenticate &&
          isFirstLoginDone &&
          username != null &&
          mobileNumber != null) {
        print("🎯 Authentication and session valid. Proceeding to login API.");

        // Call login/sign-up API
        final loginData =
            await _loginApiService.sendUserDataWithFCMToken(username, mobileNumber);
        print("📥 Login API Response: $loginData");

        // Check login API response and navigate accordingly
        if (loginData != null && loginData['status'] == 200) {
          print("🚀 Login successful. Navigating to ConsultationsType.");
          Get.offAll(() => ConsultationsType(
                mobileNumber: mobileNumber,
                username: username,
              ));
        } else {
          print("⚠️ Incomplete session data. Redirecting to LoginScreen.");
          Get.offAll(() => Loginscreen());
        }
      } else {
        print(
            "⚠️ Authentication or session invalid. Redirecting to LoginScreen.");
        Get.offAll(() => Loginscreen());
      }
    } catch (e) {
      // Handle biometric authentication errors
      print("❌ Biometric authentication error: $e");
      Get.offAll(() => Loginscreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade700, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded,
                size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Secure Access",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Authenticate to continue",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _authenticate,
              icon: const Icon(Icons.fingerprint),
              label: const Text("Authenticate"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
