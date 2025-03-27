import 'package:cutomer_app/BottomNavigation/BottomNavigation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/CustomerController.dart';
import '../SigninSignUp/LoginScreen.dart';
import '../Services/GetCustomerDataService.dart';
import '../Toasters/Toaster.dart'; // For Google Maps
// Import the LocationController

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _address = "";
  String? locationMessage = "Fetching location...";
  bool isLoading = true;
  Position? _currentPosition;
  late GoogleMapController _mapController;
  final LatLng _initialPosition =
      const LatLng(20.5937, 78.9629); // Default location (India)

  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getLocation();
    } else {
      setState(() {
        locationMessage = "Location permission denied.";
        isLoading = false;
      });
      showErrorToast(
          msg: 'GPS is disabled. Please enable it to access your location.');
    }
  }

  var subLocality;

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        setState(() {
          _currentPosition = position;
          locationMessage = "${position.latitude}, ${position.longitude}";
          isLoading = false;
        });

        // Get the address from location coordinates
        _getAddress(position.latitude, position.longitude);
        await Future.delayed(Duration(seconds: 3));

        // Check login status after getting location
        await checkLoginStatus();
      }
    } catch (e) {
      setState(() {
        locationMessage = "Error getting location: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Formatting the address to match the desired structure

        // Update the controller with the subLocality

        subLocality = place.subLocality?.isNotEmpty == true
            ? place.subLocality!
            : place.locality?.isNotEmpty == true
                ? place.locality!
                : place.administrativeArea?.isNotEmpty == true
                    ? place.administrativeArea!
                    : "Unknown Area";

        locationController.setSubLocality(subLocality ?? "");
        _address =
            "${place.street}, ${place.locality},${subLocality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        setState(() {}); // Update UI with the formatted address
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  CustomerDataBasicInfo customerDataBasicInfo = CustomerDataBasicInfo();
  Future<void> checkLoginStatus() async {
    // Get the shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the 'isLoggedIn' value, defaulting to false if not found
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String mobileNumber = prefs.getString('mobileNumber') ?? "No mobile number";
    String username = prefs.getString('username') ?? "No username";

    // Now you can use the isLoggedIn value
    if (!mounted) return; // Ensure widget is still in the widget tree

    if (isLoggedIn && (mobileNumber != null)) {
      var userData = await customerDataBasicInfo
        .fetchCustomerDataData(mobileNumber);
      if (userData != null) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavController(
              mobileNumber: mobileNumber,
              username: username,
              index: 0,
            ),
          ),
          (Route<dynamic> route) =>
              false, // This will remove all previous routes
        );
      } else {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Loginscreen(),
          ),
          (Route<dynamic> route) =>
              false, // This will remove all previous routes
        );
      }
      // Navigate to the dashboard or a different screen
    } else {
      // Show login screen or handle not logged in state
      // Navigator.pushReplacementNamed(context, '/login');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Loginscreen(),
        ),
        (Route<dynamic> route) => false, // This will remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map Image
          // Gradient Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFAFAFA), // Light off-white (top)
                    Color(0xFF008080), // Deep teal (center)
                    Color(0xFF004D40), // Bottom color
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // Adjust opacity as needed
              child: Image.asset(
                'assets/map1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay for contrast (if needed)
          // Container(
          //   color: Colors.white.withOpacity(0.7),
          // ),
          // Overlay for contrast
          Container(
            color: Colors.white.withOpacity(0.7),
          ),
          // Main Content
          Center(
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Center Location Icon
                      Image.asset(
                        'assets/location.gif',
                        // 'https://i.pinimg.com/originals/20/d8/73/20d8733b97d44108a7c4cc40564dff71.gif', // Replace with your location icon image URL
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Detecting Location...",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Center Location Icon
                      Image.asset(
                        'assets/location.gif', // Replace with your location icon image URL
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Service at".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 24.0,
                                  ),
                                  Text(
                                    subLocality ?? "Unknown Location",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                 _address ?? "Fetching address...",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
