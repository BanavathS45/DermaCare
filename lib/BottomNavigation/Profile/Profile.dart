import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final double customerLatitude;
  final double customerLongitude;

  const ProfilePage({
    Key? key,
    required this.customerLatitude,
    required this.customerLongitude,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double? _distanceInKm;

  @override
  void initState() {
    super.initState();
  }

  Future<void> logout(BuildContext context) async {
    // Check if the widget is still mounted before proceeding
    if (!context.mounted) return;

    // Get the shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the user data (you can clear specific keys or all preferences)
    await prefs.remove('isLoggedIn');
    await prefs.remove('mobileNumber');
    await prefs.remove('username');

    // Optionally, clear all preferences
    // await prefs.clear(); // This clears everything in SharedPreferences

    // Navigate to the login screen (or any other screen)
    // Replace '/login' with the actual login screen route name
    Navigator.pushReplacementNamed(context, '/login');

    print("User logged out successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "ProfilePage",
      ),
      body: Center(child: Text("Profile Page")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await logout(context); // Calls the logout function
        },
        child: Icon(
          Icons.logout,
          color: Colors.white,
        ), // You can change the icon here
      ),
    );
  }
}
