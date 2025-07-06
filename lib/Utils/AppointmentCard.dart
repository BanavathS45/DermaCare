import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Review/ReviewScreen.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/RatingBottomSheet.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:cutomer_app/VideoCalling/VideoCalling.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../BottomNavigation/Appoinments/AppointmentView.dart';
import '../BottomNavigation/Appoinments/GetAppointmentModel.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import '../Doctors/ListOfDoctors/DoctorService.dart';
import '../Doctors/RatingAndFeedback/RatingAndFeedbackScreen.dart';
import '../Doctors/RatingAndFeedback/RatingModal.dart';
import '../Doctors/RatingAndFeedback/RatingService.dart';

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
      return const Center(
        child: SizedBox(
          height: 20, // You can adjust height and width as needed
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
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
//Ratingandfeedbackscreen

        Get.to(AppointmentPreview(
          doctor: doctor!,
          doctorBookings: widget.doctorData,
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 0,
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// LEFT SIDE (Hospital, City, Patient Name, Consultation Type)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      d.hospital.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: Colors.blueGrey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      d.hospital.city,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      capitalizeEachWord(data.name),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.blueGrey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        data.consultationType,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// RIGHT SIDE (Date, Time, Status)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        data.serviceDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
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
                        data.servicetime,
                        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  // Example: Confirmed, Cancelled
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: (widget.doctorData.status.toLowerCase() !=
                                'completed' &&
                            widget.doctorData.consultationType.toLowerCase() !=
                                'online consultation')
                        ? _buildStatusBadges(
                            widget.doctorData.status.toLowerCase())
                        : [], // Empty list when status is 'confirmed' or 'completed'
                  ),

                  Row(
                    children: [
                      // This returns List<Widget>
                      if (widget.doctorData.status.toLowerCase() ==
                          'completed') ...[
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            // color: Colors.green, // Set the background color
                            borderRadius: BorderRadius.circular(
                                8), // Set the border radius
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
                          height: 35,
                          decoration: BoxDecoration(
                            color: hasReviewed ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: TextButton(
                            onPressed: hasReviewed
                                ? null
                                : () {
                                    Get.to(ReviewScreen(
                                      doctorData: doctor,
                                      doctorBookings: widget.doctorData,
                                    ));
                                  },
                            child: Text(
                              hasReviewed ? 'Reviewed' : 'Review',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
// Add some space between the buttons
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (widget.doctorData.status.toLowerCase() == 'confirmed' &&
                      (widget.doctorData.consultationType.toLowerCase() ==
                              'video consultation' ||
                          widget.doctorData.consultationType.toLowerCase() ==
                              'online consultation')) ...[
                    Container(
                      height: 35,
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
                            HomeScreen(
                              // roomId: '987654',
                              roomId: widget.doctorData.channelId!,
                              // username: 'Prashnath',
                              username: widget.doctorData.name,
                            ),
                          );
                        },
                        child: const Text(
                          'JOIN',
                          style: TextStyle(
                            color: mainColor,
                          ), // Set the text color
                        ),
                      ),
                    ),
                  ],
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
