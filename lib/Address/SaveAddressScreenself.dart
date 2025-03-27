import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Modals/AddressModal.dart';
import '../Services/PatientDetailsScreen.dart';
import '../Toasters/Toaster.dart';
import '../Utils/ScaffoldMessageSnacber.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveAddressScreenself extends StatefulWidget {
  final String sublocality;
  final String? street;
  final String locality;
  final String? postalCode;
  final String? administrativeArea;
  final String? country;
  final double? lat;
  final double? lng;
  final String mobileNumber;
  final String username;
  final bool isLocation;

  SaveAddressScreenself({
    Key? key,
    required this.sublocality,
    this.street,
    required this.locality,
    this.postalCode,
    this.administrativeArea,
    this.country,
    this.lat,
    this.lng,
    required this.mobileNumber,
    required this.username,
    required this.isLocation,
  }) : super(key: key);

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreenself> {
  // Form key to validate the form fields

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCategory = 'Home';
  // Text controllers for user input
  final TextEditingController houseController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController directionController = TextEditingController();

  // Variable to track selected category (Friends & Family, Others)
  // String? selectedCategory;

  // A list to simulate saving address details
  final List<Map<String, String>> _savedAddresses = [];

  String? fullAddress;

  @override
  void dispose() {
    houseController.dispose();
    apartmentController.dispose();
    directionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("isLocation In saved : ${widget.isLocation}");
  }

  // Function to handle saving the address details
  void _saveAddressDetails() async {
    AddressModel address = AddressModel(
      houseNo: houseController.text,
      street: widget.street ?? 'N/A',
      city: widget.sublocality ?? 'N/A',
      state: widget.administrativeArea ?? 'N/A',
      postalCode: widget.postalCode ?? 'N/A',
      country: widget.country ?? 'N/A',
      apartment: apartmentController.text,
      direction: directionController.text,
      latitude: widget.lat ?? 0,
      longitude: widget.lng ?? 0,
      // saveAs: selectedCategory ?? "NA",
      // receiverName: receiverNameController.text.isNotEmpty
      //     ? receiverNameController.text
      //     : "NA",
      // receiverMobileNumber: int.tryParse(phoneNumberController.text) ?? 0,
    );

    setState(() {
      fullAddress =
          '${houseController.text},${apartmentController.text},${widget.street},${widget.sublocality},${widget.locality},${widget.administrativeArea}, ${widget.country} - ${widget.postalCode}, ${directionController.text}';

      print("fullAddress::${fullAddress}");
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(
          mobileNumber: widget.mobileNumber,
          username: widget.username,
          fullAddressself: fullAddress,
          addressmodal: address,
          isLocation: widget.isLocation,
        ),
      ),
      // This will remove all previous routes
    );

    // setState(() {
    //   String? fullAddressself =
    //       "${widget.street}, ${widget.locality} - ${widget.postalCode}, ${widget.administrativeArea}, ${widget.country}";
    // });

    // setState(() {
    //   _savedAddresses.add(address);
    // });

    // Clear the form after saving
    _formKey.currentState!.reset();
    selectedCategory = null;
  }

  PhoneContact? _selectedContact;

  Future<void> _pickPhoneContact() async {

    try {
      // Request permission to access contacts if not granted already
      PermissionStatus permissionStatus = await Permission.contacts.status;
      if (permissionStatus != PermissionStatus.granted) {
        permissionStatus = await Permission.contacts.request();
        if (permissionStatus != PermissionStatus.granted) {
         ScaffoldMessageSnackbar.show(
    context: context,
    message: "Contacts permission denied",
    type: SnackbarType.error,
  );
          return;
        }
      }

      final PhoneContact contact =
          await FlutterContactPicker.pickPhoneContact();

      // Check if contact and phone number are not null
      if (contact != null &&
          contact.phoneNumber != null &&
          contact.phoneNumber!.number != null) {
        setState(() {
          _selectedContact = contact;
          ScaffoldMessageSnackbar.show(
      context: context,
      message: "Selected Contact: ${contact.fullName}",
      type: SnackbarType.success,
    );
        });
      } else {
        ScaffoldMessageSnackbar.show(
      context: context,
      message: "No phone number found in contact",
      type: SnackbarType.error,
    );
      }
    } catch (e) {
      ScaffoldMessageSnackbar.show(
      context: context,
      message: "Failed to pick contact",
      type: SnackbarType.error,
    );
      print('Failed to pick contact: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Save Address', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Google Map Display
                Container(
                  height: 200.0,
                  width: double.infinity,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat ?? 0.0,
                          widget.lng ?? 0.0), // Jubilee Hills coordinates
                      zoom: 18.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('current location'),
                        position: LatLng(widget.lat ?? 0.0, widget.lng ?? 0.0),
                        infoWindow: InfoWindow(
                          title: 'current location',
                          snippet: widget.sublocality,
                        ),
                      ),
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 24.0,
                          ),
                          Text(
                            widget.sublocality,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${widget.street}, ${widget.locality} - ${widget.postalCode}, ${widget.administrativeArea}, ${widget.country}",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // Instruction message box at the top
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 67, 54, 0.2),
                          border: Border.all(
                            color: const Color.fromRGBO(244, 67, 54, 1),
                          ),
                          // Red border with 2px width
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Rounded corners
                        ),

                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        margin: EdgeInsets.only(
                            bottom: 16), // Adds space below the box
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "A detailed address will help our caregiver reach your doorstep easily.",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // The rest of your code...
                  ],
                ),

                // House/Flat/Floor field (required)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: houseController,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    decoration: const InputDecoration(
                        labelText: 'HOUSE / FLAT / FLOOR NO.',
                        helperStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid HOUSE / FLAT / FLOOR NO.";
                      }
                      if (!RegExp(r'[A-Za-z0-9]').hasMatch(value)) {
                        return "Must contain at least one letter or number.";
                      }

                      return null; // No error
                    },
                  ),
                ),

                // Apartment/Road/Area field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: apartmentController,
                    decoration: const InputDecoration(
                        labelText: 'APARTMENT / ROAD / AREA (OPTIONAL)',
                        helperStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                  ),
                ),

                // Direction to reach field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: directionController,
                    decoration: const InputDecoration(
                        labelText: 'DIRECTION TO REACH (OPTIONAL)',
                        helperStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                  ),
                ),

                const SizedBox(height: 50.0),

                // Display saved addresses (for demonstration)
                if (_savedAddresses.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saved Addresses:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ..._savedAddresses.map((address) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'House: ${address['house']}, '
                            'Category: ${address['category']}, '
                            'Receiver: ${address['receiverName']}, '
                            'Phone: ${address['phoneNumber']}, '
                            'Apartment: ${address['apartment']}, '
                            'Direction: ${address['direction']}',
                          ),
                        );
                      }).toList(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _saveAddressDetails();
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text('SAVE ADDRESS DETAILS',
              style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
