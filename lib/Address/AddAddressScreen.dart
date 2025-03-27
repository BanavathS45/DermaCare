import 'dart:convert';
import 'package:cutomer_app/Address/AddAddress.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  final String mobileNumber;
  final String username;

  AddAddressScreen({
    required this.mobileNumber,
    required this.username,
  });

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _controller = TextEditingController();
  String _address = "";
  bool _isUsingCurrentLocation = false;
  List<String> _savedAddresses = [];
  List<dynamic> _placeList = [];
  String _sessionToken = '1234567890';
  final uuid = Uuid();
  String selectedAddress = '';
  LatLng currentPosition = LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _controller.addListener(_onChanged);
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _placeList.clear();
    });
  }

  // Function to handle the search field changes
  _onChanged() {
    if (_sessionToken.isEmpty) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  // Function to get suggestions from Google Places API
  void getSuggestion(String input) async {
    const String PLACES_API_KEY =
        "AIzaSyCmVhTkTe3fL1MI0VA7V4znEUTS56q2RMg"; // Replace with your API key
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
          // print("hdfkjhddsadskfhk${_placeList[index]["description"]}");
          print("hdfkjhdskfhkdh${response.body}");
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  // Function to get the current location of the user
  Future<void> _getCurrentLocation() async {
    try {
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      setState(() {
        _isUsingCurrentLocation = true;
        _getAddress(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  // Function to get the address from coordinates
  Future<void> _getAddress(double latitude, double longitude) async {
    print("%^&&*YFGHJK${latitude}");
    print("%^&&*YFGHJK${latitude}");

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        currentPosition = LatLng(latitude, longitude);

        setState(() {});
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  // Function to handle the "Use my current location" button press
  void _useCurrentLocation() {
    Navigator.of(context).pushNamed(
      '/currentloaction',
      arguments: widget.mobileNumber,
    );
    setState(() {
      _isUsingCurrentLocation = true;
    });
    _getCurrentLocation();
  }

  // Function to handle the "Add new address" button press
  void _addNewAddress() {
    Navigator.pushNamed(context, "/addaddress",
        arguments: [widget.mobileNumber, selectedAddress, widget.username]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddress(
          mobileNumber: widget.mobileNumber,
          username: widget.username,
        ),
      ),
    );

    print("Add new address clickeddsd${selectedAddress}");
    print("Add new address clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Try for area, city...',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : Icon(Icons.search),
              ),
            ),
            if (_controller.text.isEmpty)
              ListTile(
                leading: Icon(Icons.add, color: Colors.red),
                title: Text('Add new address',
                    style: TextStyle(color: Colors.red)),
                onTap: _addNewAddress,
              ),
            Divider(color: Color(0xFFE0E0E0)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeList[index]["description"] ?? ''),
                  onTap: () {
                    setState(() {
                      _controller.text = _placeList[index]["description"] ?? '';
                      _placeList = [];
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddress(
                            mobileNumber: widget.mobileNumber,
                            username:
                                widget.username // Pass the selected address
                            // Optionally pass latitude and longitude if you have them
                            ),
                      ),
                    );

                    setState(() {
                      _controller.text = selectedAddress;
                      print("JHJHGJHHJ%${currentPosition}");
                      _placeList = [];
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
