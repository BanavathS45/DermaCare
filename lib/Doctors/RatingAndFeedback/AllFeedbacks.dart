import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../ListOfDoctors/DoctorController.dart';
import '../ListOfDoctors/DoctorModel.dart';

class Allfeedbacks extends StatefulWidget {
  final HospitalDoctorModel item;
  final Doctorcontroller controller;

  const Allfeedbacks({super.key, required this.item, required this.controller});

  @override
  State<Allfeedbacks> createState() => _AllfeedbacksState();
}

class _AllfeedbacksState extends State<Allfeedbacks> {
  @override
  Widget build(BuildContext context) {
    final doctor = widget.item.doctor;

    return Scaffold(
      appBar: CommonHeader(
        title: "All Feedbacks",
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, Color.fromARGB(255, 255, 255, 255)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ), // ✅ Your custom gradient function
              borderRadius: BorderRadius.circular(8), // optional
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8), // optional
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${doctor.name}, ${doctor.qualification}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold), // ensure text is visible
                      ),
                      Text(
                        "${doctor.specialization} ",
                        style: const TextStyle(
                            color: Color.fromARGB(
                                255, 50, 40, 40)), // ensure text is visible
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Overal Rating",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          doctor.overallRating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        Text("(${doctor.comments.length} Reviews)",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Rating

                  const SizedBox(height: 16),

                  // Comments
                  ...doctor.comments.map((comment) {
                    final userId = comment.userId;
                    final commentText = comment.comment;
                    final createdAt = DateTime.now().subtract(const Duration(
                        minutes: 1)); // Replace with actual timestamp

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Banavath Prashanth", // Replace with actual user name if available
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
                                            const Icon(Icons.star,
                                                color: Colors.yellow),
                                            Text(
                                              "${comment.rating}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    228, 41, 40, 40),
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
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
