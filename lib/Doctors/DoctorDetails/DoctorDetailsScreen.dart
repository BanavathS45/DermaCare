import 'dart:convert';

import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:get/get.dart';
import '../../Help/Numbers.dart';
import '../../Utils/MapOnGoogle.dart';
import '../ListOfDoctors/DoctorController.dart';
import '../RatingAndFeedback/RatingController.dart';
import '../RatingAndFeedback/RatingService.dart';
import 'DoctorDetailsController.dart';

import '../RatingAndFeedback/RatingAndFeedback.dart';

class DoctorDetailScreen extends StatelessWidget {
  final HospitalDoctorModel doctorData;

  const DoctorDetailScreen({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    final doctor = doctorData.doctor;
    final hospital = doctorData.hospital;
    Doctordetailscontroller doctordetailscontroller = Doctordetailscontroller();
    final DoctorController doctorController = Get.put(DoctorController());
    return Scaffold(
      appBar: CommonHeader(
        title: "Doctor Information",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟩 CARD CONTAINER
            Container(
              decoration: BoxDecoration(
                gradient: appGradient(),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Row
                  Row(
                    children: [
// ...

                      CircleAvatar(
                        radius: 40,
                        backgroundImage: doctor.doctorPicture.isNotEmpty
                            ? MemoryImage(
                                base64Decode(
                                    doctor.doctorPicture.split(',').last),
                              )
                            : null,
                        child: doctor.doctorPicture.isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.doctorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor.qualification,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor.specialization,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Stats Row
                  // Row( //TODO:imapement pending
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     doctordetailscontroller.iconText(
                  //         Icons.star, "${doctor.overallRating}"),
                  //     doctordetailscontroller.iconText(
                  //         Icons.message, "${doctor.comments.length}"),
                  //     doctordetailscontroller.iconText(
                  //         Icons.location_city, hospital.city),
                  //   ],
                  // ),
                  const SizedBox(height: 10),

                  /// hospital
                  Row(
                    children: [
                      const Icon(Icons.local_hospital,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${hospital.name}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Experience
                  Row(
                    children: [
                      const Icon(Icons.badge, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${doctor.experience} years experience",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// Available Timing
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${doctor.availableDays}, ${doctor.availableTimes}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Focus
            const Text(
              "Focus Areas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: doctor.focusAreas.map((area) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "• $area",
                    style: const TextStyle(color: mainColor),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// Profile
            const Text(
              "Doctor's Profile",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: mainColor, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.profileDescription,
              style: const TextStyle(color: mainColor),
            ),

            const SizedBox(height: 20),

            /// Career Path
            // const Text(
            //   "Career Path",
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold, color: mainColor, fontSize: 16),
            // ),
            // const SizedBox(height: 8),

            // const SizedBox(height: 8),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: doctor.careerPath.asMap().entries.map((entry) {
            //     int index = entry.key + 1;
            //     String step = entry.value;
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 4),
            //       child: Text(
            //         "$index. $step",
            //         style: const TextStyle(color: mainColor),
            //       ),
            //     );
            //   }).toList(),
            // ),
            // const SizedBox(height: 20),

            /// Highlights
            const Text(
              "Highlights",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: mainColor, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: doctor.highlights.map((highlight) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          highlight,
                          style: const TextStyle(color: mainColor),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),

            // doctordetailscontroller.buildTimingAndContactSection(
            //     timing: doctor.availableTimes,
            //     // doctor: doctor,
            //     onCall: () {
            //       customerCare();
            //     },
            //     onDirection: () {
            //       String address = "${hospital.name},${hospital.address}";
            //       MapUtils.openMapByAddress(address);
            //     },
            //     hospitalNumber: hospital.contactNumber,
            //     days: doctor.availableDays),
            const SizedBox(height: 20),
            doctordetailscontroller.buildReportContactSection(
                context, doctordetailscontroller.moreDetails),
            buildRatingAndFeedback(context, doctorData, doctorController, ),
         
          ],
        ),
      ),
    );
  }
}
