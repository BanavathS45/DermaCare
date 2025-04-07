import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../APIs/FetchServices.dart';
import '../Controller/CustomerController.dart';
import '../Doctors/ListOfDoctors/DoctorScreen.dart';
import '../Modals/ServiceModal.dart';
import '../Services/CarouselSliderService.dart';

class Serviceselectioncontroller extends GetxController {
  // RxInt totalItems = 0.obs;

  // RxDouble totalPrice = 0.0.obs;

  late AnimationController animationController;
  late Animation<Color?> skeletonColorAnimation;
  final CarouselSliderService carouselSliderService = CarouselSliderService();
  bool iamgeloading = true;
  List<String> carouselImages = [];

  final ServiceFetcher serviceFetcher = ServiceFetcher();
  TextEditingController searchController = TextEditingController();

  final RxList<Service> services = <Service>[].obs;
  final RxList<Service> filteredServices = <Service>[].obs;

  final RxBool isLoading = true.obs;

  fetchImages() async {
    iamgeloading = true;

    try {
      final images =
          await carouselSliderService.fetchServiceImages(); // Fetch images

      carouselImages = images;
      iamgeloading = false; // Set loading to false after images are fetched

      print("carouselImages images${carouselImages}");
    } catch (e) {
      print("Error fetching images: $e");

      iamgeloading = false; // Set loading to false even if there's an error
    }
  }

  @override
  void dispose() {
    searchController.removeListener(updateSuggestions);
    searchController.dispose();
    super.dispose();
    animationController.dispose();
  }

  Future<void> fetchServices(String categoryId) async {
    final fetchedServices = await serviceFetcher.fetchServices(categoryId);

    services.assignAll(fetchedServices); // ✅ Fix
    filteredServices.assignAll(fetchedServices); // ✅ Fix

    isLoading.value = false;
  }

  void filterServices(String query) {
    // Your logic to filter services based on query
    final results = services
        .where((service) =>
            service.serviceName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    filteredServices.assignAll(results); // Assuming you're using RxList
  }

  RxInt totalItems = 0.obs;
  RxDouble totalPrice = 0.0.obs;

  void updateTotal() {
    totalItems.value = services.where((s) => s.quantity > 0).length;
    totalPrice.value = services.fold(
      0.0,
      (sum, s) => sum + s.discountedCost * s.quantity,
    );
  }


  void navigateToConfirmation(
      {String? mobileNumber,
      String? username,
      String? categoryId,
      String? categoryName}) async {
    try {
      // Fetch the first address
      // AddressModel? firstAddress =
      //     await fetchFirstAddress.fetchFirstAddress(mobileNumber!); 

      
        // Use the instance of the SelectedServicesController to update selected services
        List<Service> selectedServices =
            services.where((service) => service.quantity > 0).toList();

        final selectedServicesController =
            Get.find<SelectedServicesController>();
        selectedServicesController.updateSelectedServices(selectedServices);
        selectedServicesController.categoryId.value = categoryId!;
        selectedServicesController.categoryName.value = categoryName!;

        // Navigate to PatientDetailScreen with the first address

        Get.to(() => Doctorscreen(
              mobileNumber: mobileNumber!,
              username: username!,
            ));
    
    } catch (e) {
      print('Error fetching address: $e');
      // Handle error
    }
  }

  void showAddedItemsAlert(BuildContext context) {
    List<Service> selectedServices =
        services.where((service) => service.quantity > 0).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selected Services',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B3FA0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  selectedServices.isEmpty
                      ? const Center(
                          child: Text(
                            "No services selected yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: selectedServices.length,
                            itemBuilder: (context, index) {
                              final service = selectedServices[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                leading: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: service.serviceImage != null
                                      ? Image.memory(
                                          service.serviceImage as Uint8List,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        )
                                      : Container(
                                          color: Colors.grey,
                                          child: const Center(
                                              child:
                                                  Text('Image not available')),
                                        ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.serviceName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₹ ${service.discountedCost.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 146, 150, 147)),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setModalState(() {
                                        service.quantity = 0; // Reset quantity
                                        selectedServices
                                            .removeAt(index); // Remove item
                                      });

                                      updateTotal(); // Recalculate total
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void clearSearch() {
    searchController.clear(); // Clear the search text field
    filteredServices.assignAll(services); // ✅ Fix
  }

  void updateSuggestions() {
    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredServices.value = services
          .where((service) => service.serviceName.toLowerCase().contains(query))
          .toList();
    } else {
      filteredServices.assignAll(services); // ✅ Fix
    }
  }

  onRefresh(String categoryId) async {
    await fetchServices(categoryId);
    updateTotal();
  }
}
