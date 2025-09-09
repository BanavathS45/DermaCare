import 'dart:math';
import 'package:cutomer_app/ConfirmBooking/Consultations.dart';
import 'package:cutomer_app/Dashboard/ImagePreview.dart';
import 'package:cutomer_app/Dashboard/VisitType.dart';
import 'package:cutomer_app/Notification/NotificationController.dart';
import 'package:cutomer_app/Notification/Notifications.dart';
import 'package:cutomer_app/Screens/RefferalCode.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomNavigation/Appoinments/AppointmentController.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../ConfirmBooking/ConsultationController.dart';
import '../ConfirmBooking/ConsultationServices.dart';
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
  final String? consulationType;

  const DashboardScreen({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.consulationType,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final Dashboardcontroller dashboardcontroller =
      Get.put(Dashboardcontroller());
  final controller = Get.put(AppointmentController());
  String visitType = "First Time"; // default
  late final AnimationController _rotationController;

  bool showLabel = false;
  bool isFabVisible = true;
  late ScrollController _scrollController;
  bool isOpaque = false;
  final consultationcontroller = Get.find<Consultationcontroller>();
  void _onFabTapped() {
    if (!showLabel) {
      setState(() => showLabel = true);
    } else {
      Navigator.pop(context); // Do actual navigation if label is already shown
    }
  }

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.userScrollDirection ==
                ScrollDirection.reverse &&
            isFabVisible) {
          setState(() {
            isFabVisible = false;
          });
        } else if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward &&
            !isFabVisible) {
          setState(() {
            isFabVisible = true;
          });
        }
      });

    // Now call async logic separately
    loadInitialData();
  }

  void loadInitialData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? firstConsultationId = prefs.getString('firstConsultationId');
    String? firstConsultationType = prefs.getString('firstConsultationType');

    if (firstConsultationId != null && firstConsultationType != null) {
      ConsultationModel consultation = ConsultationModel(
        consultationType: firstConsultationType,
        consultationId: firstConsultationId,
      );

      consultationcontroller.setConsultation(consultation);

      print('Stored ID: $firstConsultationId');
      print('Stored Type: $firstConsultationType');
    } else {
      print('No consultation stored yet.');
    }

    dashboardcontroller.loadSavedImage();
    dashboardcontroller.fetchUserServices();
    dashboardcontroller.fetchAppointments(widget.mobileNumber);
    dashboardcontroller.fetchImages();
    controller.fetchBookings();
    dashboardcontroller.storeUserData(widget.mobileNumber, widget.username);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Services & Treatments",
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
                  onPressed: () async {
                    _rotationController.repeat(); // Start spinning
                    await dashboardcontroller.onRefresh(widget.mobileNumber);
                    _rotationController.reset(); // Stop spinning
                  },
                  tooltip: 'Refresh',
                  child: AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => dashboardcontroller.onRefresh(widget.mobileNumber),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // CommonCarouselAds(
                  //   media: dashboardcontroller.carouselImages,
                  //   height: 170,
                  // ),
                  VisitType(
                    mobileNumber: widget.mobileNumber,
                    username: widget.username,
                    consulationType: widget.consulationType!,
                    onVisitTypeChanged: (type) {
                      setState(() {
                        visitType = type;
                      });
                    },
                  ),

                  if (controller.inProgressBookings.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Active Appointments",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("${controller.inProgressBookings.length}")
                        ],
                      ),
                    ),
                    Obx(() {
                      print(
                          'In-progress bookings count: ${controller.inProgressBookings.length}');

                      if (controller.inProgressBookings.isEmpty) {
                        // 👈 Fix here
                        return const Center(
                            child: Text('No in-progress appointments'));
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            min(3, controller.inProgressBookings.length),
                            (index) {
                              final appointment =
                                  controller.inProgressBookings[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child:
                                      AppointmentCard(doctorData: appointment),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
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
                        fontSize: 24,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IgnorePointer(
                    ignoring: visitType == "Follow-Up",
                    child: Opacity(
                      opacity: visitType == "Follow-Up"
                          ? 0.5
                          : 1.0, // visually disabled
                      child: GridView.builder(
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
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
      // floatingActionButton: isFabVisible
      //     ? AnimatedOpacity(
      //         duration: Duration(milliseconds: 300),
      //         opacity: isOpaque ? 1.0 : 0.4,
      //         child: FloatingActionButton.extended(
      //           onPressed: () {
      //             if (!showLabel) {
      //               setState(() {
      //                 showLabel = true;
      //                 isOpaque = true;
      //               });
      //             } else {
      //               // Navigator.pop(context); // or your logic
      //               Get.to(BottomNavController(
      //                 mobileNumber: widget.mobileNumber,
      //                 username: widget.username,
      //               ));
      //             }
      //           },
      //           icon: Icon(Icons.arrow_back_ios_new_rounded),
      //           label: AnimatedSwitcher(
      //             duration: Duration(milliseconds: 300),
      //             transitionBuilder: (child, animation) =>
      //                 ScaleTransition(scale: animation, child: child),
      //             child: showLabel
      //                 ? Text("Consultations", key: ValueKey("label"))
      //                 : SizedBox.shrink(key: ValueKey("empty")),
      //           ),
      //         ),
      //       )
      //     : null
    );
  }
}
