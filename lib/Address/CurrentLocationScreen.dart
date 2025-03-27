import 'package:cutomer_app/APIs/AddressAPi.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Toasters/Toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
 
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../Dashboard/Dashboard.dart';
import '../Utils/ScaffoldMessageSnacber.dart';
import '../verification/registrationsuccess.dart';
import 'GoogleMapSearchPlacesApi.dart';

const kGoogleApiKey =
    'AIzaSyCmVhTkTe3fL1MI0VA7V4znEUTS56q2RMg'; // Replace with your API key
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CurrentLocationl extends StatefulWidget {
  final String mobileNumber;
  // Constructor with required mobileNumber
  const CurrentLocationl({super.key, required this.mobileNumber});

  @override
  State<CurrentLocationl> createState() => _CurrentLocationlState();
}

class _CurrentLocationlState extends State<CurrentLocationl> {
  String address = "Fetching location...";
  LatLng currentPosition = LatLng(0, 0);
  late GoogleMapController _mapController;
  Marker? _searchMarker;
  bool _isLoading = true;
  Timer? _debounceTimer;
  String sublocality = '';
  String street = '';
  String locality = '';
  String postalCode = '';
  String administrativeArea = '';
  String country = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocationl();
  }

  Future<void> _getCurrentLocationl() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          address = "Location permissions are permanently denied.";
          _isLoading = false;
        });
        return;
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          address = "Location permissions are denied.";
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _updatePosition(position.latitude, position.longitude);
      _moveCamera(LatLng(position.latitude, position.longitude));
    } catch (e) {
      setState(() {
        address = "Failed to get location: $e";
        _isLoading = false;
      });
    }
  }

  void _updatePosition(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      setState(() {
        address =
            "${placemark.street}, ${placemark.locality} - ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";
        currentPosition = LatLng(latitude, longitude);

        street = "${placemark.street} ";
        locality = "${placemark.locality} ";
        postalCode = "${placemark.postalCode} ";
        administrativeArea = "${placemark.administrativeArea} ";
        country = "${placemark.country} ";
        sublocality = "${placemark.subLocality} ";
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveCamera(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(position, 16),
    );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      currentPosition = position.target;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(seconds: 2), () {
      _updatePosition(currentPosition.latitude, currentPosition.longitude);
    });
  }

  Future<void> _onSearchAddress(String query) async {
    final response = await _places.searchByText(query);
    if (response.isOkay && response.results.isNotEmpty) {
      final result = response.results.first;
      _moveCamera(
          LatLng(result.geometry!.location.lat, result.geometry!.location.lng));
    }
  }

  void _onConfirmAddress() async {
    print("[LOG - ${DateTime.now()}] Starting address confirmation process...");

    try {
      // Create an instance of AddressAPI
      print("[LOG - ${DateTime.now()}] Initializing AddressAPI...");
      final addressAPI = AddressAPI();

      // Create AddressModel instance
      AddressModel address = AddressModel(
        houseNo: "NA",
        street: street,
        city: sublocality,
        state: administrativeArea,
        postalCode: postalCode,
        country: country,
        apartment: 'NA',
        direction: 'NA',
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        // saveAs: 'NA',
        // receiverName: 'NA',
        // receiverMobileNumber: 0,
      );

      print("[LOG - ${DateTime.now()}] Address: ${address.toJson()}");
      print("[LOG - ${DateTime.now()}] Mobile Number: ${widget.mobileNumber}");

      // Call the instance method onConfirmAddress
      print(
          "[LOG - ${DateTime.now()}] Sending address confirmation request...");
      final response =
          await addressAPI.onConfirmAddress(address, widget.mobileNumber);

      // Log the entire response for debugging
      print("[LOG - ${DateTime.now()}] Response: $response");

      // Check for success status codes (200 or 201)
      if (response.statusCode == 200) {
        ScaffoldMessageSnackbar.show(
      context: context,
      message: "Address sent successfully",
      type: SnackbarType.success,
    );
        print("[LOG - ${DateTime.now()}] Address sent successfully.");

        // Success - navigate to the dashboard screen
        print(
            "[LOG - ${DateTime.now()}] Navigating to dashboard with sublocality: $sublocality");
        VerificationMessage.registraionMessage(context);
        await Future.delayed(Duration(seconds: 3));

        Navigator.pushNamedAndRemoveUntil(
          context,
          "/dashboard", // This should match the registered route exactly
          (Route<dynamic> route) => false, // Remove all previous routes
          arguments: sublocality, // Pass the sublocality as an argument
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessageSnackbar.show(
      context: context,
      message: "Failed to send address",
      type: SnackbarType.error,
    );
      } else {
        // Log failure with status code
        print(
            "[LOG - ${DateTime.now()}] Failed to send address. Status code: ${response.statusCode}");
        // Optionally show an error toast
      }
    } catch (e) {
      // Log error with exception message
      print("[LOG - ${DateTime.now()}] Error during address confirmation: $e");
    }

    print("[LOG - ${DateTime.now()}] Address confirmation process ended.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B3FA0),
        title: Text("Add Address", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate:
                    AddressSearchDelegate(onSearchAddress: _onSearchAddress),
              );
              GoogleMapSearchPlacesApi();

              if (result != null) {
                _onSearchAddress(result);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Map takes 70% of the screen
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: currentPosition,
                        zoom: 14.0,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId("currentLocation"),
                          position: currentPosition,
                        ),
                      },
                      onCameraMove: _onCameraMove,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                    // "Locate Me" button at the top and centered
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      top: null,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: _getCurrentLocationl,
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.red,
                          ),
                          label: Text(
                            "Locate Me",
                            style: TextStyle(color: Colors.red),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom 30% for the address and buttons
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Location:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set the border radius to 10
                              ),
                            ),
                            child: Text(
                              "Change".toUpperCase(),
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 24.0,
                          ),
                          Text(
                            sublocality,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              address,
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _onConfirmAddress, // Disable when loading
                          child: Text(
                            "Confirm Address".toUpperCase(),
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            backgroundColor: _isLoading
                                ? Colors.grey
                                : Color(
                                    0xFF6B3FA0), // Change color when disabled
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddressSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearchAddress;

  AddressSearchDelegate({required this.onSearchAddress});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      title: Text(query),
      onTap: () => close(context, query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // You can show address suggestions here
    return ListTile(
      title: Text(query),
      onTap: () => close(context, query),
    );
  }
}
