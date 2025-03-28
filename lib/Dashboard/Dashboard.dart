import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Help/Numbers.dart';
import '../Modals/ServiceCard.dart';
import '../Utils/AppointmentCard.dart';
import '../Utils/CommonCarouselAds.dart';
import '../Utils/Constant.dart';
import '../Utils/GradintColor.dart';
import '../Utils/capitalizeFirstLetter.dart';
import 'DashBoardController.dart';

class DashboardScreen extends StatefulWidget {
  final String mobileNumber;
  final String username;

  const DashboardScreen({
    super.key,
    required this.mobileNumber,
    required this.username,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Dashboardcontroller dashboardcontroller =
      Get.put(Dashboardcontroller());

  @override
  void initState() {
    super.initState();

    dashboardcontroller.loadSavedImage();
    dashboardcontroller.fetchUserServices();
    dashboardcontroller.fetchAppointments(widget.mobileNumber);
    dashboardcontroller.fetchImages();
    dashboardcontroller.storeUserData(widget.mobileNumber, widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appGradient()),
        ),
        title: Row(children: [
          Obx(() {
            final image = dashboardcontroller.imageFile.value;
            return GestureDetector(
              onTap: () => dashboardcontroller.showImagePickerOptions(context),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: image != null
                    ? FileImage(image)
                    : const AssetImage('assets/surecare_launcher.png')
                        as ImageProvider,
              ),
            );
          }),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hi, Welcome Back",
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              const SizedBox(height: 5),
              Text(
                capitalizeFirstLetter(widget.username),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Get.offAll(() => BottomNavController(
                    mobileNumber: widget.mobileNumber,
                    username: widget.username,
                    index: 0,
                  ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () async {
              await whatsUpChat();
            },
          )
        ]),
      ),
      body: Obx(() {
        if (dashboardcontroller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (dashboardcontroller.services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/nonetwork.jpg",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.6,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Image failed to load',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  dashboardcontroller.statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  onPressed: () =>
                      dashboardcontroller.onRefresh(widget.mobileNumber),
                  tooltip: 'Refresh',
                  child: const Icon(Icons.refresh),
                )
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => dashboardcontroller.onRefresh(widget.mobileNumber),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CommonCarouselAds(
                    media: dashboardcontroller.carouselImages,
                    height: 170,
                  ),
                  const SizedBox(height: 20),
                  if (dashboardcontroller.allAppointments.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Active Appointments",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          min(3, dashboardcontroller.allAppointments.length),
                          (index) {
                            final appointment =
                                dashboardcontroller.allAppointments[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.95,
                                child:
                                    buildAppointmentCard(appointment, context),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Center(
                    child: GradientText(
                      'Derma Services And Treatments',
                      gradient: const LinearGradient(
                        colors: [mainColor, secondaryColor],
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dashboardcontroller.services.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final service = dashboardcontroller.services[index];
                      return ServiceCard(
                        mobileNumber: widget.mobileNumber,
                        username: widget.username,
                        service: service,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
