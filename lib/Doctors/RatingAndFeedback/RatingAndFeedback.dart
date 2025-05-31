import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Widget/CommentCOntroller.dart';
import '../ListOfDoctors/DoctorController.dart';

import 'AllFeedbacks.dart';

import 'RatingController.dart';

buildRatingAndFeedback(BuildContext context, HospitalDoctorModel item,
    DoctorController controller) {
  Ratingcontroller ratingcontroller = Ratingcontroller();
  CommentController commentController = Get.put(CommentController());
  final replyController = TextEditingController();

  final doctor = item.doctor;
  // final safeComments = doctor.comments.length >= 5
  // ? doctor.comments.take(5).toList()
  // : doctor.comments;
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
                    // Text(
                    //   doctor..toStringAsFixed(1),
                    //   style: const TextStyle(
                    //       fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    Text(
                      "10",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 6,
                  height: 5,
                ),
                // Text("(${doctor.comments.length} Reviews)",//TODO:pending
                Text("10 Reviews)", style: const TextStyle(color: Colors.grey)),
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

        // ...doctor.comments.asMap().entries.take(5).map((entry) {
        //   final index = entry.key;
        //   final comment = entry.value;
        //   final userId = comment.userId;
        //   final commentText = comment.comment;
        //   final createdAt = DateTime.parse(comment.createdAt);
        //   final initials = _getInitials(userId); // or use your logic

        //   // Replace with actual timestamp if available

        //   return Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(bottom: 12),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             // Avatar with initials
        //             CircleAvatar(
        //               radius: 20,
        //               backgroundColor: Colors.grey.shade300,
        //               child: Text(
        //                 "BP",
        //                 style: const TextStyle(
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black,
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(width: 10),

        //             // Comment and time

        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Expanded(
        //                         child: Text(
        //                           "Banavath Prashanth", // Replace with dynamic name if needed
        //                           style: const TextStyle(
        //                             fontSize: 16,
        //                             color: Colors.black,
        //                             fontWeight: FontWeight.bold,
        //                           ),
        //                           maxLines: 2,
        //                         ),
        //                       ),
        //                       const SizedBox(width: 10),
        //                       Row(
        //                         children: [
        //                           const Icon(Icons.star, color: Colors.yellow),
        //                           Text(
        //                             "${comment.rating}",
        //                             style: const TextStyle(
        //                               fontSize: 16,
        //                               color: Color.fromARGB(228, 41, 40, 40),
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ],
        //                   ),
        //                   Text(
        //                     timeago.format(createdAt),
        //                     style: const TextStyle(
        //                         fontSize: 12, color: Colors.grey),
        //                   ),
        //                   const SizedBox(height: 4),
        //                   Text(
        //                     commentText,
        //                     style: const TextStyle(fontSize: 14),
        //                   ),

        //                   /// REPLY BUTTON
        //                   Obx(() {
        //                     return TextButton(
        //                       onPressed: () {
        //                         commentController.toggleReplyField(index);
        //                       },
        //                       child: Text(
        //                         commentController.replyingIndex.value == index
        //                             ? "Cancel"
        //                             : "Reply",
        //                       ),
        //                     );
        //                   }),
        //                   Obx(() {
        //                     if (commentController.replyingIndex.value ==
        //                         index) {
        //                       return Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 0.0, vertical: 8),
        //                         child: Row(
        //                           children: [
        //                             Expanded(
        //                               child: TextField(
        //                                 controller: replyController,
        //                                 decoration: InputDecoration(
        //                                   hintText: "Write a reply...",
        //                                   border: OutlineInputBorder(),
        //                                   contentPadding: EdgeInsets.symmetric(
        //                                       horizontal: 10, vertical: 8),
        //                                 ),
        //                               ),
        //                             ),
        //                             // IconButton(
        //                             //   icon: Icon(Icons.send),
        //                             //   onPressed: () {
        //                             //     final replyText =
        //                             //         replyController.text.trim();
        //                             //     if (replyText.isNotEmpty) {
        //                             //       final newReply = Reply(
        //                             //         reply: replyText,
        //                             //         userId:
        //                             //             "admin001", // You can dynamically replace this
        //                             //         createAt: DateTime.now()
        //                             //             .toIso8601String(),
        //                             //       );

        //                             //       commentController.sendReply(
        //                             //           index, newReply);

        //                             //       replyController.clear();
        //                             //       commentController
        //                             //           .toggleReplyField(-1);
        //                             //     }
        //                             //   },
        //                             // )

        //                           ],
        //                         ),
        //                       );
        //                     } else {
        //                       return SizedBox();
        //                     }
        //                   }),

        //                   /// SHOW EXISTING REPLIES
        //                   // ...comment.replies.map((Reply reply) => Padding(
        //                   //       padding:
        //                   //           const EdgeInsets.only(left: 16.0, top: 4),
        //                   //       child: Row(
        //                   //         children: [
        //                   //           Icon(Icons.subdirectory_arrow_right,
        //                   //               size: 16, color: Colors.grey),
        //                   //           const SizedBox(width: 4),
        //                   //           Expanded(
        //                   //             child: Text(
        //                   //               reply.reply,
        //                   //               style: TextStyle(
        //                   //                   fontSize: 14,
        //                   //                   color: Colors.grey[700]),
        //                   //             ),
        //                   //           ),
        //                   //           Text(
        //                   //             timeago.format(
        //                   //                 DateTime.parse(reply.createAt)),
        //                   //             style: const TextStyle(
        //                   //                 fontSize: 11, color: Colors.grey),
        //                   //           ),
        //                   //         ],
        //                   //       ),
        //                   //     )),

        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       const Divider(
        //         height: 1,
        //         thickness: 1,
        //         color: Color.fromARGB(161, 158, 158, 158),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ) // ✅ Properly placed divider
        //     ],
        //   );
        // }).toList(),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     OutlinedButton(
        //       onPressed: doctor.rated
        //           ? null
        //           : () => ratingcontroller.feedbackPage(item),
        //       style: OutlinedButton.styleFrom(
        //         padding: EdgeInsets.all(8), // 👈 removes internal padding
        //         side: const BorderSide(color: Colors.grey),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //         child: Text(
        //           doctor.rated ? "Rated" : "Share your feedback",
        //           style: const TextStyle(fontSize: 14),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 4),
        //     OutlinedButton(
        //       onPressed: () {
        //         Get.to(Allfeedbacks(
        //           item: item,
        //           controller: controller,
        //         ));
        //       },
        //       style: OutlinedButton.styleFrom(
        //         padding: EdgeInsets.all(8), // 👈 removes internal padding
        //         side: const BorderSide(color: Colors.grey),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //       child: const Padding(
        //         padding: EdgeInsets.symmetric(
        //             horizontal: 8, vertical: 4), // optional
        //         child: Text(
        //           "Read all feedback",
        //           style: TextStyle(fontSize: 14),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
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
