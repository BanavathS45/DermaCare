import 'dart:convert';

import 'package:cutomer_app/BottomNavigation/Appoinments/AppointmentView.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/BookingModal.dart';
import 'package:cutomer_app/Utils/PDFPreview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../APIs/BaseUrl.dart';
import '../../Modals/ProviderModal.dart';
import '../../Services/CustomerService.dart';
import '../../Toasters/Toaster.dart';
import '../../Utils/InvoiceDownload.dart';
import '../../Utils/ScaffoldMessageSnacber.dart';
import '../BottomNavigation.dart';

class ProviderDetails extends StatefulWidget {
  final String status;
  final String serviceId;
  final String appointmentId;
  final String mobileNumber;
  final String userName;
  final AppointmentData appointment;

  const ProviderDetails(
      {Key? key,
      required this.status,
      required this.appointmentId,
      required this.serviceId,
      required this.mobileNumber,
      required this.appointment,
      required this.userName})
      : super(key: key);

  @override
  State<ProviderDetails> createState() => _ProviderDetailsState();
}

class _ProviderDetailsState extends State<ProviderDetails> {
  late Future<ProviderDetailsInfo> providerInfoFuture;
  customerRatingService rating = customerRatingService();
  final double providerRating = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProviderDetails(widget.appointmentId, widget.serviceId);
    print("status*******${widget.status}");
    print("status*******${widget.appointmentId}");
    fetchProviderRating();
  }

  double ratings = 0.0;
  bool isRatingSubmitted = false;
  fetchProviderRating() async {
    try {
      final Map<String, dynamic>? ratingData =
          await rating.fetchRating(widget.serviceId, widget.appointmentId);
      print("Fetched Rating: $ratingData");

      if (ratingData != null) {
        ratings = ratingData['rating'];
        isRatingSubmitted = ratingData['customerRatingCompleted'];

        print('Fetched Rating: $rating');
        print('Customer Rating Completed: $isRatingSubmitted');
      } else {
        print('Failed to fetch rating data.');
      }
    } catch (e) {
      print("Error fetching provider rating: $e");
    }
  }

  Future<ProviderDetailsInfo> fetchProviderDetails(
      String appointmentId, String serviceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/provider-details/$appointmentId/$serviceId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print("jsonResponse for fetchProviderDetails ${jsonResponse}");

      // Parse the response and assign providerRatingCompleted value
      isRatingSubmitted = jsonResponse['providerRatingCompleted'] ?? false;
      // Rating = jsonResponse['providerRatingCompleted'] ?? false;

      // Create ProviderDetailsInfo from the JSON
      ProviderDetailsInfo providerDetailsInfo =
          ProviderDetailsInfo.fromJson(jsonResponse);
      print(
          "providerDetailsInfo qualificationSpecialization:${providerDetailsInfo.qualificationSpecialization}");
      return providerDetailsInfo; // Return the ProviderDetailsInfo object
    } else {
      print("Failed to load provider details");
      throw ('Failed to load provider details');
    }
  }

  final TextEditingController feedbackController = TextEditingController();

  String get feedback => feedbackController.text;

  bool isLoading = false;
  int selectedRating = 1;

  _submitFeedback() async {
    setState(() {
      isLoading = true; // Start loading indicator
    });

    try {
      // Call the customer rating service and parse the response
      final responseData = await rating.sendCustomerRating(
          context,
          widget.appointmentId,
          widget.serviceId,
          selectedRating,
          feedback,
          widget.mobileNumber,
          widget.userName);
      // Decode the JSON response

      setState(() {
        isLoading = false; // Stop loading indicator
        // isRatingSubmitted = responseData['providerRatingCompleted']; // Access parsed JSON
      });

      if (responseData['status'] == 200) {
        // Navigate to the DashboardScreen on success
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => BottomNavController(
              mobileNumber: widget.mobileNumber,
              username: widget.userName,
              index: 0,
            ),
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        // Show an error message if submission failed
        ScaffoldMessageSnackbar.show(
    context: context,
    message: "Failed to submit feedback. Please try again.",
    type: SnackbarType.error,
  );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator
      });

      // Handle error gracefully
      print('Error submitting feedback: $e');
     ScaffoldMessageSnackbar.show(
    context: context,
    message: "Failed to submit feedback. Please try again.",
    type: SnackbarType.error,
  );
    }
  }

  InvoicePage invoicePage = InvoicePage();

  void rateButton(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Provider Rating',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.teal,
                              size: 30.0,
                            ),
                            onPressed: () {
                              setModalState(() {
                                setState(() {
                                  selectedRating = index + 1;
                                });
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Provider Feedback (optional)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: feedbackController,
                        maxLines: 4,
                        maxLength: 250,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Feedback',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 12.0),
                          ),
                          child: isLoading
                              ? const Text(
                                  'Submitting...',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check for "pending" status before fetching provider details
    if (widget.status == "pending") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5FE),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: const Color(0xFF0174A8),
              width: 1.0,
            ),
          ),
          child: Text(
            "We are currently assigning a provider for your appointment. We will notify you once a provider has been assigned.",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF013756),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Fetch provider details if status is not "pending"
    return FutureBuilder<ProviderDetailsInfo>(
      future: fetchProviderDetails(widget.appointmentId, widget.serviceId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No provider details found."));
        }

        String ratingString = ratings.toStringAsFixed(0);
        final providerInfo = snapshot.data!;
        double overallRating =
            double.tryParse(providerInfo.overallRating) ?? 0.0;
        String formattedRating = overallRating.toStringAsFixed(1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Provider Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundImage: MemoryImage(
                                base64Decode(providerInfo.profilePicture))),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                providerInfo.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "$formattedRating / 5.0",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60, // Width of the circle
                              height: 60, // Height of the circle
                              decoration: BoxDecoration(
                                color: Colors.teal, // Background color
                                shape: BoxShape.circle, // Circular shape
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  String phoneNumber =
                                      'tel:${providerInfo.providerMobileNumber}'; // Dynamic number
                                  if (await canLaunchUrl(
                                      Uri.parse(phoneNumber))) {
                                    await launchUrl(Uri.parse(phoneNumber));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Could not launch $phoneNumber"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                                height: 8), // Space between button and label
                            const Text(
                              "Call Now", // Label text
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        InfoTile(
                          icon: Icons.calendar_today,
                          label: "Experience",
                          value: "${providerInfo.yearsOfExperience} year(s)",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Additional Info",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      providerInfo.qualificationSpecialization.isNotEmpty ||
                              providerInfo.courseSpecializations.isNotEmpty
                          ? "${providerInfo.qualificationSpecialization}, ${providerInfo.courseSpecializations}"
                          : "No Additional Information Available", // Alternate text if null or empty
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (widget.status == "COMPLETED")
                      const Divider(height: 32, color: Colors.grey),
                    if (widget.status == "COMPLETED")
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align button to the right
                        children: [
                          Column(
                            children: [
                              Text("Invoice Download".toUpperCase()),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround, // Ensures even spacing
                                children: [
                                  // Preview Button with Background Color
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .blue, // Light blue background color
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: IconButton(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255), // Icon color
                                      icon: Icon(Icons
                                          .remove_red_eye), // Eye icon for preview
                                      tooltip:
                                          'Preview Invoice', // Tooltip for the button
                                      onPressed: () async {
                                        final pdfData =
                                            await invoicePage.generatePdf(
                                          PdfPageFormat.a4,
                                          widget.appointment,
                                        );

                                        // Navigate to the PDF preview screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PdfPreviewScreen(
                                                    pdfDataFuture: pdfData),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Spacing between buttons
                                  SizedBox(width: 20),
                                  // Download Button with Background Color
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .red, // Light red background color
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: IconButton(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255), // Icon color
                                      icon:
                                          Icon(Icons.download), // Download icon
                                      tooltip:
                                          'Download Invoice', // Tooltip for the button
                                      onPressed: () => invoicePage.downloadPdf(
                                        context,
                                        widget.appointment,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: isRatingSubmitted
                                ? null // Disable button if the rating is submitted
                                : () {
                                    rateButton(
                                        context); // Call the submit method
                                  },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: isRatingSubmitted
                                      ? Colors.grey // Disabled color for button
                                      : Colors.teal, // Active color for button
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Rounded corners
                                ),
                                child: isRatingSubmitted
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align items to the start
                                        children: [
                                          const Text(
                                            "Rated", // More descriptive heading
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                                  4), // Add spacing between the heading and the row
                                          Row(children: [
                                            const Icon(
                                              Icons
                                                  .star, // Star icon for the rating
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              ratingString,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ]),
                                        ],
                                      )
                                    : Text(
                                        // Display "Rated" if the button is disabled
                                        "Rate Us", // Display "Rate Us" if the button is active
                                        style: const TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
