import 'package:flutter/material.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/PostBooingModel.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:get/get.dart';
import '../../Doctors/DoctorDetails/DoctorDetailsScreen.dart';
import '../../Doctors/ListOfDoctors/DoctorModel.dart';

class AppointmentPreview extends StatefulWidget {
  final HospitalDoctorModel doctor;
  final PostBookingModel doctorBookings;

  const AppointmentPreview({
    Key? key,
    required this.doctor,
    required this.doctorBookings,
  }) : super(key: key);

  @override
  State<AppointmentPreview> createState() => _AppointmentPreviewState();
}

class _AppointmentPreviewState extends State<AppointmentPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final patient = widget.doctorBookings.patient;
    final booking = widget.doctorBookings.booking;
    final doctor = widget.doctor;

    return Scaffold(
      appBar: CommonHeader(
        title: "Booking ID: #${booking.serviceId}",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _sectionCard(
              icon: Icons.local_hospital_outlined,
              title: "Hospital Details",
              children: [
                _infoRow("Hospital", doctor.hospital.name),
                _infoRow("Location", doctor.hospital.address),
                _infoRow("Contact", doctor.hospital.contactNumber),
              ],
            ),
            _sectionCard(
              icon: Icons.person_outline,
              title: "Doctor Details",
              children: [
                _infoRow("Name", doctor.doctor.name),
                _infoRow("Specialization", doctor.doctor.specialization),
                _infoRow(
                    "Experience", "${doctor.doctor.experienceYears} years"),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Get.to(DoctorDetailScreen(doctorData: doctor));
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text("About Doctor"),
                  ),
                )
              ],
            ),
            _sectionCard(
              icon: Icons.account_circle_outlined,
              title: "Patient Details",
              children: [
                _infoRow("Name", patient.name),
                _infoRow("Age", patient.age),
                _infoRow("Gender", patient.gender),
                _infoRow("Booking For", patient.bookingFor),
                _infoRow("Problem", patient.problem),
                _infoRow("Date", patient.monthYear),
                _infoRow("Time", patient.servicetime),
              ],
            ),
            _sectionCard(
              icon: Icons.payment_outlined,
              title: "Payment Details",
              children: [
                _infoRow("Service", booking.servicename),
                _infoRow("Consultation Type", booking.consultationType),
                _infoRow("Consultation Fee", "₹${booking.consultattionFee}"),
                _infoRow("Total Fee", "₹${booking.totalFee}"),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(thickness: 1.2, height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
