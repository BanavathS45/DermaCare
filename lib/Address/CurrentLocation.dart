// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:latlong2/latlong.dart';

// class LocationTracker extends StatefulWidget {
//   @override
//   _LocationTrackerState createState() => _LocationTrackerState();
// }

// class _LocationTrackerState extends State<LocationTracker> {
//   Position? _currentPosition;
//   String _locationDetails = "";
//   String _area = "";
//   MapController _mapController = MapController();

//   @override
//   void initState() {
//     super.initState();
//     // Automatically track location when the widget is initialized
//     _trackLocation();
//   }

//   Future<void> _fetchAddressDetails(double latitude, double longitude) async {
//     final url = Uri.parse(
//         'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json');
//     final response = await http.get(url);

//     print(response.body);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final address = data['address'];
//       final city =
//           address['city'] ?? address['town'] ?? address['village'] ?? "N/A";
//       final state = address['state'] ?? "N/A";
//       final country = address['country'] ?? "N/A";
//       final postcode = address['postcode'] ?? "N/A";
//       final roadNumber = address['road'] ?? "N/A";
//       final area = address['suburb'] ?? "N/A";

//       setState(() {
//         _area = area;
//         _locationDetails = "$roadNumber, $city - $postcode, $state, $country ";
//       });
//     } else {
//       setState(() {
//         _locationDetails = 'Failed to fetch address details';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Track Your Location'),
//         backgroundColor: const Color(0xFF6B3FA0),
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: LatLng(0, 0),
//                 zoom: 14,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                   maxZoom: 19,
//                 ),
//                 MarkerLayer(
//                   markers: _currentPosition != null
//                       ? [
//                           Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: LatLng(_currentPosition!.latitude,
//                                 _currentPosition!.longitude),
//                             builder: (ctx) => Icon(
//                               Icons.location_pin,
//                               color: Colors.red,
//                               size: 40,
//                             ),
//                           ),
//                         ]
//                       : [],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Current Location:",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   child: Text(
//                     "Change".toUpperCase(),
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start, // Aligns content to the left
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       color: Colors.red,
//                       size: 24.0,
//                     ),
//                     SizedBox(width: 8.0),
//                     Text(
//                       _area,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ), // Adds spacing between the two texts
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     _locationDetails, // Display location details
//                     style: TextStyle(fontSize: 16),
//                     textAlign: TextAlign.left, // Ensure left text alignment
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: Text("Confirm Address".toUpperCase()),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 15.0),
//                     foregroundColor: Colors.white,
//                     backgroundColor: const Color(0xFF6B3FA0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _trackLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _locationDetails = 'Location services are disabled.';
//       });
//       return;
//     }

//     // Check for location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _locationDetails = 'Location permissions are denied';
//         });
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _locationDetails =
//             'Location permissions are permanently denied, we cannot request permissions.';
//       });
//       return;
//     }

//     // Get the current position
//     LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy
//           .high, // You can use LocationAccuracy.low, medium, etc.
//       distanceFilter:
//           100, // Optional: distance in meters before location updates
//     );

//     Position position = await Geolocator.getCurrentPosition(
//       locationSettings: locationSettings,
//     );

//     setState(() {
//       _currentPosition = position;
//       _mapController.move(LatLng(position.latitude, position.longitude), 13);
//     });

//     _fetchAddressDetails(position.latitude, position.longitude);
//   }
// }
