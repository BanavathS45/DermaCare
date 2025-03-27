import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import '../Doctors/DoctorDetails/DoctorDetailsScreen.dart';
import '../Doctors/Schedules/Schedule.dart';
import '../Utils/GradintColor.dart';

Widget buildDoctorCard(BuildContext context, HospitalDoctorModel item,
    Doctorcontroller controller) {
  final doctor = item.doctor;
  final hospital = item.hospital;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      gradient: appGradient(),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${hospital.name} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "(${hospital.city})",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: doctor.favorites ? Colors.yellow : Colors.white60,
                ),
                onPressed: () => controller.toggleFavorite(item),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Doctor details
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(doctor.profileImage),
                onBackgroundImageError: (_, __) => const Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${doctor.name} ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: mainColor),
                                      maxLines: 2, // Limit to 2 lines

                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "(${doctor.qualification})",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey),
                                      maxLines: 2, // Limit to 2 lines

                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Column(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: mainColor,
                                  ),
                                  Text(
                                    "Verified",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              )
                            ],
                          ),
                          Text(
                            doctor.specialization,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Rating & Comments & BOOK
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text("${doctor.overallRating}",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text("${doctor.comments.length}",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => DoctorDetailScreen(doctorData: item));

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => ScheduleScreen(doctorData: item),
                      //   ),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "ABOUT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => ScheduleScreen(doctorData: item));

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => DoctorDetailScreen(doctorData: item),
                      //   ),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "BOOK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildFilters(Doctorcontroller controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sort by",
          style: TextStyle(
              color: mainColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilterChip(
              label: Text(
                "A-Z",
                style: TextStyle(
                  color: controller.sortByAZ.value ? Colors.white : mainColor,
                ),
              ),
              selectedColor: mainColor,
              // color: Colors.red,
              selected: controller.sortByAZ.value,
              showCheckmark: false,
              onSelected: (val) {
                controller.sortByAZ.value = val;
                controller.applyFilters();
              },
            ),
            FilterChip(
              label: Icon(
                Icons.male,
                color: controller.selectedGender.value == "Male"
                    ? Colors.white
                    : mainColor,
              ),
              selectedColor: mainColor,
              showCheckmark: false,
              selected: controller.selectedGender.value == "Male",
              onSelected: (val) {
                controller.selectedGender.value = val ? "Male" : "All";
                controller.applyFilters();
              },
            ),
            FilterChip(
              label: Icon(
                Icons.female,
                color: controller.selectedGender.value == "Female"
                    ? Colors.white
                    : mainColor,
              ),
              selectedColor: mainColor,
              showCheckmark: false,
              selected: controller.selectedGender.value == "Female",
              onSelected: (val) {
                controller.selectedGender.value = val ? "Female" : "All";
                controller.applyFilters();
              },
            ),
            FilterChip(
              label: Icon(
                Icons.favorite,
                color: controller.showFavoritesOnly.value
                    ? Colors.white
                    : mainColor,
              ),
              selectedColor: mainColor,
              showCheckmark: false,
              selected: controller.showFavoritesOnly.value,
              onSelected: (val) {
                controller.showFavoritesOnly.value = val;
                controller.applyFilters();
              },
            ),
            FilterChip(
              label: Icon(
                Icons.star,
                color: controller.selectedRating.value >= 4.5
                    ? Colors.white
                    : mainColor,
              ),
              selectedColor: mainColor,
              showCheckmark: false,
              selected: controller.selectedRating.value >= 4.5,
              onSelected: (val) {
                controller.selectedRating.value = val ? 4.5 : 0.0;
                controller.applyFilters();
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedCity.value,
                  onChanged: (value) {
                    controller.selectedCity.value = value!;
                    controller.applyFilters();
                  },
                  items: controller.cityList
                      .map(
                        (city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            // city.isEmpty ? city : "No city available",
                            city,
                            style: TextStyle(color: mainColor),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
