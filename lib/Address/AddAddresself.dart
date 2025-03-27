import 'package:cutomer_app/APIs/AddressAPi.dart';
import 'package:cutomer_app/Address/SaveAddressScreenself.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Toasters/Toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../Dashboard/Dashboard.dart';
import 'GoogleMapSearchPlacesApi.dart';

const kGoogleApiKey =
    'AIzaSyCmVhTkTe3fL1MI0VA7V4znEUTS56q2RMg'; // Replace with your API key
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddAddresself extends StatefulWidget {
  final String mobileNumber;
  final String addressSearch;
  final String username;
  final bool isLocation;

  const AddAddresself({
    Key? key,
    required this.mobileNumber,
    required this.addressSearch,
    required this.username,
    required this.isLocation,
  }) : super(key: key);

  @override
  State<AddAddresself> createState() => _CurrentLocationlState();
}

class _CurrentLocationlState extends State<AddAddresself> {
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
  bool isSearch = false; // Track if a search result is selected

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
        sublocality = placemark.subLocality?.isNotEmpty == true
            ? placemark.subLocality!
            : placemark.locality?.isNotEmpty == true
                ? placemark.locality!
                : placemark.administrativeArea?.isNotEmpty == true
                    ? placemark.administrativeArea!
                    : "Unknown Area";
        ;
        _isLoading = false;
        isSearch = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveCamera(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(position, 18),
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

  // Future<void> _onSearchAddress(String query) async {
  //   final response = await _places.searchByText(query);
  //   if (response.isOkay && response.results.isNotEmpty) {
  //     final result = response.results.first;
  //     _moveCamera(
  //         LatLng(result.geometry!.location.lat, result.geometry!.location.lng));
  //   }
  // }

  Future<void> _onSearchAddress(String query) async {
    final response = await _places.searchByText(query);
    if (response.isOkay && response.results.isNotEmpty) {
      final result = response.results.first;
      LatLng position =
          LatLng(result.geometry!.location.lat, result.geometry!.location.lng);

      _moveCamera(position);
      _updatePosition(position.latitude, position.longitude);
      setState(() {
        address = result.formattedAddress ?? 'Address not found';
        sublocality = result.name ?? '';
        isSearch = true; // Indicate that the address is a search result
      });
    }
  }

  // Future<void> _onSearchAddress(String query) async {
  //   // print("jhjhjdjskfhkdsh${lat}");
  //   final response = await _places.searchByText(query);
  //   if (response.isOkay && response.results.isNotEmpty) {
  //     final result = response.results.first;
  //     LatLng position =
  //         LatLng(result.geometry!.location.lat, result.geometry!.location.lng);

  //     _moveCamera(position);
  //     _updatePosition(position.latitude, position.longitude);
  //   }
  // }

  void _onConfirmAddress() async {
    // Call the instance method onConfirmAddress
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaveAddressScreenself(
            street: street,
            username: widget.username,
            sublocality: sublocality,
            locality: locality,
            administrativeArea: administrativeArea,
            postalCode: postalCode,
            country: country,
            lat: currentPosition.latitude,
            lng: currentPosition.longitude,
            mobileNumber: widget
                .mobileNumber,
                isLocation:widget.isLocation
                
                ), // Pass all necessary arguments through the constructor
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Address ", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                        zoom: 18.0,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId("currentLocation"),
                          position: currentPosition,
                        ),
                      },
                      onCameraMove: _onCameraMove,
                    ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Icon(
                    //     Icons.location_on,
                    //     size: 50,
                    //     color: Colors.red,
                    //   ),
                    // ),
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
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
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
                            "Current Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(
                          //           10), // Set the border radius to 10
                          //     ),
                          //   ),
                          //   child: Text(
                          //     "Change".toUpperCase(),
                          //     style: TextStyle(color: Colors.red, fontSize: 16),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SingleChildScrollView(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 24.0,
                            ),
                            Text(
                              sublocality,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 8.0),
                          ],
                        ),
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
                                    0xFF6A5B94), // Change color when disabled
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
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
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
    if (query.isEmpty) {
      return Center(child: Text('Start typing to search for a location'));
    }

    return FutureBuilder<PlacesSearchResponse>(
      future:
          _places.searchByText(query), // Searching the text entered by the user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
          return Center(child: Text('No results found'));
        }

        final suggestions = snapshot.data!.results;

        // No filtering, show all results
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final result = suggestions[index];
            return ListTile(
              title: Text(result.formattedAddress ?? 'No Address Found'),
              onTap: () {
                onSearchAddress(result.formattedAddress ?? '');
                close(context, result.formattedAddress ?? '');
              },
            );
          },
        );
      },
    );
  }
}
