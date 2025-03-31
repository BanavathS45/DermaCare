import 'dart:convert';

import 'package:collection/collection.dart';
import 'dart:ui';
import 'package:cutomer_app/Help/Numbers.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Modals/CaluclationModel.dart';
import 'package:cutomer_app/ServiceView/ServiceDetail.dart';
import 'package:cutomer_app/Utils/AdreessFormat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../APIs/BaseUrl.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Controller/CustomerController.dart';
import '../Modals/ServiceModal.dart';
import '../Paytments/PaymentScreen.dart';
import '../TreatmentAndServices/ServiceSelectionScreen.dart';
import '../Services/serviceb.dart';
import '../Toasters/Toaster.dart';
import '../Utils/Header.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Utils/ScaffoldMessageSnacber.dart';
import 'ServiceIDModal.dart';

// ignore: must_be_immutable
class Serviceiddetails extends StatefulWidget {
  //
  final String username;
  final String mobileNumber;
  final List<Map<String, dynamic>> servicesDateAndTime;
  List? selectedServices;
  final String patientNumber;
  final String formattedAddress;
  final String patientName;
  final int age;
  final String email;
  final String gender;
  final String relation;
  final String saveAs;
  final String address;
  final AddressModel? addressModel;
  final List<CaluclationModel> serviceCaluclations;
  final double subTotal;
  final double taxAmount;
  final double discount;
  final double discountedAmount;
  final double payAmount;

  Serviceiddetails({
    super.key,
    required this.username,
    required this.mobileNumber,
    required this.selectedServices,
    required this.formattedAddress,
    required this.patientName,
    required this.age,
    required this.email,
    required this.gender,
    required this.relation,
    required this.saveAs,
    required this.address,
    required this.addressModel,
    required this.patientNumber,
    required this.servicesDateAndTime,
    required this.subTotal,
    required this.serviceCaluclations,
    required this.taxAmount,
    required this.discount,
    required this.discountedAmount,
    required this.payAmount,
  });
  @override
  _ServiceiddetailsState createState() => _ServiceiddetailsState();
}

class _ServiceiddetailsState extends State<Serviceiddetails> {
  late Future<ServiceDetails> serviceDetails;
  List<Serviceb> services = [];
  late List<Map<String, dynamic>>
      serviceNamesAndPrices; // Declare late, but initialize in initState
  final selectedServicesController = Get.find<SelectedServicesController>();
  late String categoryId;
  late String categoryName;

  List<ServiceAdded> servicesAddedList = []; // Declare the list

  @override
  void initState() {
    super.initState();

    print(
        "widget***.serviceCaluclations: ${widget.serviceCaluclations.map((e) => e.numberOfDays).toList()}");
    print("widget2%^.address: ${widget.address}");
    print("subTotal####: ${widget.subTotal}");
    print("widget2%^.addressModel : ${widget.addressModel!.latitude}");
  }

  Future<void> _initializeData() async {
    // serviceNamesAndPrices = widget.serviceCaluclations
    //     .map((service) => {
    //           'serviceId': service.serviceId,
    //           'serviceName': service.serviceName,
    //           'pricing': service.price,
    //           'finalCost': service.finalCost,
    //           'discount': service.discount,
    //           'discountCost': service.discountedCost,
    //           'discountedCost': service.discountedCost,
    //           'discountAmount': service.discountAmount,
    //           'endDate': service.endDate,
    //           'startDate': service.startDate,
    //           'endTime': service.endTime,
    //           'tax': service.tax,
    //           'taxAmount': service.taxAmount,
    //         })
    //     .toList();

    servicesAddedList = widget.serviceCaluclations.mapIndexed((index, service) {
      return ServiceAdded(
          status: 'pending',
          serviceId: service.serviceId,
          serviceName: service.serviceName,
          price: service.price,
          discount: service.discount,
          discountAmount: service.discountAmount,
          discountedCost: service.discountedCost,
          tax: service.tax,
          taxAmount: service.taxAmount,
          finalCost: service.finalCost,
          startDate: service.startDate,
          endDate: service.endDate,
          startTime: service.startTime,
          endTime: service.endTime,
          numberOfDays: service.numberOfDays,
          numberOfHours: service.numberOfHours,
          latitude: widget.addressModel!.latitude,
          longitude: widget.addressModel!.longitude);
    }).toList();

    categoryId = selectedServicesController.categoryId.value;
    categoryName = selectedServicesController.categoryName.value;

    selectedServicesMethod();
  }

