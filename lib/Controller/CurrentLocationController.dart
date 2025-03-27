// import 'package:flutter/material.dart';
// import 'package:flutter_google_maps_webservices/places.dart';

// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';

// class MyWidgetState extends State<MyWidget> {
//   String _address = "Fetching location...";
//   LatLng _currentPosition = LatLng(0, 0);
//   late GoogleMapController _mapController;
//   Marker? _searchMarker;
//   bool _isLoading = true;
//   Timer? _debounceTimer;
//   String sublocality = '';

 
//   const kGoogleApiKey =
//       'AIzaSyDY_mNvqPbcGCRiwor1IVcJ5pyRmstm9XY'; // Replace with your API key
//   final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

//   Future<void> _getCurrentLocationl() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _address = "Location permissions are permanently denied.";
//           _isLoading = false;
//         });
//         return;
//       }

//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _address = "Location permissions are denied.";
//           _isLoading = false;
//         });
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       _updatePosition(position.latitude, position.longitude);
//       _moveCamera(LatLng(position.latitude, position.longitude));
//     } catch (e) {
//       setState(() {
//         _address = "Failed to get location: $e";
//         _isLoading = false;
//       });
//     }
//   }

//   void _updatePosition(double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     if (placemarks.isNotEmpty) {
//       Placemark placemark = placemarks[0];
//       setState(() {
//         _address =
//             "${placemark.street}, ${placemark.locality} - ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";
//         _currentPosition = LatLng(latitude, longitude);
//         sublocality = "${placemark.subLocality}";
//         _isLoading = false;
//       });
//     }
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   void _moveCamera(LatLng position) {
//     _mapController.animateCamera(
//       CameraUpdate.newLatLngZoom(position, 16),
//     );
//   }

//   void _onCameraMove(CameraPosition position) {
//     setState(() {
//       _currentPosition = position.target;
//     });

//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(Duration(seconds: 2), () {
//       _updatePosition(_currentPosition.latitude, _currentPosition.longitude);
//     });
//   }

//   Future<void> _onSearchAddress(String query) async {
//     final response = await _places.searchByText(query);
//     if (response.isOkay && response.results.isNotEmpty) {
//       final result = response.results.first;
//       _moveCamera(
//           LatLng(result.geometry!.location.lat, result.geometry!.location.lng));
//     }
//   }
  
 
