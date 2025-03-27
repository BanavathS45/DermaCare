import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../ListOfDoctors/DoctorController.dart';
import '../ListOfDoctors/DoctorModel.dart';
import 'AllFeedbacks.dart';

import 'RatingController.dart';

buildRatingAndFeedback(BuildContext context, HospitalDoctorModel item,
    Doctorcontroller controller) {
  Ratingcontroller ratingcontroller = Ratingcontroller();

  final doctor = item.doctor;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
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
                      doctor.overallRating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 6,
                  height: 5,
                ),
                Text("(${doctor.comments.length} Reviews)",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(161, 158, 158, 158),
        ),
        const SizedBox(height: 16),
        // Comments
        ...doctor.comments.take(5).map((comment) {
          final userId = comment.userId;
          final commentText = comment.comment;
          final initials = _getInitials(userId);
          final createdAt = DateTime.now().subtract(const Duration(
              minutes: 1)); // Replace with actual timestamp if available

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with initials
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        "BP",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Comment and time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Banavath Prashanth", // Replace with name if dynamic
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.yellow),
                                  Text(
                                    "${comment.rating}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(228, 41, 40, 40),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            timeago.format(createdAt),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            commentText,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color.fromARGB(161, 158, 158, 158),
              ),
              SizedBox(
                height: 20,
              ) // ✅ Properly placed divider
            ],
          );
        }).toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: doctor.rated
                  ? null
                  : () => ratingcontroller.feedbackPage(item),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(8), // 👈 removes internal padding
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  doctor.rated ? "Rated" : "Share your feedback",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 4),
            OutlinedButton(
              onPressed: () {
                Get.to(Allfeedbacks(
                  item: item,
                  controller: controller,
                ));
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(8), // 👈 removes internal padding
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4), // optional
                child: Text(
                  "Read all feedback",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

// Helper for initials
String _getInitials(String userId) {
  final parts = userId.split(' ');
  if (parts.length >= 2) {
    return (parts[0][0] + parts[1][0]).toUpperCase();
  } else {
    return parts[0][0].toUpperCase();
  }
}
