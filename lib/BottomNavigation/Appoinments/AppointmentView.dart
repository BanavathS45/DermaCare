import 'dart:convert';

import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/MapOnGoogle.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/PostBooingModel.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:get/get.dart';
import '../../Doctors/DoctorDetails/DoctorDetailsController.dart';
import '../../Doctors/DoctorDetails/DoctorDetailsScreen.dart';

import '../../Reports/ReportsDownload.dart';
import '../../Utils/GradintColor.dart';
import 'GetAppointmentModel.dart';

class AppointmentPreview extends StatefulWidget {
  final HospitalDoctorModel doctor;
  final Getappointmentmodel doctorBookings;

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
  Doctordetailscontroller doctordetailscontroller = Doctordetailscontroller();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final patient = widget.doctorBookings;

    final doctor = widget.doctor;
    String base64String = doctor.doctor.doctorPicture;
    final regex = RegExp(r'data:image/[^;]+;base64,');
    base64String = base64String.replaceAll(regex, '');

// Remove the prefix if present
    final prefix = 'data:image/jpeg;base64,';
    if (base64String.startsWith(prefix)) {
      base64String = base64String.substring(prefix.length);
    }
    final isCompletedStatus = patient.status.toLowerCase() == 'completed';
    // final hasReports = patient.reports != null && patient.reports!.isNotEmpty;
    return Scaffold(
      appBar: CommonHeader(
        title: "Booking ID: #${patient.bookingId}",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            patient.status.toLowerCase() == "rejected"
                ? Card(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Resone For Reject",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   "${patient} ",
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 20,
            ),
            _sectionCard(
              icon: Icons.local_hospital_outlined,
              children: [
                _infoRow("Hospital", doctor.hospital.name),
                _infoRow("Location", doctor.hospital.address),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child:
                            _infoRow("Contact", doctor.hospital.contactNumber)),
                    IconButton(
                      onPressed: () {
                        String address =
                            "${doctor.hospital.name}, ${doctor.hospital.address}";
                        MapUtils.openMapByAddress(address);
                      },
                      icon: CircleAvatar(
                        child: Icon(
                          Icons.navigation,
                          color: mainColor,
                        ),
                      ), // Correct here
                    ),
                  ],
                ),
              ],
              title: 'Hospital Details',
            ),
            if (widget.doctorBookings.status.toLowerCase() == "confirmed" ||
                widget.doctorBookings.status.toLowerCase() == "completed" ||
                widget.doctorBookings.status.toLowerCase() == "in_progress")
              _sectionCard(
                icon: Icons.person_outline,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Image
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: doctor.doctor.doctorPicture.isNotEmpty
                            ? MemoryImage(base64Decode(base64String))
                            : const AssetImage('assets/placeholder.png')
                                as ImageProvider,
                      ),
                      const SizedBox(
                          width: 16), // spacing between image and details
                      // Doctor Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.doctor.doctorName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor.doctor.specialization,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${doctor.doctor.experience} years Experience",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // spacing before the button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Get.to(DoctorDetailScreen(doctorData: doctor));
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text("About Doctor"),
                    ),
                  ),
                ],
                title: "Doctor Details",
              ),

            _sectionCard(
              icon: Icons.account_circle_outlined,
              title: "Patient Details",
              children: [
                _infoRow("Name", patient.name),
                _infoRow("Age", patient.age.toString()), // ✅ Now it's a String

                _infoRow("Gender", patient.gender),
                _infoRow("Booking For", patient.bookingFor),
                _infoRow("Problem", patient.problem),
                _infoRow("Date", patient.serviceDate),
                _infoRow("Time", patient.servicetime),
                // _infoRow(
                //     "Patient Notes",
                //     (patient.notes!.isNotEmpty
                //         ? patient.notes!
                //         : "No Patient Notes Provide")),
              ],
            ),
            _sectionCard(
              icon: Icons.payment_outlined,
              title: "Payment Details",
              children: [
                _infoRow("Service", patient.subServiceName),
                _infoRow("Consultation Type", patient.consultationType),
                _infoRow("Consultation Fee", "₹${patient.consultationFee}"),
                _infoRow("Total Fee", "₹${patient.totalFee}"),
              ],
            ),
            const SizedBox(height: 10),
            // isCompletedStatus && hasReports
            //     ? Container(
            //         width: 200,
            //         decoration: BoxDecoration(
            //           gradient: appGradient(),
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: ElevatedButton(
            //           onPressed: () async {
            //             final reports = widget.doctorBookings.patient.reports;
            //             print("dshfjkshdfhkd${reports}");
            //             if (reports != null && reports.isNotEmpty) {
            //               showReportDownloadSheet(context, reports);
            //             } else {
            //               showSnackbar("Error", "No report found.", "error");
            //             }
            //           },
            //           style: ElevatedButton.styleFrom(
            //             elevation: 0,
            //             backgroundColor: Colors.transparent,
            //             shadowColor: Colors.transparent,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //           ),
            //           child: Text(
            //             "Download Reports",
            //             style: const TextStyle(fontSize: 18),
            //           ),
            //         ),
            //       )
            //     : const SizedBox.shrink(),
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
