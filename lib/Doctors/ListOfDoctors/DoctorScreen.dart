import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/Constant.dart';
import '../../Utils/Header.dart';
import '../../Widget/DoctorCard.dart';

class Doctorscreen extends StatelessWidget {
  final String mobileNumber;
  final String username;

  Doctorscreen({required this.mobileNumber, required this.username});

  final DoctorController doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Doctors & Hospitals",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFilters(doctorController),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Doctors",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            mainColor, // You can replace with your desired color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${doctorController.filteredDoctors.length} ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: doctorController.filteredDoctors.isEmpty
                  ? Column(
                      children: [
                        Center(
                          child: Text("No doctors found"),
                        ),
                        doctorController.filteredDoctors.isEmpty
                            ? FloatingActionButton(
                                onPressed: () {
                                  print("I am calling refresh");
                                  doctorController.refreshDoctors();
                                },
                                child: Icon(Icons.refresh),
                              )
                            : SizedBox.shrink(),
                      ],
                    )
                  : ListView.builder(
                      itemCount: doctorController.filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return buildDoctorCard(
                          context,
                          doctorController.filteredDoctors[index],
                          doctorController,
                        );
                      },
                    ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      }),
    );
  }
}
