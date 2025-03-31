import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';

// Appointment Preview Widget
class AppointmentPreview extends StatefulWidget {
  const AppointmentPreview({Key? key}) : super(key: key); // ✅ fixed key

  @override
  State<AppointmentPreview> createState() => _AppointmentPreviewState();
}

class _AppointmentPreviewState extends State<AppointmentPreview>
    with AutomaticKeepAliveClientMixin {
  String otp = '';

  double subtotal = 0.0; // Total amount before discounts
  double totalDiscount = 0.0; // Total discount amount
  double discountedTotal = 0.0; // Total after applying discount
  double grandTotal = 0.0; // Final amount (after discount + tax)
  double taxRate = 0.18;
  double totalPrice = 0.0;
  double totalTax = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: CommonHeader(
      title: "Booking Id #343246873",
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
