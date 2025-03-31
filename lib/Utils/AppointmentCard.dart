import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../BottomNavigation/Appoinments/AppointmentView.dart';
import 'GradintColor.dart';

class AppointmentCard extends StatelessWidget {
  final HospitalDoctorModel doctorData;
  const AppointmentCard({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("dfhjdsfkhdsjkfhdshfjd");
        Get.to(
          AppointmentPreview(
          
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: acrdGradient(),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${doctorData.hospital.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
                fontSize: 18,
              ),
              maxLines: 2,
            ),
            Text(
              doctorData.hospital.city,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // Profile image
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    doctorData.doctor.profileImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Info section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${doctorData.doctor.name}, ${doctorData.doctor.qualification}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        doctorData.doctor.specialization,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Text(doctorData.doctor.overallRating.toString()),
                          const SizedBox(width: 12),
                          Icon(
                              doctorData.doctor.rated
                                  ? Icons.favorite_sharp
                                  : Icons.favorite_border,
                              size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right section
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
                      "Hair Transplant",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    Text("Service and Treatment",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                  ],
                ),
                const SizedBox(width: 6),
                Row(
                  children: _buildStatusBadges("pending"),
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
      case 'accepted':
        return [_statusBadge("Accepted", Colors.green)];
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
