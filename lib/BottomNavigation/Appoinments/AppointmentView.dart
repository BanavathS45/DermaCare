import 'package:cutomer_app/Utils/CopyRigths.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../APIs/BaseUrl.dart';
import '../../Utils/AdreessFormat.dart';
import '../../Utils/Constant.dart';
import '../../Utils/DateConverter.dart';
import '../../Utils/InvoiceDownload.dart';
import '../BottomNavigation.dart';
import 'BookingModal.dart'; // Assuming BookingModal.dart defines the Appointment model
import 'package:http/http.dart' as http;

import 'ProviderDetails.dart';

// Appointment Preview Widget
class AppointmentPreview extends StatefulWidget {
  final AppointmentData appointment;

  AppointmentPreview({required this.appointment});

  @override
  State<AppointmentPreview> createState() => _AppointmentPreviewState();
}

class _AppointmentPreviewState extends State<AppointmentPreview>
    with AutomaticKeepAliveClientMixin {
  String otp = '';
  @override
  void initState() {
    super.initState();
    // Prioritize showing `startPin` if available; otherwise, show `endPin`
    otp = (widget.appointment.servicesAdded.isNotEmpty
        ? (widget.appointment.servicesAdded.first.startPin != null &&
                widget.appointment.servicesAdded.first.endPin == null
            ? widget.appointment.servicesAdded.first.startPin
            : widget.appointment.servicesAdded.first.endPin ?? "****")
        : "****")!;

    // Calculate totals (presumably for tax and final cost)
    _calculateTotals();
  }

  double subtotal = 0.0; // Total amount before discounts
  double totalDiscount = 0.0; // Total discount amount
  double discountedTotal = 0.0; // Total after applying discount
  double grandTotal = 0.0; // Final amount (after discount + tax)
  double taxRate = 0.18;
  double totalPrice = 0.0;
  double totalTax = 0.0;

  // Function to calculate totals (called once during initialization)
  void _calculateTotals() {
    // Iterate through each service in the servicesAdded list
    for (var service in widget.appointment.servicesAdded) {
      var basePrice = service.price *
          widget.appointment.servicesAdded.first
              .numberOfDays; // Price before discount
      var discountAmount =
          basePrice * (service.discount / 100); // Calculate discount
      var discountedPrice = basePrice - discountAmount; // Price after discount

      // Calculate tax on discounted price
      var tax = discountedPrice * taxRate;

      // Final amount after tax
      var finalPrice = discountedPrice + tax;

      // Add values to the totals
      subtotal += basePrice; // Add base price to subtotal
      totalDiscount += discountAmount; // Add discount amount
      discountedTotal += discountedPrice; // Add discounted price
      totalTax += tax; // Add tax to total tax
      grandTotal += finalPrice; // Calculate final total
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text("BookingID#${widget.appointment.bookServiceId}"),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking ID #${widget.appointment.appointmentId}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              // "sdhjkdsf,",
              formatDateTime(widget.appointment.bookedAt),
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderDetails(
                status: widget.appointment.servicesAdded.first.status,
                appointmentId: widget.appointment.appointmentId,
                serviceId: widget.appointment.servicesAdded.first.serviceId,
                mobileNumber: widget.appointment.customerNumber,
                userName: widget.appointment.patientName,
                appointment: widget.appointment),

            const SizedBox(height: 20),

            (widget.appointment.servicesAdded.first.status == "accepted" &&
                        widget.appointment.servicesAdded.first.startPin !=
                            null ||
                    widget.appointment.servicesAdded.first.status ==
                            "IN_PROGRESS" &&
                        widget.appointment.servicesAdded.first.startPin != null)
                ? Card(
                    color: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (widget.appointment.servicesAdded.first
                                                .startPin !=
                                            null &&
                                        widget.appointment.servicesAdded.first
                                                .endPin ==
                                            null)
                                    ? "Start Pin"
                                    : (widget.appointment.servicesAdded.first
                                                    .endPin !=
                                                null &&
                                            widget.appointment.servicesAdded
                                                    .first.startPin !=
                                                null)
                                        ? "End Pin"
                                        : "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: otp.split('').map((digit) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.teal,
                                    ),
                                    child: Text(
                                      digit,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.security,
                            color: Colors.white,
                            size: 36,
                          ),
                        ],
                      ),
                    ),
                  )
                :
                // Empty widget when condition is not met

                const SizedBox(height: 20),
            const Text(
              "Appointment Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 30),
            _buildDetailRow(
              icon: Icons.phone,
              title:
                  "${widget.appointment.patientName}, ${widget.appointment.patientNumber}",
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.location_on,
              title: formataddress(widget.appointment.addressDto),
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.calendar_today,
              title:
                  "${widget.appointment.servicesAdded.first.startDate.toString()} To ${widget.appointment.servicesAdded.first.endDate.toString()} (${widget.appointment.servicesAdded.first.numberOfDays}day/'s)",
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.access_time,
              title:
                  "${widget.appointment.servicesAdded.first.startTime} to ${widget.appointment.servicesAdded.first.endTime} (${widget.appointment.servicesAdded.first.numberOfHours})",
            ),

            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.bookmark,
                  color: Colors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Amount Paid: ", // Normal text before price
                      children: [
                        TextSpan(
                          text:
                              "₹${widget.appointment.servicesAdded.first.finalCost.toStringAsFixed(0)}", // Bold price
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              " (Including Tax and Discount )", // Normal text after price
                        ),
                      ],
                    ),
                    style: const TextStyle(
                        fontSize: 14), // You can also add a default style here
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "Booked Services",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Assuming this is part of your widget's build method

            Column(
              children: widget.appointment.servicesAdded
                  .map(
                    (service) => _buildServiceRow(
                      serviceName: service.serviceName,
                      price: service.finalCost.toStringAsFixed(
                          0), // Two decimal points for better formatting
                    ),
                  )
                  .toList(),
            ),

            // Row to display total tax
            const SizedBox(height: 20),
            const Text(
              "Invoice Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal", style: TextStyle(fontSize: 14)),
                    Text(
                        "₹${widget.appointment.servicesAdded.first.price.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Discount Amount",
                        style: TextStyle(fontSize: 14)),
                    Text(
                        "- ₹ ${widget.appointment.servicesAdded.first.discountAmount.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Discounted Total",
                        style: TextStyle(fontSize: 14)),
                    Text(
                        "₹${widget.appointment.servicesAdded.first.discountedCost.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Taxes & Charges",
                        style: TextStyle(fontSize: 14)),
                    Text(
                        "₹${widget.appointment.servicesAdded.first.taxAmount.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Grand Total",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(
                        "₹${widget.appointment.servicesAdded.first.finalCost.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reschedule Button (when status is pending)
                // widget.appointment.servicesAdded.first.status == "pending" ||
                //         widget.appointment.servicesAdded.first.status ==
                //             "accepted"
                //     ? Expanded(
                //         child: OutlinedButton(
                //           onPressed: () {
                //             // Your action for the Reschedule button
                //           },
                //           style: OutlinedButton.styleFrom(
                //             backgroundColor: Color(0xFF6A5B94),
                //             foregroundColor: Colors.white,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //           ),
                //           child: Text(
                //             "Reschedule".toUpperCase(),
                //             textAlign: TextAlign.center, // Center the text
                //           ),
                //         ),
                //       )
                //     : SizedBox.shrink(), // Placeholder when no button is shown

                // Spacer between buttons
                // SizedBox(width: 10),

                // Cancel Booking Button (when status is pending)
                if (widget.appointment.servicesAdded.first.status
                            .toLowerCase() ==
                        "pending" ||
                    widget.appointment.servicesAdded.first.status
                            .toLowerCase() ==
                        "accepted")
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (widget.appointment.servicesAdded.first.status
                                .toLowerCase() ==
                            'accepted') {
                          _showCancelPopup(context);
                        } else {
                          showConfirmationBottomDialog(context,
                              title: "Cancel Booking",
                              button1Text: 'NO',
                              button1Action: () {},
                              button2Text: 'YES', button2Action: () {
                            _cancelBooking(
                                context,
                                widget.appointment.appointmentId,
                                widget.appointment.patientName,
                                widget.appointment.customerNumber,
                                widget
                                    .appointment.servicesAdded.first.serviceId);
                          },
                              content:
                                  'Are you sure you want to cancel this booking? \n BookingID:${widget.appointment.appointmentId}');
                          // Handle reschedule action
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel Booking".toUpperCase(),
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ),
                  )
                else
                  const SizedBox
                      .shrink(), // Placeholder when no button is shown
              ],
            ),

            const Divider(),
            const SizedBox(height: 16),
            if (widget.appointment.servicesAdded.first.status != 'COMPLETED' &&
                widget.appointment.servicesAdded.first.status != 'IN_PROGRESS')
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cancellation Policy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Free cancellations till 2 mins after placing the booking or if a professional is not assigned. A fee will be charged otherwise.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar:
          const BottomAppBar(color: Color.fromARGB(255, 255, 255, 255), child: Copyrights()),
    );
  }

  @override
  bool get wantKeepAlive => false;

  Widget _buildDetailRow(
      {required IconData icon, required String title, Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[700], size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildServiceRow(
      {required String serviceName, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(serviceName, style: const TextStyle(fontSize: 14)),
          Text("₹$price", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const InfoTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Execute the tap callback
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.teal),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}

void showConfirmationBottomDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String button1Text,
  required VoidCallback button1Action,
  required String button2Text,
  required VoidCallback button2Action,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent, // Makes the background transparent
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Content/Message
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel Button

                // Confirm Button
                Container(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: button2Action,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5B94), // Button color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      button2Text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 120,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                      button1Action(); // Action for the first button
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color.fromARGB(255, 206, 42, 31),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      button1Text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _showCancelPopup(BuildContext context) {
  showConfirmationBottomDialog(
    context,
    title: "Cancel Booking",
    content:
        "Are you sure you want to cancel this booking? Cancelling may incur charges.",
    button1Text: "CANCEL",
    button1Action: () {
      // Handle cancel action
      print("User canceled the booking cancellation.");
    },
    button2Text: "PAY",
    button2Action: () {},
  );
}

Future<void> _cancelBooking(BuildContext context, String appointmentId,
    username, mobilenumber, String serviceId) async {
  _showSuccessDialog(
      context, "The cancellation of your appointment is underway.");
  final String url = '$baseUrl/deleteService/$appointmentId/$serviceId';
  print("cancellation Url $url");
  try {
    // Send DELETE request
    final response = await http.delete(Uri.parse(url));
    print("cancellation statecode ${response.statusCode}");
    print("cancellation body ${response.body}");

    // Close the bottom sheet if it's open
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    if (response.statusCode == 200) {
      // Show success message with a GIF
      // ignore: use_build_context_synchronously
      _showSuccessDialog(context, 'Your appointment has been cancelled.');

      // Navigate to the appointments screen after the success dialog is closed
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (ctx) => BottomNavController(
              mobileNumber: mobilenumber,
              username: username,
              index: 1,
            ),
          ),
          (route) => false,
        );
      });
    } else {
      // Show an error message if deletion failed
      _showErrorDialog(
          // ignore: use_build_context_synchronously
          context,
          'Failed to delete service. Error: ${response.body}');
    }
  } catch (e) {
    // Close the bottom sheet in case of any error
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    // Show an error dialog
    // ignore: use_build_context_synchronously
    _showErrorDialog(context, 'Error occurred: $e');
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the error dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showSuccessDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use Image.network to load the GIF from a URL
            Image.network(
              'https://i.pinimg.com/originals/ff/fa/9b/fffa9b880767231e0d965f4fc8651dc2.gif',
              width: 100, // You can adjust the width of the GIF
              height: 100, // You can adjust the height of the GIF
              fit: BoxFit.cover, // Optionally adjust the box fit
            ),
            const SizedBox(height: 10),
            Text(
              msg,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center the text
            ),
          ],
        ),
      );
    },
  );
}
