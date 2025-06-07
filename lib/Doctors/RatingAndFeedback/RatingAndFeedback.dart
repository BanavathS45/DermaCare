import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../BottomNavigation/Appoinments/AppointmentService.dart';
import '../../BottomNavigation/Appoinments/GetAppointmentModel.dart';
import '../../Customers/GetCustomerModel.dart';
import '../../Dashboard/GetCustomerData.dart';
import '../../Review/ReviewScreen.dart';
import '../../Widget/CommentCOntroller.dart';
import '../ListOfDoctors/DoctorController.dart';
import 'AllFeedbacks.dart';
import 'RatingController.dart';
import 'RatingModal.dart';
import 'RatingService.dart';

Widget buildRatingAndFeedback(
  BuildContext context,
  HospitalDoctorModel item,
  DoctorController controller,
) {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Text(
            'Failed to load user data: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else if (!snapshot.hasData) {
        return const Center(
          child: Text('User data not available'),
        );
      }

      final prefs = snapshot.data!;
      final loggedInUserMobile = prefs.getString('mobileNumber');

      return _buildRatingContent(context, item, controller, loggedInUserMobile);
    },
  );
}

Widget _buildRatingContent(
  BuildContext context,
  HospitalDoctorModel item,
  DoctorController controller,
  String? loggedInUserMobile,
) {
  CommentController commentController = Get.put(CommentController());
  final replyController = TextEditingController();

  final doctor = item.doctor;
  var bookingDetails;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<RatingSummary>(
          future: fetchRatingSummary(item.hospital.hospitalId, doctor.doctorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load feedback: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData ||
                (snapshot.data!.overallDoctorRating == 0 &&
                    snapshot.data!.comments.isEmpty)) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Patients Feedback',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No ratings or comments available.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              );
            } else {
              final doctorRating = snapshot.data!;
              final userHasRated = loggedInUserMobile != null &&
                  doctorRating.comments.any((c) =>
                      c.customerMobileNumber == loggedInUserMobile &&
                      c.rated == true);

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Patients Feedback',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 6),
                              Text(
                                "${doctorRating.overallDoctorRating}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text("${doctorRating.comments.length} Reviews",
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Comments list (max 5)
                  ...doctorRating.comments.asMap().entries.take(5).map((entry) {
                    final index = entry.key;
                    final comment = entry.value;
                    final AppointmentService appointmentService =
                        AppointmentService();
                    return FutureBuilder<Getappointmentmodel?>(
                      future: appointmentService
                          .fetchAppointmentById(comment.appointmentId),
                      builder: (context, appointmentSnapshot) {
                        if (appointmentSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        bookingDetails = appointmentSnapshot.data;

                        return FutureBuilder<GetCustomerModel?>(
                          future: fetchUserData(comment.customerMobileNumber),
                          builder: (context, userSnapshot) {
                            final customerName = userSnapshot.hasData
                                ? capitalizeEachWord(
                                    userSnapshot.data!.fullName)
                                : 'Loading...';

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey.shade300,
                                        child: Text(
                                          customerName.isNotEmpty
                                              ? customerName[0].toUpperCase()
                                              : "?",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    customerName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow),
                                                    Text(
                                                      "${comment.doctorRating}",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              timeago.format(DateTime.now()
                                                  .subtract(const Duration(
                                                      hours: 1))),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(comment.feedback,
                                                style: const TextStyle(
                                                    fontSize: 14)),

                                            /// Reply Button
                                            Obx(() {
                                              return TextButton(
                                                onPressed: () {
                                                  commentController
                                                      .toggleReplyField(index);
                                                },
                                                child: Text(
                                                  commentController
                                                              .replyingIndex
                                                              .value ==
                                                          index
                                                      ? "Cancel"
                                                      : "Reply",
                                                ),
                                              );
                                            }),

                                            /// Reply Field
                                            Obx(() {
                                              if (commentController
                                                      .replyingIndex.value ==
                                                  index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              replyController,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "Write a reply...",
                                                            border:
                                                                OutlineInputBorder(),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            8),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Add action button if needed:
                                // if (bookingDetails != null)
                                //   Align(
                                //     alignment: Alignment.centerRight,
                                //     child: TextButton(
                                //       child:
                                //           const Text("Rate this appointment"),
                                //       onPressed: () {
                                //         Get.to(() => ReviewScreen(
                                //               doctorData: item,
                                //               doctorBookings: bookingDetails,
                                //             ));
                                //       },
                                //     ),
                                //   ),
                                const Divider(),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }),

                  /// Buttons for "Rate" or "Read all feedback"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: userHasRated
                            ? null
                            : () => Get.to(ReviewScreen(
                                  doctorData: item,
                                  doctorBookings: bookingDetails,
                                )),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            userHasRated ? "Rated" : "Share your feedback",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Get.to(Allfeedbacks(
                            item: item,
                            controller: controller,
                            rating: doctorRating,
                          ));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "Read all feedback",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    ),
  );
}
