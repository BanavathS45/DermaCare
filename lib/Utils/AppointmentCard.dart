import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Booings/BooingService.dart';
import '../BottomNavigation/Appoinments/AppointmentView.dart';
import '../BottomNavigation/Appoinments/PostBooingModel.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import '../Doctors/ListOfDoctors/DoctorService.dart';
import '../Review/ReviewScreen.dart';
import 'GradintColor.dart';

class AppointmentCard extends StatefulWidget {
  final PostBookingModel doctorData;
  const AppointmentCard({super.key, required this.doctorData});

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  final DoctorService doctorService = DoctorService();
  final DoctorController doctorController = Get.put(DoctorController());
  bool isDoctorFetched = false; // Flag to track if doctor data is fetched
  bool isLoading = true;
  HospitalDoctorModel? doctor;

  @override
  void initState() {
    super.initState();

    _fetchDoctor(); // Fetch doctor data only once
  }

  Future<void> _fetchDoctor() async {
    print("dsfdsfsdfdsfdsfdsf calling");

    final result =
        await doctorService.getDoctorById(widget.doctorData.booking.doctorId);

    print("dsfdsfsdfdsfdsfdsf ${result}");
    if (result != null) {
      setState(() {
        doctor = result;
        isLoading = false;
      });
    } else {
      setState(() {
        doctor = null;
        isLoading = false;
      });
      print(
          "Error: doctor not found for ID ${widget.doctorData.booking.doctorId}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || doctor == null) {
      return const Center(child: CircularProgressIndicator());
    }
    var doctorData = doctor!.doctor;
    var hospitalData = doctor!.hospital;
    return InkWell(
      onTap: () {
        print("dfhjdsfkhdsjkfhdshfjd");
        Get.to(AppointmentPreview(
          doctor: doctor!,
          doctorBookings: widget.doctorData,
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // gradient: acrdGradient(),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
            border: Border.all(width: 1, color: Colors.grey)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${hospitalData.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
                fontSize: 18,
              ),
              maxLines: 2,
            ),
            Text(
              "${hospitalData.city}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey[900],
                fontSize: 16,
              ),
              maxLines: 2,
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${capitalizeEachWord(widget.doctorData.patient.name)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                        fontSize: 18,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${widget.doctorData.patient.age} Yrs /",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.doctorData.patient.gender,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date : ${widget.doctorData.patient.monthYear}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Time :  ${widget.doctorData.patient.servicetime}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.doctorData.booking.servicename,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    Text(widget.doctorData.booking.consultationType,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center),
                  ],
                ),
                const SizedBox(width: 6),
                Row(
                  children: widget.doctorData.booking.status.toLowerCase() !=
                          'completed'
                      ? _buildStatusBadges(
                          widget.doctorData.booking.status.toLowerCase())
                      : [], // Return an empty list when status is not 'completed'
                ),
                Row(
                  children: [
                    // This returns List<Widget>
                    if (widget.doctorData.booking.status.toLowerCase() ==
                        'completed') ...[
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          // color: Colors.green, // Set the background color
                          borderRadius:
                              BorderRadius.circular(8), // Set the border radius
                          border: Border.all(
                              color: mainColor,
                              width: 1), // Set the border color and width
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                              AppointmentPreview(
                                doctor: doctor!,
                                doctorBookings: widget.doctorData,
                              ),
                            );
                          },
                          child: const Text(
                            'Details',
                            style: TextStyle(
                                color: mainColor), // Set the text color
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue, // Set the background color
                          borderRadius:
                              BorderRadius.circular(8), // Set the border radius
                          border: Border.all(
                              color: Colors.white,
                              width: 2), // Set the border color and width
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.to(ReviewScreen(
                                doctorData: doctor,
                                doctorBookings: widget.doctorData));
                          },
                          child: const Text(
                            'Review',
                            style: TextStyle(
                                color: Colors.white), // Set the text color
                          ),
                        ),
                      ),
                      // Add some space between the buttons
                    ],
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  List<Widget> _buildStatusBadges(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return [_statusBadge("Pending", Colors.amber)];
      case 'confirmed':
        return [_statusBadge("confirmed", Colors.green)];
      case 'in_progress':
        return [_statusBadge("In Progress", Colors.blue)];
      case 'rejected':
        return [_statusBadge("Rejected", Colors.red)];
      case 'completed':
        return [_statusBadge("Completed", Colors.grey)];
      default:
        return [_statusBadge("Review", Colors.black)];
    }
  }
}
