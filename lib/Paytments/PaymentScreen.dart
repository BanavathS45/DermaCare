import 'dart:convert';

import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../BottomNavigation/BottomNavigation.dart';
import '../Screens/BookingSuccess.dart';
import '../ServiceSumarry/ServiceIDAPI.dart';
import '../ServiceSumarry/ServiceIDDetails.dart';
import '../ServiceSumarry/ServiceIDModal.dart';
import '../Toasters/Toaster.dart';
import '../Utils/ScaffoldMessageSnacber.dart';

class RazorpaySubscription extends StatefulWidget {
  final VoidCallback? onPaymentInitiated;
  final BookingDetails serviceDetails;
  // final double amount;
  // final String mobileNumber;
  // final String patientName;
  // final String address;
  // final List<Map<String, dynamic>> servicesAddedList;
  const RazorpaySubscription({
    super.key,
    required this.onPaymentInitiated,
    required this.serviceDetails,
  });

  @override
  State<RazorpaySubscription> createState() => _RazorpaySubscriptionState();
}

class _RazorpaySubscriptionState extends State<RazorpaySubscription> {
  var _razorpay = Razorpay();
  Map<String, dynamic> options = {};
  bool _isLoading = true; // To manage loading state
  late String? paymentId;
  @override
  void initState() {
    super.initState();
    print("PayAmount to be customer ${widget.serviceDetails.payAmount}");

    // Payment options
    options = {
      'key': 'rzp_test_2z0PiIllMZDHrE',
      'amount': (widget.serviceDetails.payAmount * 100)
          .toStringAsFixed(0), // Amount in paise
      'name': 'SureCare',
      'description': 'Service Charges',
      'prefill': {
        'contact': '7842259803',
        'email': 'prashanthr803@gmail.com',
      },
    };

    // Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Start payment process
    if (widget.onPaymentInitiated != null) {
      widget.onPaymentInitiated!();
      Future.delayed(Duration.zero, () {
        _razorpay.open(options);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Gateway"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(), // Placeholder when loading is false
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _isLoading = false;
    });
   ScaffoldMessageSnackbar.show(
    context: context,
    message: "Payment Successful: ${response.paymentId}",
    type: SnackbarType.success,
  );
    paymentId = response.paymentId;
    print("Payment Successful: ${response.paymentId}");

    try {
      print("[LOG - ${DateTime.now()}] Initializing AddressAPI...");

      final addressAPI = ServiceSummaryApi();

      // Prepare ServiceDetailsSummary object
      BookingDetails serviceDetails = BookingDetails(
        patientName: widget.serviceDetails.patientName,
        relationship: widget.serviceDetails.relationship,
        gender: widget.serviceDetails.gender,
        emailId: widget.serviceDetails.emailId,
        age: widget.serviceDetails.age.toString(), // Age is kept as String
        patientNumber: widget.serviceDetails.patientNumber,
        customerNumber: widget.serviceDetails.customerNumber,
        addressDto: AddressModel(
            houseNo: widget.serviceDetails.addressDto.houseNo.trim(),
            street: widget.serviceDetails.addressDto.street.trim(),
            city: widget.serviceDetails.addressDto.city.trim(),
            state: widget.serviceDetails.addressDto.state.trim(),
            postalCode: widget.serviceDetails.addressDto.postalCode.trim(),
            country: widget.serviceDetails.addressDto.country.trim(),
            apartment: widget.serviceDetails.addressDto.apartment,
            direction: widget.serviceDetails.addressDto.direction,
            latitude: widget.serviceDetails.addressDto.latitude,
            longitude: widget.serviceDetails.addressDto.longitude),
        categoryName: widget.serviceDetails.categoryName,
        totalPrice: widget.serviceDetails.totalPrice,
        totalDiscountAmount: widget.serviceDetails.totalDiscountAmount,
        totalDiscountedAmount: widget.serviceDetails.totalDiscountedAmount,
        totalTax: widget.serviceDetails.totalTax,
        payAmount: widget.serviceDetails.payAmount,
        servicesAdded: widget.serviceDetails.servicesAdded,
      );

      // Log the JSON payload for debugging
      String jsonString = jsonEncode(serviceDetails.toJson());
      print("[LOG - ${DateTime.now()}] JSON Payload: $jsonString");

      // Send API request
      print(
          "[LOG - ${DateTime.now()}] Sending address confirmation request...");
      final response = await addressAPI.fetchServiceDetailsSummary(
        jsonString, // Pass the JSON string
        widget.serviceDetails.customerNumber,
      );

      // Log response details
      print(
          "[LOG - ${DateTime.now()}] Response Status: ${response.statusCode}");
      print(
          "[LOG - ${DateTime.now()}] Response booking Body: ${response.body}");

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (ctx) => SuccessScreen(
                serviceDetails: serviceDetails,
                paymentId: paymentId.toString(),
              ),
            ),
            (route) => false
            // (route) => false,
            );
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
         ScaffoldMessageSnackbar.show(
    context: context,
    message: "Your Appointment Not Booked!",
    type: SnackbarType.error,
  );
          print("[LOG errorResponse- ${errorResponse}");
          print("[LOG - ${DateTime.now()}] Error: ${errorResponse['error']}");
        } catch (e) {
          print("[LOG - ${DateTime.now()}] Error decoding response: $e");
        }
      }
    } catch (e) {
      print("[LOG - ${DateTime.now()}] Error during address confirmation: $e");
    } finally {
      print("[LOG - ${DateTime.now()}] Address confirmation process ended.");
    }
  }

  // // BookingDetails serviceDetails = BookingDetails(

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isLoading = false;
    });

    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      ScaffoldMessageSnackbar.show(
        context: context, // Use the new context from builder
        message: "Payment Cancelled by User",
        type: SnackbarType.warning,
        durationInSeconds: 5,
      );
      // Fluttertoast.showToast(msg: "Payment Cancelled by User");

      Navigator.pop(context);

      // (route) => false,

      print("User cancelled the payment.");
    } else {
      ScaffoldMessageSnackbar.show(
    context: context,
    message: "Payment Failed: ${response.message}",
    type: SnackbarType.error,
  );
      print("Payment Failed: ${response.message}");
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessageSnackbar.show(
      context: context,
      message: "External Wallet Selected: ${response.walletName}",
      type: SnackbarType.success,
    );
    print("External Wallet Selected: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear the Razorpay instance
    super.dispose();
  }
}
