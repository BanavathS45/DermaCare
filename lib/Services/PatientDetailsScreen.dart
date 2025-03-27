import 'dart:convert';
import 'package:cutomer_app/Modals/AddressModal.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../APIs/BaseUrl.dart';
import '../AddPatient/AddPatientForm.dart';
import '../AddPatient/AddPatientOther.dart';
import '../Modals/SummaryAddress.dart';

class PatientDetailScreen extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final String? fullAddressself;
  final AddressModel? addressmodal;
  final bool isLocation;

  // final List? selectedServices;

  const PatientDetailScreen({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.fullAddressself,
    required this.addressmodal,
    required this.isLocation,
    // required this.selectedServices,
  });

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Patient Details"),
        ),
        body: Center(child: Text("dfdf")));
  }
}
