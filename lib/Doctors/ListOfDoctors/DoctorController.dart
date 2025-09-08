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
import 'package:cutomer_app/Doctors/RatingAndFeedback/RatingService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DoctorService.dart';

class DoctorController extends GetxController {
  final DoctorService doctorService = DoctorService();

  RxList<HospitalDoctorModel> allServices = <HospitalDoctorModel>[].obs;
  RxList<HospitalDoctorModel> allDoctorsFlat = <HospitalDoctorModel>[].obs;
  RxList<HospitalDoctorModel> filteredDoctors = <HospitalDoctorModel>[].obs;
  RxInt appointmentCount = 0.obs;

  // For doctor rating and number of comments
// RxDouble overallDoctorRating = 0.0.obs;
// RxInt commentCount = 0.obs;
  RxMap<String, double> doctorRatings = <String, double>{}.obs;
  RxMap<String, int> doctorCommentCounts = <String, int>{}.obs;

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
      print("🏥 Using hospitalId hospitalId: $hospitalId");
      print("🏥 Using hospitalId subServiceId: $subServiceId");

      final List<HospitalDoctorModel> doctors =
          await doctorService.fetchDoctorsAndClinic(hospitalId, subServiceId);
      print("🏥 Using hospitalId doctors: ${doctors.first.hospital.branches}");

      allDoctorsFlat.value = doctors;
      allServices.value = doctors;

      for (var d in doctors) {
        print(
            "✅ Doctor loaded: ${d.doctor.doctorName}, ${d.hospital.recommended},${d.hospital.branches},${d.hospital.consultationExpiration}");
      }
      List<Future<void>> ratingFutures = [];
      for (var doctorModel in doctors) {
        final dId = doctorModel.doctor.doctorId;
        final hId = doctorModel.hospital.hospitalId;

        // Wrap in a Future<void> to collect them
        final future = fetchAndSetRatingSummary(hId, dId).then((rating) {
          doctorRatings[dId] = rating.overallDoctorRating;
          doctorCommentCounts[dId] = rating.comments.length;
        }).catchError((e) {
          print("⚠️ Failed to fetch rating for $dId: $e");
        });

        ratingFutures.add(future);
      }

      await Future.wait(ratingFutures); // ✅ Wait for all ratings to complete

      final cities = doctors.map((d) => d.hospital.city).toSet().toList();
      print("🏥 Using hospitalId doctors: ${cities}");

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

    // 🔥 Rating filter
    if (selectedRating.value > 0.0) {
      filtered = filtered.where((d) {
        final rating = doctorRatings[d.doctor.doctorId] ?? 0.0;
        return rating >= selectedRating.value;
      }).toList();
    }

    if (sortByAZ.value) {
      filtered
          .sort((a, b) => a.doctor.doctorName.compareTo(b.doctor.doctorName));
    }

    filteredDoctors.value = filtered;
  }

  Future<void> refreshDoctors({required String subServiceId}) async {
    try {
      isLoading.value = true;
      await fetchDoctors(
        hospitalId: hospitalId.value,
        subServiceId: subServiceId,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
