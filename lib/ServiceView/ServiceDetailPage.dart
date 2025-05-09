import 'dart:convert';
import 'dart:typed_data';
import 'package:cutomer_app/Controller/CustomerController.dart';
import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cutomer_app/ServiceView/FetchViewService.dart';
import 'package:flutter/material.dart';
import '../APIs/BaseUrl.dart';
import '../APIs/FetchServices.dart';
import '../Doctors/ListOfDoctors/DoctorScreen.dart';
import '../Loading/SkeletonLoder.dart';
import '../TreatmentAndServices/ServiceSelectionController.dart';
import '../Utils/ConvertMinToHours.dart';
import '../Utils/GradintColor.dart';
import '../Utils/Header.dart';
import 'ServiceDetail.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String mobileNumber;
  final String username;

  const ServiceDetailsPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.serviceId,
    required this.serviceName,
    required this.mobileNumber,
    required this.username,
    required this.selectedService,
    required this.services,
  });
  final String categoryName;
  final String categoryId;
  final String serviceId;
  final String serviceName;

  final SubService selectedService;
  final Service services;

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage>
    with SingleTickerProviderStateMixin {
  late ApiService apiService;
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<Color?> _skeletonColorAnimation;
  final Serviceselectioncontroller serviceselectioncontroller =
      Get.put(Serviceselectioncontroller());
  final serviceFetcher = Get.put(ServiceFetcher());
  // Replace with your data model.

  @override
  void initState() {
    super.initState();
    apiService = ApiService();

    // Initialize animation for skeleton loading
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _skeletonColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.services;
    return Scaffold(
      appBar: CommonHeader(
        title: "Service & Treatment Details",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.selectedService.subServiceImage.isNotEmpty
                  ? Image.memory(
                      widget.selectedService.subServiceImage,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Center(child: Text("No Image")),
                    ),
              const SizedBox(height: 16),

              Text(
                widget.selectedService.viewDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Category Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.categoryName,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Service Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.serviceName,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              const Text(
                'Sub Service Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.selectedService.subServiceName,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              const Text(
                'Service Duration:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.selectedService.minTime,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Description Q&A
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.selectedService.descriptionQA.expand((descQA) {
                    return descQA.qa.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key, // Question
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...entry.value.map((answer) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 4.0),
                                  child: Text(
                                    "• $answer", // Answer
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )),
                          ],
                        ),
                      );
                    });
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: appGradient(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // serviceselectioncontroller.showAddedItemsAlert(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "₹ ${widget.selectedService.price}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "(include all taxes\n& discount (if any))",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.white.withOpacity(0.5),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => Doctorscreen(
                      mobileNumber: widget.mobileNumber,
                      username: widget.username,
                    ));

                final selectedServicesController =
                    Get.find<SelectedServicesController>();
                selectedServicesController
                    .updateSelectedSubServices([widget.selectedService]);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: const Text(
                  "CONTINUE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
