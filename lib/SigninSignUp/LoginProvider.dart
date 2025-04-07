import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../BottomNavigation/BottomNavigation.dart';

// class LoginScreenProvider extends StatefulWidget {
//   @override
//   _LoginScreenProviderState createState() => _LoginScreenProviderState();
// }

// class _LoginScreenProviderState extends State<LoginScreenProvider> {
//   final LocalAuthentication auth = LocalAuthentication();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool _biometricEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     checkBiometricEnabled();
//   }

//   Future<void> checkBiometricEnabled() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;

//     if (isBiometricEnabled) {
//       final didAuthenticate = await auth.authenticate(
//         localizedReason: 'Please authenticate to login',
//         options: const AuthenticationOptions(biometricOnly: true),
//       );

//       if (didAuthenticate) {
//         final storedUsername = prefs.getString('last_username') ?? '';
//         final storedMobile = prefs.getString('last_mobile') ?? '';

//         Get.offAll(BiometricAuthScreen(
//           toggleTheme: () {},
//         ));
//       }
//     }
//   }

//   Future<void> handleLogin() async {
//     print("jhfjkhsdkjfsdfdsf  ");

//     if (usernameController.text == 'admin' &&
//         passwordController.text == 'admin') {
//       print("jhfjkhsdkjfsdfdsf ${usernameController.text}");
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('logged_in_once', true);

//       final canCheckBiometrics = await auth.canCheckBiometrics;
//       final isBiometricAvailable = await auth.isDeviceSupported();

//       if (canCheckBiometrics && isBiometricAvailable) {
//         final didAuthenticate = await auth.authenticate(
//           localizedReason: 'Authenticate to enable biometric login',
//         );

//         if (didAuthenticate) {
//           await prefs.setBool('biometric_enabled', true);
//         }
//       }

//       // Always navigate after login
//       Get.offAll(BiometricAuthScreen(
//         toggleTheme: () {},
//       ));
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Invalid credentials")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//                 controller: usernameController,
//                 decoration: InputDecoration(labelText: 'Username')),
//             TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: handleLogin, child: Text('Login')),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BiometricAuthScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  BiometricAuthScreen({required this.toggleTheme});
  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = true;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> saveAuthStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', status);
  }

  Future<bool> getAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    try {
      print("Starting authentication...");
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      print("Authentication status: $isAuthenticated");

      if (isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('last_username') ?? 'admin';
        final mobile = prefs.getString('last_mobile') ?? '7842259803';

        // ✅ Navigate to the actual app screen
        Get.offAll(BottomNavController(
          mobileNumber: mobile,
          username: username,
          index: 0,
        ));
      } else {
        print("Authentication failed or was canceled by the user.");
      }
    } catch (e) {
      print("Authentication error: $e");
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  "Powered by",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70, // Subtle color for branding
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "Cheislon Technologies",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Icon(
              Icons.lock_outline_rounded,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Secure Access",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Authenticate to continue",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _authenticate,
              icon: Icon(Icons.fingerprint, size: 24),
              label: Text(
                "Authenticate",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
