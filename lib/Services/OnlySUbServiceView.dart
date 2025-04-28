import 'package:cutomer_app/ServiceView/ServiceDetailPage.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Dashboard/DashBoardController.dart';
import '../Loading/SkeletonLoder.dart';
import '../Modals/ServiceModal.dart';

import '../TreatmentAndServices/ServiceSelectionController.dart';
import '../Utils/CommonCarouselAds.dart';
import '../Utils/GradintColor.dart';

class Onlysubserviceview extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String mobileNumber;
  final String username;

  const Onlysubserviceview({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.mobileNumber,
    required this.username,
  });

  @override
  _OnlysubserviceviewState createState() => _OnlysubserviceviewState();
}

class _OnlysubserviceviewState extends State<Onlysubserviceview>
    with SingleTickerProviderStateMixin {
  final Serviceselectioncontroller serviceselectioncontroller =
      Get.put(Serviceselectioncontroller());
  final Dashboardcontroller dashboardcontroller =
      Get.put(Dashboardcontroller());

  final items = [
    "Blood sample collection",
    "Plasma extraction and scalp injection",
    "Follow-up sessions"
  ];
  @override
  void initState() {
    super.initState();

    serviceselectioncontroller.fetchImages();
    serviceselectioncontroller.fetchServices(widget.categoryId).then((_) {
      serviceselectioncontroller.filteredServices.assignAll(
        serviceselectioncontroller.services,
      );
    });

    serviceselectioncontroller.updateTotal();
    serviceselectioncontroller.searchController
        .addListener(serviceselectioncontroller.updateSuggestions);

    serviceselectioncontroller.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    serviceselectioncontroller.skeletonColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(serviceselectioncontroller.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: 'Select Services',
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            serviceselectioncontroller.onRefresh(widget.categoryId),
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 20),
              CommonCarouselAds(
                media: dashboardcontroller.carouselImages,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  style: const TextStyle(color: secondaryColor),
                  controller: serviceselectioncontroller.searchController,
                  onChanged: serviceselectioncontroller.filterServices,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: "Search by service name",
                    suffixIcon: serviceselectioncontroller
                            .searchController.text.isNotEmpty
                        ? IconButton(
                            icon:
                                const Icon(Icons.clear, color: secondaryColor),
                            onPressed: serviceselectioncontroller.clearSearch,
                          )
                        : const Icon(Icons.search, color: secondaryColor),
                  ),
                ),
              ),
              if (serviceselectioncontroller.searchController.text.isNotEmpty &&
                  serviceselectioncontroller.filteredServices.isNotEmpty)
                Container(
                  child: Obx(() {
                    List<Service> services =
                        serviceselectioncontroller.filteredServices.value;

                    return ListView.builder(
                      shrinkWrap: true, // Needed inside Column/Scroll
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final suggestion = services[index];

                        return ListTile(
                          title: Text(suggestion.serviceName),
                          onTap: () {
                            serviceselectioncontroller.searchController.text =
                                suggestion.serviceName;

                            // Assign only the selected suggestion to filtered list
                            serviceselectioncontroller.filteredServices
                                .assignAll([suggestion]);

                            FocusScope.of(context).unfocus(); // Hide keyboard
                          },
                        );
                      },
                    );
                  }),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.categoryName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ),
              Expanded(
                child: serviceselectioncontroller.isLoading.value
                    ? SkeletonLoader(
                        animation:
                            serviceselectioncontroller.skeletonColorAnimation,
                      )
                    : serviceselectioncontroller.filteredServices.isEmpty
                        ? const Center(
                            child: Text(
                              "No services available",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                            ),
                            itemCount: serviceselectioncontroller
                                .filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = serviceselectioncontroller
                                  .filteredServices[index];
                              return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Select an option for \n${service.serviceName}",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.red),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            // List of direct options (Replace 'items' with your actual options)
                                            ...items.map((option) => ListTile(
                                                  title: Text(option),
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context); // Close bottom sheet
                                                    // Navigate to next page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServiceDetailsPage(
                                                          categoryName: service
                                                              .categoryName,
                                                          serviceId:
                                                              service.serviceId,
                                                          serviceName: service
                                                              .serviceName,
                                                          categoryId:
                                                              widget.categoryId,
                                                          servicePrice: service
                                                              .discountedCost
                                                              .toStringAsFixed(
                                                                  0),
                                                          mobileNumber: widget
                                                              .mobileNumber,
                                                          username:
                                                              widget.username,
                                                              selectedOption:option
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 246, 246, 246),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 225, 224, 224),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(10)),
                                          child: AspectRatio(
                                            aspectRatio: 1.5,
                                            child: service.serviceImage !=
                                                        null &&
                                                    service
                                                        .serviceImage.isNotEmpty
                                                ? Image.memory(
                                                    service.serviceImage,
                                                    fit: BoxFit.cover)
                                                : Container(
                                                    color: Colors.grey.shade200,
                                                    child: const Center(
                                                        child:
                                                            Text("No Image")),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            service.serviceName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
