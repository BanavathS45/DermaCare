import 'package:cutomer_app/ServiceView/ServiceDetailPage.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Loading/SkeletonLoder.dart';
import '../Modals/ServiceModal.dart';
import 'ServiceSelectionController.dart';
import '../Utils/CommonCarouselAds.dart';
import '../Utils/GradintColor.dart';

class SelectServicesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String mobileNumber;
  final String username;

  const SelectServicesPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.mobileNumber,
    required this.username,
  });

  @override
  _SelectServicesPageState createState() => _SelectServicesPageState();
}

class _SelectServicesPageState extends State<SelectServicesPage>
    with SingleTickerProviderStateMixin {
  final Serviceselectioncontroller serviceselectioncontroller =
      Get.put(Serviceselectioncontroller());

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
                media: serviceselectioncontroller.carouselImages,
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
                            serviceselectioncontroller.skeletonColorAnimation)
                    : serviceselectioncontroller.filteredServices.isEmpty
                        ? const Center(
                            child: Text(
                              "No services available",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: serviceselectioncontroller
                                .filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = serviceselectioncontroller
                                  .filteredServices[index];
                              return Card(
                                elevation: 4,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.serviceName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            if (service.discount > 0) ...[
                                              Row(
                                                children: [
                                                  Text(
                                                    "${service.discount.toStringAsFixed(0)}% OFF",
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 30),
                                                  Text(
                                                    "₹${service.pricing.toStringAsFixed(0)}",
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            const SizedBox(height: 5),
                                            Text(
                                              "₹${service.discountedCost.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: mainColor,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            service.quantity > 0
                                                ? ElevatedButton.icon(
                                                    onPressed: () {
                                                      setState(() {
                                                        service.quantity = 0;
                                                        serviceselectioncontroller
                                                            .updateTotal();
                                                      });
                                                    },
                                                    label: const Text("Remove"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red.shade400,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            service.quantity++;
                                                            serviceselectioncontroller
                                                                .updateTotal();
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              mainColor,
                                                          foregroundColor:
                                                              Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 8),
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        child:
                                                            const Text("Add"),
                                                      ),
                                                      const SizedBox(width: 50),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10.0),
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ServiceDetailsPage(
                                                                  categoryName:
                                                                      service
                                                                          .categoryName,
                                                                  serviceId: service
                                                                      .serviceId,
                                                                  serviceName:
                                                                      service
                                                                          .serviceName,
                                                                  categoryId: widget
                                                                      .categoryId,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            side: BorderSide(
                                                                color:
                                                                    secondaryColor),
                                                            foregroundColor:
                                                                secondaryColor,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        8),
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                              "Info"),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                        child: AspectRatio(
                                          aspectRatio: 0.75,
                                          child: service.serviceImage != null &&
                                                  service
                                                      .serviceImage.isNotEmpty
                                              ? Image.memory(
                                                  service.serviceImage,
                                                  fit: BoxFit.fill,
                                                )
                                              : Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                      child: Text("No Image")),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: appGradient(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  serviceselectioncontroller.showAddedItemsAlert(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹ ${serviceselectioncontroller.totalPrice.value.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Added Items(${serviceselectioncontroller.totalItems.value})",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.5),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              TextButton(
                onPressed: serviceselectioncontroller.totalItems.value > 0
                    ? () => serviceselectioncontroller.navigateToConfirmation(
                          mobileNumber: widget.mobileNumber,
                          username: widget.username,
                          categoryId: widget.categoryId,
                          categoryName: widget.categoryName,
                        )
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "CONTINUE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
