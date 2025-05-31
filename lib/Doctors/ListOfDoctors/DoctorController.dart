// import 'package:cutomer_app/Controller/CustomerController.dart';
// import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'DoctorService.dart';

// class DoctorController extends GetxController {
//   final DoctorService doctorService = DoctorService();

//   RxList<HospitalDoctorModel> allServices = <HospitalDoctorModel>[].obs;
//   RxList<HospitalDoctorModel> allDoctorsFlat = <HospitalDoctorModel>[].obs;
//   RxList<HospitalDoctorModel> filteredDoctors = <HospitalDoctorModel>[].obs;
//   RxInt appointmentCount = 0.obs;

//   RxString selectedGender = 'All'.obs;
//   RxString selectedCity = 'All'.obs;
//   RxBool selectedRecommended = false.obs; // ✅ RxBool

//   RxBool showFavoritesOnly = false.obs;
//   RxBool sortByAZ = false.obs;
//   RxDouble selectedRating = 0.0.obs;

//   RxList<String> cityList = <String>[].obs;
//   RxString doctorId = "".obs;
//   RxBool isLoading = false.obs;
//   RxString hospitalId = ''.obs;

//   // final selectedServicesController = Get.find<SelectedServicesController>();
//   // final selectedServicesController = Get.put(SelectedServicesController());
//   late final selectedServicesController =
//       Get.find<SelectedServicesController>();
//   @override
//   void onInit() {
//     super.onInit();

//     // fetchDoctors();
//     // ✅ Only fetch if not already loaded
//   }

//   // void setDoctorId(String id) async {
//   //   doctorId.value = id;

//   //   final doctor = await doctorService.getDoctorById(id, "");
//   //   if (doctor != null) {
//   //     // ✅ Example: Update appointmentCount based on doctor logic
//   //     appointmentCount.value = doctor.doctor.bookingSlots.length;
//   //   }
//   // }

//   Future<void> fetchDoctors(
//       {required String hospitalId, required String subServiceId}) async {
//     print("🌀 Fetching doctors from API...");

//     try {
//       isLoading.value = true;

//       final hospitalIdToUse = selectedServicesController.hospitalId.value;
//       print("🏥 Using hospitalId: $hospitalIdToUse");

//       final services =
//           await doctorService.fetchDoctorsAndClinic(hospitalId, subServiceId);
//       allServices.value = services;

//       final List<HospitalDoctorModel> extractedDoctors = [];

//       final List<HospitalDoctorModel> doctors =
//           await doctorService.fetchDoctorsAndClinic(hospitalId, subServiceId);

//       allDoctorsFlat.value = doctors;

// // You can still get cityList from doctor.hospital
//       final cities = doctors.map((d) => d.hospital.city).toSet().toList();
//       cityList.value = ['All', ...cities];

//       applyFilters();

//       allDoctorsFlat.value = extractedDoctors;

//       // Get unique cities
//       // final cities =
//       //     extractedDoctors.map((d) => d.hospital.city).toSet().toList();
//       // cityList.value = ['All', ...cities];

//       applyFilters();
//     } catch (e) {
//       print("❌ Fetch error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // void toggleFavorite(HospitalDoctorModel doctorModel) {
//   //   doctorModel.doctor. = !doctorModel.doctor.favorites;
//   //   allDoctorsFlat.refresh();
//   //   applyFilters();
//   // }

//   void applyFilters() {
//     List<HospitalDoctorModel> filtered = List.from(allDoctorsFlat);

//     if (selectedGender.value != 'All') {
//       filtered = filtered
//           .where((d) => d.doctor.gender == selectedGender.value)
//           .toList();
//     }

//     if (selectedCity.value != 'All') {
//       filtered =
//           filtered.where((d) => d.hospital.city == selectedCity.value).toList();
//     }
//     if (selectedRecommended.value) {
//       filtered = filtered.where((d) => d.hospital.recommended == true).toList();
//     }

//     // if (showFavoritesOnly.value) {
//     //   filtered = filtered.where((d) => d.doctor.favorites).toList();
//     // }

//     // if (selectedRating.value > 0.0) {
//     //   filtered = filtered
//     //       .where((d) => d.doctor.overallRating >= selectedRating.value)
//     //       .toList();
//     // }

//     if (sortByAZ.value) {
//       filtered
//           .sort((a, b) => a.doctor.doctorName.compareTo(b.doctor.doctorName));
//     }

//     filteredDoctors.value = filtered;
//   }

//   void refreshDoctors({required String subServiceId}) async {
//     isLoading.value = true;
//     await fetchDoctors(
//         hospitalId: hospitalId.value, subServiceId: subServiceId);
//     isLoading.value = false;
//   }
// }

import 'package:cutomer_app/Controller/CustomerController.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DoctorService.dart';

class DoctorController extends GetxController {
  final DoctorService doctorService = DoctorService();

  RxList<HospitalDoctorModel> allServices = <HospitalDoctorModel>[].obs;
  RxList<HospitalDoctorModel> allDoctorsFlat = <HospitalDoctorModel>[].obs;
  RxList<HospitalDoctorModel> filteredDoctors = <HospitalDoctorModel>[].obs;
  RxInt appointmentCount = 0.obs;

  RxString selectedGender = 'All'.obs;
  RxString selectedCity = 'All'.obs;
  RxBool selectedRecommended = false.obs;

  RxBool showFavoritesOnly = false.obs;
  RxBool sortByAZ = false.obs;
  RxDouble selectedRating = 0.0.obs;

  RxList<String> cityList = <String>[].obs;
  RxString doctorId = "".obs;
  RxBool isLoading = false.obs;
  RxString hospitalId = ''.obs;

  late final selectedServicesController =
      Get.find<SelectedServicesController>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchDoctors({
    required String hospitalId,
    required String subServiceId,
  }) async {
    print("🌀 Fetching doctors from API...");

    try {
      isLoading.value = true;

      final hospitalIdToUse = selectedServicesController.hospitalId.value;
      print("🏥 Using hospitalId: $hospitalIdToUse");

      final List<HospitalDoctorModel> doctors =
          await doctorService.fetchDoctorsAndClinic(hospitalId, subServiceId);

      allDoctorsFlat.value = doctors;
      allServices.value = doctors;

      for (var d in doctors) {
        print(
            "✅ Doctor loaded: ${d.doctor.doctorName}, ${d.doctor.qualification}");
      }

      final cities = doctors.map((d) => d.hospital.city).toSet().toList();
      cityList.value = ['All', ...cities];

      applyFilters();
    } catch (e) {
      print("❌ Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<HospitalDoctorModel> filtered = List.from(allDoctorsFlat);

    if (selectedGender.value != 'All') {
      filtered = filtered
          .where((d) => d.doctor.gender == selectedGender.value)
          .toList();
    }

    if (selectedCity.value != 'All') {
      filtered =
          filtered.where((d) => d.hospital.city == selectedCity.value).toList();
    }

    if (selectedRecommended.value) {
      filtered = filtered.where((d) => d.hospital.recommended == true).toList();
    }

    if (sortByAZ.value) {
      filtered
          .sort((a, b) => a.doctor.doctorName.compareTo(b.doctor.doctorName));
    }

    filteredDoctors.value = filtered;
  }

  void refreshDoctors({required String subServiceId}) async {
    isLoading.value = true;
    await fetchDoctors(
        hospitalId: hospitalId.value, subServiceId: subServiceId);
    isLoading.value = false;
  }
}
