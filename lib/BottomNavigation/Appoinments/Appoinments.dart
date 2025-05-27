import 'package:cutomer_app/Dashboard/DashBoardController.dart';
import 'package:cutomer_app/Help/Numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/AppointmentCard.dart';
import '../../Utils/Constant.dart';
import '../../Utils/Header.dart';
import 'AppointmentController.dart';

class AppointmentPage extends StatefulWidget {
  final String mobileNumber;

  AppointmentPage({required this.mobileNumber});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  
  final dashboardcontroller = Get.put(Dashboardcontroller());
  // final couns = Get.put(Dashboardcontroller());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardcontroller.setMobileNumber(widget.mobileNumber);
  
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(AppointmentController()); // Pass mobileNumber here

    return Scaffold(
      appBar: CommonHeader(
        title: "Appointments",
        onNotificationPressed: () {},
        onSettingPressed: () async {
          await whatsUpChat();
        },
        automaticallyImplyLeading: false,
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.refreshBookings,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: _buildTabButton(
                              controller, 'UPCOMING', mainColor)),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: _buildTabButton(
                              controller, 'COMPLETED', secondaryColor)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'MY APPOINTMENTS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ),
                Expanded(
                  // Prevent overflow
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.filteredBookings.isEmpty
                          ? const Center(
                              child: Text('No bookings found for this tab'))
                          : ListView.builder(
                              itemCount: controller.filteredBookings.length,
                              itemBuilder: (context, index) {
                                final booking =
                                    controller.filteredBookings[index];
                                return AppointmentCard(doctorData: booking);
                              },
                            ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildTabButton(
      AppointmentController controller, String tabName, Color activeColor) {
    return GestureDetector(
      onTap: () => controller.changeTab(tabName),
      child: Obx(() {
        final bool isSelected =
            controller.selectedTab.value == tabName; // Moved inside Obx
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey,
              width: 1,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              tabName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
