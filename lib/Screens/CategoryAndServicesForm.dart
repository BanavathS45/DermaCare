import 'package:cutomer_app/APIs/FetchServices.dart';
import 'package:cutomer_app/Inputs/CustomDropdownField.dart';
import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/CopyRigths.dart';
import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/CustomerController.dart';
import '../Dashboard/DashBoardController.dart';
import '../Doctors/ListOfDoctors/DoctorScreen.dart';
import '../Services/serviceb.dart';
import '../TreatmentAndServices/ServiceSelectionController.dart';
import '../../Utils/GradintColor.dart';

class CategoryAndServicesForm extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final String consulationType;

  CategoryAndServicesForm(
      {required this.mobileNumber,
      required this.username,
      required this.consulationType});
  @override
  State<CategoryAndServicesForm> createState() =>
      _CategoryAndServicesFormState();
}

class _CategoryAndServicesFormState extends State<CategoryAndServicesForm> {
  final Dashboardcontroller controller = Get.put(Dashboardcontroller());
  final Serviceselectioncontroller serviceselectioncontroller =
      Get.put(Serviceselectioncontroller());
  @override
  void initState() {
    super.initState();
    fetchMainServices();
  }

  Future<void> fetchMainServices() async {
    await controller.fetchUserServices(); // ✅ JUST call it, don't assign
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Spacer(),
              Image.asset("assets/DermaText.png", height: 100),
              SizedBox(height: 20),
              GradientText(
                "Service Details", // Required text
                gradient: appGradient(), // Now it's a LinearGradient
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),
              Text(
                widget.consulationType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: secondaryColor,
                ),
              ),
              SizedBox(height: 40),

              // Service Category Image - Wrap in Obx ONLY this part
              Obx(() => controller.selectedService.value != null
                  ? Image.memory(
                      controller.selectedService.value!.categoryImage,
                      height: 100,
                    )
                  : SizedBox.shrink()),

              SizedBox(height: 20),

              // Dropdowns inside Obx because they use observables
              Obx(() => CustomDropdownField<Serviceb>(
                    value: controller.selectedService.value,
                    labelText: 'Service Category',
                    items: controller.services.map((service) {
                      return DropdownMenuItem<Serviceb>(
                        value: service,
                        child: Text(service.categoryName),
                      );
                    }).toList(),
                    onChanged: (service) {
                      controller.selectedService.value = service;
                      controller.selectedSubService.value = null;
                      controller.fetchSubServices(service!.categoryId);
                    },
                  )),

              SizedBox(height: 16),

              Obx(() {
                final subServiceList =
                    controller.subServiceList; // ✅ Observable accessed inside

                return CustomDropdownField<Service>(
                  value: subServiceList.isNotEmpty
                      ? controller.selectedSubService.value
                      : null,
                  labelText: 'Sub-Service',
                  items: subServiceList.isNotEmpty
                      ? subServiceList.map((sub) {
                          return DropdownMenuItem<Service>(
                            value: sub,
                            child: Text(sub.serviceName),
                          );
                        }).toList()
                      : [
                          DropdownMenuItem<Service>(
                            value: null,
                            child: Text("No Sub-Services Available"),
                          ),
                        ],
                  onChanged: (sub) {
                    if (subServiceList.isNotEmpty) {
                      controller.selectedSubService.value = sub;
                    }
                  },
                );
              }),

              SizedBox(height: 40),

              Container(
                decoration: BoxDecoration(
                  gradient: appGradient(),
                  borderRadius: BorderRadius.circular(10), // optional
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final selectedMain = controller.selectedService.value;
                    final selectedSub = controller.selectedSubService.value;

                    print(
                        "Selected Service Category: ${selectedMain?.categoryName}");
                    print("Selected Sub-Service: ${selectedSub?.serviceName}");

                    final selectedService = selectedSub;
                    final selectedServicesController =
                        Get.find<SelectedServicesController>();

                    if (selectedService != null && selectedMain != null) {
                      selectedServicesController
                          .updateSelectedServices([selectedService]);
                      selectedServicesController.categoryId.value =
                          selectedMain.categoryId;
                      selectedServicesController.categoryName.value =
                          selectedMain.categoryName;

                      Get.to(() => Doctorscreen(
                            mobileNumber: widget.mobileNumber,
                            username: widget.username,
                          ));
                    } else {
                      Get.snackbar(
                          "Error", "Please select a service and sub-service");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Submit", style: TextStyle(fontSize: 16)),
                ),
              ),

              Spacer(),
              Copyrights(),
            ],
          ),
        ),
      ),
    );
  }
}
