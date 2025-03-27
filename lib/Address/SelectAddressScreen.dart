// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class SelectAddressScreen extends StatefulWidget {
//   const SelectAddressScreen({super.key});

//   @override
//   State<SelectAddressScreen> createState() => _SelectAddressScreenState();
// }

// class _SelectAddressScreenState extends State<SelectAddressScreen> {
//   GoogleMapController? _mapController;
//   TextEditingController _searchController = TextEditingController();
//   List<String> addresses = [
//     'Forest Park, Portland',
//     'West Haven-Sylvan, Portland',
//     'Garden Home-Whitford, Portland',
//     'Jubilee Hills, Hyderabad, Telangana, India'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Address'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for a building, street name or area',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     // Handle search query
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(17.385044, 78.486671), // Hyderabad coordinates
//                 zoom: 12.0,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//               markers: addresses
//                   .map((address) => Marker(
//                         markerId: MarkerId(address),
//                         position: LatLng(0, 0), // Replace with actual coordinates
//                         infoWindow: InfoWindow(title: address),
//                       ))
//                   .toSet(),
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: () {
//               // Handle confirm location
//             },
//             child: const Text('CONFIRM LOCATION'),
//           ),
//         ],
//       ),
//     );
//   }
// }