  void _saveAddressDetails() async {
    BookingDetails serviceDetails = BookingDetails(
      patientName: widget.patientName,
      relationship: widget.relation,
      gender: widget.gender,
      emailId: widget.email,
      age: widget.age.toString(), // Age is kept as String
      patientNumber: widget.patientNumber,
      customerNumber: widget.mobileNumber,

      addressDto: AddressModel(
          houseNo: widget.addressModel!.houseNo,
          street: widget.addressModel!.street,
          city: widget.addressModel!.city,
          state: widget.addressModel!.state,
          postalCode: widget.addressModel!.postalCode,
          country: widget.addressModel!.country,
          latitude: widget.addressModel!.latitude,
          longitude: widget.addressModel!.longitude,
          apartment: widget.addressModel!.apartment.toString(),
          direction: widget.addressModel!.direction.toString()),

      categoryName: categoryName,
      totalPrice: widget.subTotal,
      totalDiscountAmount: widget.discount,
      totalTax: widget.taxAmount,
      payAmount: widget.payAmount,
      servicesAdded: servicesAddedList,
      totalDiscountedAmount: widget.discountedAmount,
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (ctx) => RazorpaySubscription(
    //       onPaymentInitiated: () {
    //         // Delay snackbar execution until after the widget has been built
    //         WidgetsBinding.instance.addPostFrameCallback((_) {
    //           ScaffoldMessageSnackbar.show(
    //             context: ctx, // Use the new context from builder
    //             message: "Payment process initiated from Previous Screen.",
    //             type: SnackbarType.success,
    //             durationInSeconds: 5,
    //           );
    //         });
    //       },
    //       serviceDetails: serviceDetails,
    //     ),
    //   ),
    // );
  }

  Future<void> fetchUserServices() async {
    try {
      print("Starting API call to fetch services...");

      final response = await http.get(Uri.parse(categoryUrl));
      print("API call completed. Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response data: ${data}");

        // Check if data is a list of maps
        if (data is List) {
          setState(() {
            services = data.map((serviceData) {
              print('categoryId${serviceData['categoryId']}');
              return Serviceb.fromJson({
                'categoryId': serviceData['categoryId'] ?? '',
                'categoryName': serviceData['categoryName'] ?? '',
                'categoryImage':
                    base64Decode(serviceData['categoryImage'] ?? ''),
              });
            }).toList();
          });
          print("Services fetched and updated successfully.");
        } else {
          print(
              "Error: Expected a list of services but got a different format.");
          // Handle this error appropriately
        }
      } else {
        print("API call failed with status: ${response.statusCode}");
        // Handle non-200 status codes
      }
    } catch (e) {
      print("Error fetching services data: $e");
    }
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return "Not available";
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm(); // 12-hour format
    return format.format(dt);
  }

  TimeOfDay? parseTimeOfDay(String timeString) {
    try {
      // Parse the '12:00pm' format
      final dateFormat = DateFormat.jm(); // Handles '12:00pm'
      final dateTime = dateFormat.parse(timeString); // Convert to DateTime
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (e) {
      print('Error parsing time: $e');
      return null; // Return null if parsing fails
    }
  }

  double totalPrice = 0.0; // Final amount after tax

  void selectedServicesMethod() {
    if (widget.selectedServices != null) {
      List<Service> selectedServiceList = widget.selectedServices!
          .where((service) => service is Service && service.quantity > 0)
          .map((service) => service as Service)
          .toList();

      // Use the filtered list
      print(selectedServiceList
          .map((service) => service.categoryName)
          .join(', '));
    } else {
      print('No selected services');
    }
  }

  Future<void> showInDialPad(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // Opens the dial pad with the number
    } else {
      print('Cannot open the dial pad for $phoneNumber');
    }
  }

  Future<void> makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: '7842259803');
    print('Launching: $uri');
    final canLaunch = await canLaunchUrl(uri);
    print('Can launch: $canLaunch');
    if (canLaunch) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Cannot launch $uri');
    }
  }

  void _helpMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Service Summary Help"),
          content: Text(
              "This page provides a summary of the selected service details, including service name, customer details, and total price."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
            TextButton(
              onPressed: () async {
                await customerCare();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.call), // Call icon
                  SizedBox(width: 8),
                  Text("Helpline"), // Button text
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String formatTo12HourTime(dynamic time, BuildContext context) {
    if (time == null || time.toString().isEmpty) return '';

    try {
      if (time is TimeOfDay) {
        // If time is already a TimeOfDay, use its format method
        return time.format(context);
      } else if (time is String) {
        // Trim the string to ensure there are no leading or trailing spaces
        String trimmedTime = time.trim();

        // Parse the string as 24-hour time
        DateTime parsedTime = DateFormat("HH:mm").parse(trimmedTime);

        // Convert to 12-hour format with AM/PM
        return DateFormat("hh:mm a").format(parsedTime);
      } else {
        throw Exception("Invalid time format");
      }
    } catch (e) {
      print("Error formatting time: $e");
      return time.toString(); // Return original time if parsing fails
    }
  }

  void showAlertforBookingCancel(
    String title,
    String content,
    VoidCallback onBookingCancelPressed, // Use VoidCallback here
    String button,
    VoidCallback onAddServicesPressed,
    String AddService,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      onBookingCancelPressed, // Now this matches VoidCallback
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF9D0E04), // Set the background color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners (optional)
                    ),
                  ),
                  child: Text(
                    button,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), // Text color
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      onAddServicesPressed, // Now this matches VoidCallback
                  child: Text(AddService),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: 'Booking Details',
        onHelpPressed: () {
          _helpMessage();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                // Get the instance of SelectedServicesController
                final selectedServicesController =
                    Get.find<SelectedServicesController>();

                // Access the list of selected services
                List<Service> selectedServices =
                    selectedServicesController.selectedServices;

                // Check if the selectedServices list is not empty
                String categoryName = selectedServices.isNotEmpty
                    ? selectedServices[0].categoryName
                    : 'No service selected';

                // Display category information
                return Text.rich(
                  TextSpan(
                    text: 'Service: \n', // Bold part
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C3C7D)),
                    children: <TextSpan>[
                      TextSpan(
                        text: categoryName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF4C3C7D)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 25),
              Text.rich(
                TextSpan(
                  text: 'Address: \n', // Bold part
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C3C7D)),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${widget.patientName.toUpperCase()}\n',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: formatAddressModel(
                          widget.addressModel!), // Normal part
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft, // Align text to the left
                      child: Text(
                        'Services', // Title for the list of services
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C3C7D),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<void>(
                    future: _initializeData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        // Return the ListView.builder here
                        return ListView.builder(
                          shrinkWrap:
                              true, // Ensures ListView takes only necessary space
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevents scrolling inside ListView
                          itemCount: servicesAddedList.length,
                          itemBuilder: (context, index) {
                            final service = servicesAddedList[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Service Name
                                      Text(
                                        service.serviceName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // Price & Number of Days
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.currency_rupee,
                                                  color: Colors.green,
                                                  size: 20),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${service.finalCost.toStringAsFixed(0)}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "(${service.numberOfDays} day(s))",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: Text(
                                              "(Including Tax and Discount)",
                                              style:
                                                  TextStyle(color: Colors.teal),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Date Range
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              color: Colors.blue, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${service.startDate} - ${service.endDate}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Time Range
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              color: Colors.orange, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${service.startTime} - ${service.endTime}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      // Required for blur effect

      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height *
              (0.35), // 30% of screen height

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4C3C7D), // Deep Purple
                Color(0xFF6A5B94), // Dark Indigo
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 15,
                spreadRadius: 3,
                offset: Offset(0, -3), // Creates a floating effect
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Glass effect
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Column(
                      children: [
                        _buildPriceRow("Sub Total",
                            "₹${widget.subTotal.toStringAsFixed(0)}"),
                        _buildPriceRow("Discount Amount",
                            "- ₹${widget.discount.toStringAsFixed(0)}",
                            textColor: Colors.redAccent),
                        _buildPriceRow("Discounted Total",
                            "₹${widget.discountedAmount.toStringAsFixed(0)}"),
                        _buildPriceRow("Taxes & Charges",
                            "₹${widget.taxAmount.toStringAsFixed(0)}"),
                        Divider(color: Colors.white24),
                        _buildPriceRow("Grand Total",
                            "₹${widget.payAmount.toStringAsFixed(0)}",
                            isBold: true),
                      ],
                    ),
                  ),

                  SizedBox(height: 10), // Space before buttons

                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showAlertforBookingCancel(
                              "Cancel Booking",
                              "Are you sure you want to cancel this booking?",
                              () {
                                print("Booking canceled");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => BottomNavController(
                                      mobileNumber: widget.mobileNumber,
                                      username: widget.patientName,
                                      index: 0,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              "Cancel",
                              () {
                                print("Booking canceled");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => SelectServicesPage(
                                      mobileNumber: widget.mobileNumber,
                                      username: widget.patientName,
                                      categoryName: categoryName,
                                      categoryId: categoryId,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              "Add Services",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 5, // Adds depth
                          ),
                          child: Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _saveAddressDetails();
                            print(
                                "Service count: ${widget.selectedServices!.length}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 5, // Adds depth
                          ),
                          child: Text("PAY",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool isBold = false, Color textColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 18,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: textColor),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: textColor),
          ),
        ],
      ),
    );
  }
}
