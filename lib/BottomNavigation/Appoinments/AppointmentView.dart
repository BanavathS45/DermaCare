import 'package:flutter/material.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/PostBooingModel.dart';
import 'package:cutomer_app/Utils/Header.dart';
import '../../Doctors/ListOfDoctors/DoctorModel.dart';

class AppointmentPreview extends StatefulWidget {
  final HospitalDoctorModel doctor;
  final PostBookingModel doctorBookings;
  const AppointmentPreview(
      {Key? key, required this.doctor, required this.doctorBookings})
      : super(key: key);

  @override
  State<AppointmentPreview> createState() => _AppointmentPreviewState();
}

class _AppointmentPreviewState extends State<AppointmentPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Extracting values for easy access
    final patient = widget.doctorBookings.patient;
    final booking = widget.doctorBookings.booking;
    final doctor = widget.doctor;

    return Scaffold(
      appBar: CommonHeader(
        title: "Booking Id: #${booking.serviceId}",
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Hospital Details Section
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text("Hospital Details",
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hospital: ${doctor.hospital.name}"),
                  Text("Location: ${doctor.hospital.address}"),
                  Text("Contact: ${doctor.hospital.contactNumber}"),
                ],
              ),
            ),
          ),

          // Doctor Details Section
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text("Doctor Details",
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${doctor.doctor.name}"),
                  Text("Specialization: ${doctor..doctor.specialization}"),
                  Text("Experience: ${doctor.doctor.experienceYears} years"),
                ],
              ),
            ),
          ),

          // Patient Details Section
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text("Patient Details",
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${patient.name}"),
                  Text("Age: ${patient.age}"),
                  Text("Gender: ${patient.gender}"),
                  Text("Booking For: ${patient.bookingFor}"),
                  Text("Problem: ${patient.problem}"),
                  Text("Date: ${patient.monthYear}"),
                  Text("Time: ${patient.servicetime}"),
                ],
              ),
            ),
          ),

          // Payment Details Section
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text("Payment Details",
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Service: ${booking.servicename}"),
                  Text("Consultation Type: ${booking.consultationType}"),
                  Text("Consultation Fee: \₹${booking.consultattionFee}"),
                  Text("Total Fee: \₹${booking.totalFee}"),
                ],
              ),
            ),
          ),

          // Add any other sections or widgets here as needed
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
