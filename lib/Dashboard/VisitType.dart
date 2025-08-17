import 'package:cutomer_app/BottomNavigation/Appoinments/AppointmentService.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/GetAppointmentModel.dart';
import 'package:cutomer_app/BottomNavigation/BottomNavigation.dart';
import 'package:cutomer_app/Consultations/SymptomsController.dart';
import 'package:cutomer_app/Dashboard/VisitController.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Doctors/Schedules/Schedule.dart';
import 'package:cutomer_app/Services/GetHospiatlsAndDoctorWithSubService.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ScaffoldMessageSnacber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ConfirmBooking/ConsultationPrice.dart';
// ensure this is imported
// <- your schedule screen

class VisitType extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final String consulationType;

  const VisitType({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.consulationType,
  });

  @override
  State<VisitType> createState() => _VisitTypeState();
}

class _VisitTypeState extends State<VisitType> {
  final SymptomsController controller = Get.put(SymptomsController());
  final appointmentService = Get.put(AppointmentService());
  final visitController = Get.put(VisitController());
  List<HospitalDoctorModel> hospitalDoctors = [];
  String selectedType = "";

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
    fetchHospitalDoctor().then((value) {
      setState(() {
        hospitalDoctors = value;
      });
    }).catchError((e) {
      print("Error: $e");
    });
  }

  void _fetchAppointments() async {
    try {
      final appointments =
          await appointmentService.fetchAppointments(widget.mobileNumber);
      visitController.setBookings(appointments);
    } catch (e) {
      print("❌ Error fetching appointments: $e");
    }
  }

  void _handleFirstTime() {
    // Navigate to BottomNavController directly
    Get.offAll(() => BottomNavController(
          mobileNumber: widget.mobileNumber,
          username: widget.username,
          index: 0,
        ));
  }

  void _handleFollowUp() {
    final appointments = visitController.bookings;
    if (appointments.isEmpty) {
      Get.snackbar("No Appointments", "You don’t have any past bookings");
      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Text(
              "Select Your Follow-Up Appointment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Flexible(
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: visitController.bookings.length,
                  itemBuilder: (_, index) {
                    final Getappointmentmodel appt =
                        visitController.bookings[index];

                    // find matching hospital doctor for this appointment
                    final HospitalDoctorModel? selectedHospitalDoctor =
                        hospitalDoctors.firstWhereOrNull(
                      (doc) => doc.doctor.doctorId == appt.doctorId,
                    );

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // left side: details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appt.name ?? "Unknown Patient",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Relation: ${appt.relation ?? "NA"}"),
                                  Text(
                                      "Clinic: ${selectedHospitalDoctor?.hospital.name} " ??
                                          "Apollo Clinic"),
                                  Text("Doctor: Dr. Haanvika"),
                                  Text(
                                    "Last Consultation: ${appt.serviceDate ?? "-"} ${appt.servicetime ?? "-"}",
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // right side: follow-up info + "Select"
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Free Follow-Ups\n2",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();

                                    if (selectedHospitalDoctor != null &&
                                        selectedHospitalDoctor
                                            .doctor.doctorAvailabilityStatus) {
                                      Get.to(() => ScheduleScreen(
                                            mobileNumber: widget.mobileNumber,
                                            username: widget.username,
                                            doctorData: selectedHospitalDoctor,
                                          ));
                                      controller.updateVisitType(selectedType);
                                    } else {
                                      ScaffoldMessageSnackbar.show(
                                          context: context,
                                          message: "Doctor not Available Now",
                                          type: SnackbarType.warning);
                                    }
                                  },
                                  child: const Text(
                                    "Select",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Visit Type"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text("First Time"),
              selected: selectedType == "First Time",
              onSelected: (selected) {
                setState(() => selectedType = "First Time");
                _handleFirstTime();
              },
            ),
            const SizedBox(height: 20),
            ChoiceChip(
              label: const Text("Follow Up"),
              selected: selectedType == "Follow Up",
              onSelected: (selected) {
                setState(() => selectedType = "Follow Up");
                _handleFollowUp();
              },
            ),
          ],
        ),
      ),
    );
  }
}
