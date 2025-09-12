import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorService.dart';
import 'package:cutomer_app/Firebase/RequestNotificationPermissions.dart';
import 'package:cutomer_app/SigninSignUp/LoginController.dart';
import 'package:cutomer_app/SigninSignUp/LoginService.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../ConfirmBooking/Consultations.dart';
import '../SigninSignUp/LoginScreen.dart';
import 'package:http/http.dart' as http;

class BiometricAuthScreen extends StatefulWidget {
  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  SiginSignUpController siginSignUpController = SiginSignUpController();
  final LoginApiService _loginApiService = LoginApiService();
  final DoctorService _doctorService = DoctorService();

  bool _isLoading = false; // 🔑 Loading state

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    requestFCMPermission();
    getFCMToken();
  }

  Future<void> _checkBiometrics() async {
    setState(() => _isLoading = true); // show loading
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        await _authenticate();
      } else {
        print("❌ Device doesn't support biometrics. Redirecting to login.");
        Get.offAll(() => Loginscreen());
      }
    } finally {
      setState(() => _isLoading = false); // hide loading
    }
  }

  Future<void> _authenticate() async {
    setState(() => _isLoading = true); // show loading
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final mobileNumber = prefs.getString('mobileNumber');
      final isAuthenticate = prefs.getBool('isAuthenticated') ?? false;
      final isFirstLoginDone = prefs.getBool('isFirstLoginDone') ?? false;

      print("🔐 Biometric Authenticated: $isAuthenticated");
      print("📦 Stored Username: $username");
      print("📦 Stored Mobile Number: $mobileNumber");
      print("✅ First Login Completed: $isFirstLoginDone");

      if (isAuthenticated &&
          isAuthenticate &&
          isFirstLoginDone &&
          username != null &&
          mobileNumber != null) {
        final deviceId = prefs.getString('fcm');
        print("deviceIddeviceIddeviceId : ${deviceId}");

        final checkUserResponse = await http.get(
          Uri.parse('$registerUrl/getBasicDetails/$mobileNumber'),
        );

        if (checkUserResponse.statusCode == 200) {
          final data = json.decode(checkUserResponse.body);
          if (data['success'] == true && data['data'] != null) {
            Get.offAll(ConsultationsType(
              mobileNumber: mobileNumber,
              username: username,
            ));
            print("🚀 Login successful. Navigating to ConsultationsType.");
          } else {
            showSnackbar(
              "Warning",
              "No user data found for this biometric. Please log in again.",
              "warning",
            );
            Get.offAll(() => Loginscreen());
          }
        } else {
          Get.offAll(() => Loginscreen());
        }
      }
    } catch (e) {
      print("❌ Biometric authentication error: $e");
      Get.offAll(() => Loginscreen());
    } finally {
      setState(() => _isLoading = false); // hide loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mainColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Authenticating...",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                )
              : Column(
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
                      onPressed: _isLoading ? null : _authenticate,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text("Authenticate"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
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
      ),
    );
  }
}
