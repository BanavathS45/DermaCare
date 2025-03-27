// Widget for "Self" tab

import 'dart:convert';
import 'package:cutomer_app/Toasters/Toaster.dart';
import 'package:cutomer_app/Utils/AdreessFormat.dart';
import 'package:http/http.dart' as http;
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Modals/SaavedAddressModal.dart';
import 'package:flutter/material.dart';

import '../Modals/SummaryAddress.dart';
import '../Services/Selectdateandtimescreen.dart';
import '../Utils/ScaffoldMessageSnacber.dart';
import 'ClinicDetails.dart';

class SelfTab extends StatefulWidget {
  final Patient? patient;
  final String username;
  final String mobileNumber;
  final String? fullAddressself;
  final AddressModel? addressmodal;
  final String? address; // Variable to store the desired address
  final bool isLocation;

  const SelfTab({
    super.key,
    required this.patient,
    required this.username,
    required this.fullAddressself,
    required this.mobileNumber,
    required this.addressmodal,
    required this.isLocation,
    this.address,
  });

  @override
  State<SelfTab> createState() => _SelfTabState();
}

class _SelfTabState extends State<SelfTab> {
  String? _formattedAddress;
  int _selectedIndex = 0;

  AddressModel? savedselectedAddress;

  final TextEditingController _ageController = TextEditingController();

  String? email;

  String selectedOption = "Home Service"; // Default selected option
  String? selectedClinic;
  String homeService = "Home Service";
  String clinicVisit = "Clinic Visit";
  int? Cliniclength;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clinicSelectionPage = ClinicSelectionPage();

    String formattedAddress = savedselectedAddress != null
        ? formatAddressModel(
            savedselectedAddress!) // Use the function to get the formatted string
        : (widget.fullAddressself != null && widget.fullAddressself!.isNotEmpty)
            ? widget.fullAddressself! // Use fullAddressself if available
            : _formattedAddress ??
                "No Address"; // Final fallback to formattedAddress or "No Address"
    AddressModel? selectedAddressModel =
        savedselectedAddress ?? widget.addressmodal;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Patient Name',
                border: OutlineInputBorder(),
              ),
              child: Text(widget.patient?.fullName ?? ""),
            ),
            const SizedBox(height: 25),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label for the container
                const Text(
                  "Service Location", // Label text
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                const SizedBox(
                    height: 8.0), // Spacing between the label and the container

                // Container with address and actions
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0), // Padding around the container
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey), // Border color (optional)
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Displaying the formatted address
                        Text(
                          (savedselectedAddress?.toString() ??
                              (widget.fullAddressself ??
                                  _formattedAddress ??
                                  "No Address")), // Finally fallback to _formattedAddress or a default string
                          // Show only _formattedAddress if isLocation is false
                          style: const TextStyle(fontSize: 14),
                        ),

                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Current Location Text
                            const Text(
                              "CURRENT LOCATION",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Change Button with Removed Padding
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/addresself',
                                  arguments: {
                                    'mobileNumber': widget.mobileNumber,
                                    'username': widget.username,
                                    'isLocation': true
                                  },
                                );

                                if (result != null && result is AddressModel) {
                                  // Handle the returned address modal
                                  setState(() {
                                    savedselectedAddress = result;
                                  });

                                  print(
                                      "Saved Selected Address: $savedselectedAddress");
                                }
                              },
                              child: const Text(
                                "CHANGE",
                                style: TextStyle(
                                  color: Color(0xFFFF0000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              child: Text(widget.patient?.gender ?? ""),
            ),
            const SizedBox(height: 25),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                border: OutlineInputBorder(),
              ),
              child: Text(widget.patient?.bloodGroup ?? "NA"),
            ),
            const SizedBox(height: 25),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              child: Text(widget.patient?.age.toString() ?? "Unknown"),
            ),
            const SizedBox(height: 25),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              child: Text(widget.patient?.email ?? "No email available"),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(
                  8.0), // Adjusted padding for better spacing
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose Service Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Increased font size for better visibility
                    ),
                  ),
                  const SizedBox(
                      height: 12), // Add space between heading and buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedOption = homeService;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedOption == homeService
                                ? const Color(
                                    0xFF4C3C7D) // Highlighted color for selection
                                : Colors
                                    .grey.shade300, // Default unselected color
                            foregroundColor: selectedOption == homeService
                                ? Colors.white // Text color for selected button
                                : Colors
                                    .black, // Text color for unselected button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          child: Text(homeService),
                        ),
                      ),
                      const SizedBox(width: 8), // Add space between buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedOption = clinicVisit;

                              // Show the clinic selection bottom sheet
                              clinicSelectionPage.showClinicBottomSheet(context,
                                  (selectedClinic) {
                                setState(() {
                                  this.selectedClinic = selectedClinic;
                                });
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedOption == clinicVisit
                                ? const Color(
                                    0xFF4C3C7D) // Highlighted color for selection
                                : Colors
                                    .grey.shade300, // Default unselected color
                            foregroundColor: selectedOption == clinicVisit
                                ? Colors.white // Text color for selected button
                                : Colors
                                    .black, // Text color for unselected button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          child: Text(clinicVisit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // Add space below buttons
                  if (selectedOption == clinicVisit && selectedClinic != null)
                    Text(
                      "Selected Clinic: $selectedClinic",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Centered ElevatedButton
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (widget.patient?.fullName != null)
                  ? () {
                      if (selectedOption == null) {
                        // No service location selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select a service location.",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (selectedOption == "Clinic Visit" &&
                          selectedClinic == null) {
                        // Clinic Visit selected but no clinic is chosen
                        ScaffoldMessageSnackbar.show(
      context: context,
      message: "Please select a clinic before continuing",
      type: SnackbarType.error,
    );
                      } else {
                        // Proceed if all inputs are valid
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectDateTimeScreen(
                              mobileNumber: widget.mobileNumber,
                              patientname:
                                  widget.patient?.fullName ?? "Unknown",
                              patientNumber: widget.mobileNumber,
                              gender: widget.patient?.gender ?? "Unknown",
                              bloodGroup: widget.patient?.bloodGroup ?? "NA",
                              age: widget.patient?.age ?? 0,
                              email: widget.patient?.email ?? "No email",
                              formattedAddress:
                                  formattedAddress, // Use formatted address if available, else "No Address"

                              // Use clinic address if required
                              addressmodal: selectedAddressModel,
                              username: widget.username,
                              relation: "Self",
                              saveAs: selectedClinic,
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // Customize button color
                backgroundColor: widget.patient?.fullName != null
                    ? Color(0xFF6A5B94)
                    : Colors.grey, // Active and disabled colors
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
