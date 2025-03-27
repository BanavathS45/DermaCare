// Widget for "Other" tab

import 'package:cutomer_app/AddPatient/ClinicDetails.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Modals/SaavedAddressModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

import '../Modals/SummaryAddress.dart';
import '../Services/Selectdateandtimescreen.dart';
import '../Toasters/Toaster.dart';
import '../Utils/AdreessFormat.dart';
import '../Utils/ScaffoldMessageSnacber.dart';

class OtherTab extends StatefulWidget {
  final String mobileNumber;

  final String username;
  final String? fullAddressself;
  final AddressModel? addressmodal;
  final String? address;
  final Patient? patient; // Variable to store the desired address
  final bool isLocation;

  const OtherTab({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.fullAddressself,
    required this.address,
    required this.isLocation,
    this.addressmodal,
    this.patient,
  });

  @override
  _OtherTabState createState() => _OtherTabState();
}

class _OtherTabState extends State<OtherTab> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? _formattedAddress;
  // String? gender = "Male";
  final _formKey = GlobalKey<FormState>(); // Form key to validate
  String? relation;
  AddressModel? savedselectedAddress;
  final phoneNumberController = TextEditingController();

  String selectedOption = "Home Service"; // Default selected option
  String? selectedClinic;
  String homeService = "Home Service";
  String clinicVisit = "Clinic Visit";
  int? Cliniclength;
  List<String> relationships = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Son',
    'Daughter',
    'Grandfather',
    'Grandmother',
    'Uncle',
    'Aunt',
    'Husband',
    'Wife',
    'Friend',
    'Cousin',
    'Nephew'
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // savedselectedAddress = widget.address;
  }

  PhoneContact? _selectedContact;
  Future<void> _pickPhoneContact() async {

    try {
      // Request permission to access contacts if not granted already
      PermissionStatus permissionStatus = await Permission.contacts.status;
      if (permissionStatus != PermissionStatus.granted) {
        permissionStatus = await Permission.contacts.request();
        if (permissionStatus != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Contact permissions denied"),
                       
                      ),
        );
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
          phoneNumberController.text = contact.phoneNumber!.number!;
        });
      } else {
        ScaffoldMessageSnackbar.show(
    context: context,
    message: "No phone bumber found in contact",
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey, // Wrapping the form with a key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              DropdownButtonFormField<String>(
                value: relation,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  border: OutlineInputBorder(),
                ),
                items: relationships
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        )))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    relation = value;
                  });
                },
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a Relationship';
                  }
                  return null; // No error
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a valid full name"; // Check if the value is empty
                  } else if (value.length > 30) {
                    return "Name should not exceed 30 characters"; // Check if the name exceeds 20 characters
                  }
                  return null; // No error
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
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
                      height:
                          8.0), // Spacing between the label and the container

                  // Container with address and actions
                  Container(
                    // Fixed height for the container
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
                            widget.isLocation
                                ? (savedselectedAddress?.toString() ??
                                    (widget.fullAddressself ??
                                        _formattedAddress ??
                                        "No Address"))
                                : widget.fullAddressself ??
                                    "Address not available", // Show only _formattedAddress if isLocation is false
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
                                      'isLocation': false
                                    },
                                  );

                                  if (result != null &&
                                      result is AddressModel) {
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
              // DropdownButtonFormField<String>(
              //   value: gender,
              //   decoration: const InputDecoration(
              //     labelText: 'Gender',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: ['Male', 'Female']
              //       .map((e) => DropdownMenuItem(
              //           value: e,
              //           child: Text(
              //             e,
              //             style: const TextStyle(fontWeight: FontWeight.normal),
              //           )))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       gender = value;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Please select a gender';
              //     }
              //     return null; // No error
              //   },
              // ),
              // const SizedBox(height: 25),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return "Field should not be empty";
                  } else if (!GetUtils.isNumericOnly(value)) {
                    return "Enter a numeric value";
                  } else if (value == '0') {
                    return "Age cannot be 0";
                  } else if (int.tryParse(value)! > 99) {
                    return "Enter a valid age (1-99)";
                  }
                  return null; // No error
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: widget.patient?.email != null
                    ? TextEditingController(text: widget.patient?.email)
                    : emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUnfocus,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: phoneNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(
                      10), // Limit input to 10 digits
                ],
                decoration: InputDecoration(
                  labelText: 'Patient Mobile Number (Optional)',
                  labelStyle: const TextStyle(fontSize: 15.0),
                  border: const OutlineInputBorder(),
                  // Phone icon
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.contacts), // Phonebook icon
                    // onPressed: _openPhoneBook, // Open phonebook on click
                    onPressed: _pickPhoneContact, // Open phonebook on click
                  ), // Phone icon
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 5.0),
              Center(
                child: Text(
                  "If no phone number is given, we'll use this number to get in touch with you: ${widget.mobileNumber}.",
                  style:
                      const TextStyle(color: Color.fromARGB(255, 173, 86, 4)),
                ),
              ),
              const SizedBox(height: 25.0),
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
                        fontSize:
                            16, // Increased font size for better visibility
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
                                  : Colors.grey
                                      .shade300, // Default unselected color
                              foregroundColor: selectedOption == homeService
                                  ? Colors
                                      .white // Text color for selected button
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
                                clinicSelectionPage.showClinicBottomSheet(
                                    context, (selectedClinic) {
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
                                  : Colors.grey
                                      .shade300, // Default unselected color
                              foregroundColor: selectedOption == clinicVisit
                                  ? Colors
                                      .white // Text color for selected button
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Validate the form before navigating
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectDateTimeScreen(
                        mobileNumber: widget.mobileNumber,
                        patientname: nameController.text,
                        patientNumber: phoneNumberController.text.isNotEmpty
                            ? phoneNumberController.text
                            : widget.mobileNumber,
                        age: int.tryParse(ageController.text) ?? 0,
                        email: emailController.text,
                        formattedAddress:
                            formattedAddress, // Use _formattedAddress if neither is available
                        username: widget.username,
                        relation: relation,
                        addressmodal: selectedAddressModel,
                      ),
                    ),
                  );
                } else {
                  // If form is not valid, show an error message
                  ScaffoldMessageSnackbar.show(
    context: context,
    message: "Please fill out all fields correctly",
    type: SnackbarType.error,
  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
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
