import 'dart:convert';

import 'package:cutomer_app/BottomNavigation/Appoinments/PostBooingModel.dart';
import 'package:cutomer_app/BottomNavigation/Profile/ProfileScreens.dart';
import 'package:cutomer_app/Customers/GetCustomerModel.dart';
import 'package:cutomer_app/Dashboard/DashBoardController.dart';
import 'package:cutomer_app/Dashboard/GetCustomerData.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Doctors/ListOfDoctors/DoctorModel.dart';

class CustomerProfilePage extends StatefulWidget {
  final String mobileNumber;
  const CustomerProfilePage({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear session
    Get.offAllNamed('/login'); // or use Get.offAll(() => Loginscreen());
  }

  final dashboardcontroller =
      Get.put(Dashboardcontroller());

  bool isAvailable = true;
  GetCustomerModel? userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Profile",
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Obx(() {
            final image = dashboardcontroller.imageFile.value;
            return GestureDetector(
              onTap: () => dashboardcontroller.showImagePickerOptions(context,image),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                backgroundImage: image != null
                    ? FileImage(image)
                    : const AssetImage('assets/surecare_launcher.png')
                        as ImageProvider,
              ),
            );
          }),

          //  Obx(() {
          //     final image = dashboardcontroller.imageFile.value;

          //     return GestureDetector(
          //       onTap: () {
          //         if (image != null) {
          //           Get.to(ImagePreviewScreen(imagePath: image.path));
          //         } else {
          //           dashboardcontroller.showImagePickerOptions(context,image);
          //         }
          //       },
          //       child: CircleAvatar(
          //         radius: 20,
          //         backgroundColor: Colors.grey[200],
          //         backgroundImage: image != null
          //             ? FileImage(image)
          //             : const AssetImage('assets/surecare_launcher.png')
          //                 as ImageProvider,
          //       ),
          //     );
          //   }),
          // CircleAvatar(
          //   radius: 40,
          //   child: ClipOval(
          //     child: Image.asset(
          //       "assets/DermaText.png",
          //       width: 100, // adjust size as needed
          //       height: 100,
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),

          FutureBuilder<GetCustomerModel>(
            future:
                fetchUserData(widget.mobileNumber), // Mobile number passed here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No data available."));
              } else {
                userData = snapshot.data!;
                print("userData: ${userData!.fullName}"); // Debug print

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('${capitalizeEachWord(userData!.fullName)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainColor)),
                    Text('Customer ID: ${userData!.customerId}'),
                  ],
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          // Cards List
          buildCardItem(
              icon: Icons.person,
              label: "Profile",
              onTap: () =>
                  Get.to(() => ProfileDetailScreen(cusData: userData!))),
          // Get.to(() => ProfileDetailScreen())),

          buildCardItem(
              icon: Icons.help_outline,
              label: "Privacy Policy",
              onTap: () => Get.to(() => HelpScreen())),
          // onTap: () {}),
          buildCardItem(
              icon: Icons.help_outline,
              label: "Help",
              onTap: () => Get.to(() => HelpScreen())),
          // onTap: () {}),
          buildCardItem(
              icon: Icons.logout,
              label: "Logout",
              onTap: () => {showLogout(context)}),
          const SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Center(
            child: Text(
          "Version 1.1.0",
          style: TextStyle(color: mainColor),
        )),
      ),
    );
  }

  Widget buildCardItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: mainColor,
        child: Icon(icon, color: Colors.white),
      ),
      title:
          Text(label, style: const TextStyle(fontSize: 16, color: mainColor)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: secondaryColor,
      ),
      onTap: onTap,
    );
  }

  showLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 40, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                "Confirm Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Are you sure you want to logout?"),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        await logout(); // Call logout logic
                      },
                      child: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
