import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Booings/BooingService.dart';
import '../BottomNavigation/Appoinments/AppointmentView.dart';
import '../BottomNavigation/Appoinments/GetAppointmentModel.dart';
import '../BottomNavigation/Appoinments/PostBooingModel.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import '../Doctors/ListOfDoctors/DoctorService.dart';
import '../Doctors/RatingAndFeedback/RatingModal.dart';
import '../Doctors/RatingAndFeedback/RatingService.dart';
import '../Review/ReviewScreen.dart';
import 'GradintColor.dart';

class AppointmentCard extends StatefulWidget {
  final Getappointmentmodel doctorData;
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
    _fetchHospitaAndDoctorData();
    _fetchRating(); // Call rating fetch here
  }
  // Ensure you import your model

  RatingSummary? ratingSummary;
  bool hasReviewed = false;

  Future<void> _fetchRating() async {
    try {
      final summary = await fetchRatingSummary(
        widget.doctorData.clinicId,
        widget.doctorData.doctorId,
      );

      setState(() {
        ratingSummary = summary;
        hasReviewed = summary.comments.any((e) => e.rated == true);
      });
    } catch (e) {
      print("Rating fetch error: $e");
      setState(() {
        hasReviewed = false;
      });
    }
  }

  Future<void> _fetchHospitaAndDoctorData() async {
    print(">> _fetchHospitaAndDoctorData called");

    try {
      // Move these inside try to catch errors if null or empty

      final hospitalId = widget.doctorData.clinicId;

      print("hospitalIdfgdfgf: ${widget.doctorData.clinicId}");
      print("doctorDatadoctorId: ${widget.doctorData.doctorId}");

      final doctorJson = await doctorService.fetchDoctorByDoctorId(
        widget.doctorData.doctorId,
      );

      final clinicJson = await doctorService.fetchclinicByClinicId(
        hospitalId,
      );

      if (doctorJson != null && clinicJson != null) {
        final result = HospitalDoctorModel.fromJson(doctorJson, clinicJson);
        setState(() {
          doctor = result;
          isLoading = false;
        });
      } else {
        setState(() {
          doctor = null;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        doctor = null;
        isLoading = false;
      });
      print("Exception occurred: $e");
      print("StackTrace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (doctor == null) {
      // Fallback if no data yet
      return const SizedBox(
        height: 100,
        child: Center(child: Text("No doctor data found")),
      );
    }

    final d = doctor!;
    final data = widget.doctorData;

    return InkWell(
      onTap: () {
        print("dfhjdsfkhdsjkfhdshfjd");
        Get.to(AppointmentPreview(
          doctor: doctor!,
          doctorBookings: widget.doctorData,
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        child: Container(
          height: 100, // Fixed height
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Hospital name + city, doctor name
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d?.hospital?.name ?? 'Unknown Hospital',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blueGrey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      d?.hospital?.city ?? 'Unknown City',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      capitalizeEachWord(
                          data?.name ?? 'Patient Name'), // Patient Name Display
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.blueGrey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Middle: Date & time stacked vertically
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        data?.serviceDate ?? '--/--/----',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        data?.servicetime ?? '--:--',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 10),

              // Right: Status badges (compact) and Consultation type (bottom-right)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // If consultation type is 'Online' or 'Video', show Join button
                  if ((data.consultationType.toLowerCase() ==
                              'online consultation' ||
                          data.consultationType.toLowerCase() ==
                              'video consultation') &&
                      data.status.toLowerCase() == 'confirmed')
                    ElevatedButton(
                      onPressed: () {
                        // Replace with actual joining logic (URL, room ID, etc.)
                        print('Joining ${data.consultationType} consultation');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      child: const Text(
                        'Join',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  // Status badges based on appointment status
                  ..._buildStatusBadges((data.status).toLowerCase()),

                  // Only show consultation type if the "Join" button is not shown
                  if (!((data.consultationType.toLowerCase() ==
                              'online consultation' ||
                          data.consultationType.toLowerCase() ==
                              'video consultation') &&
                      data.status.toLowerCase() == 'confirmed'))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.consultationType ?? 'Consultation',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  List<Widget> _buildStatusBadges(String status) {
    switch (status) {
      case 'pending':
        return [_statusBadge("Pending", Colors.amber)];
      case 'confirmed':
        return [_statusBadge("Confirmed", Colors.green)];
      case 'in_progress':
        return [_statusBadge("In Progress", Colors.blue)];
      case 'rejected':
        return [_statusBadge("Rejected", Colors.red)];
      case 'completed':
        return [_statusBadge("Completed", Colors.grey)];
      default:
        return [_statusBadge("Unknown", Colors.black54)];
    }
  }
}
