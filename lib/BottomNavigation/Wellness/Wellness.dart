import 'package:flutter/material.dart';

class WellnessPage extends StatefulWidget {
  @override
  _WellnessPageState createState() => _WellnessPageState();
}

class _WellnessPageState extends State<WellnessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointment Details")),
      body: Center(child: Text("Wellness")),
    );
  }
}
