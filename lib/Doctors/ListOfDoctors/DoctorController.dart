import 'package:get/get.dart';
import 'DoctorModel.dart';
import 'DoctorService.dart';

class DoctorController extends GetxController {
  final DoctorService doctorService = DoctorService();

  RxList<ServiceModel> allServices = <ServiceModel>[].obs;
  RxList<HospitalDoctorModel> allDoctorsFlat = <HospitalDoctorModel>[].obs;
  RxList<HospitalDoctorModel> filteredDoctors = <HospitalDoctorModel>[].obs;
  RxInt appointmentCount = 0.obs;

  RxString selectedGender = 'All'.obs;
  RxString selectedCity = 'All'.obs;
  RxBool showFavoritesOnly = false.obs;
  RxBool sortByAZ = false.obs;
  RxDouble selectedRating = 0.0.obs;

  RxList<String> cityList = <String>[].obs;
  RxString doctorId = "".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchDoctors(); // ✅ Only fetch if not already loaded
  }

  void setDoctorId(String id) async {
    doctorId.value = id;

    final doctor = await doctorService.getDoctorById(id);
    if (doctor != null) {
      // ✅ Example: Update appointmentCount based on doctor logic
      appointmentCount.value = doctor.doctor.bookingSlots.length;
    }
  }

  Future<void> fetchDoctors() async {
    print("🌀 Fetching doctors from API...");

    try {
      isLoading.value = true;

      final services = await doctorService.fetchServices();
      allServices.value = services;

      final List<HospitalDoctorModel> extractedDoctors = [];

      for (var service in services) {
        for (var hospital in service.hospitals) {
          for (var doctor in hospital.doctors) {
            extractedDoctors.add(doctor);
          }
        }
      }

      allDoctorsFlat.value = extractedDoctors;

      // Get unique cities
      final cities =
          extractedDoctors.map((d) => d.hospital.city).toSet().toList();
      cityList.value = ['All', ...cities];

      applyFilters();
    } catch (e) {
      print("❌ Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(HospitalDoctorModel doctorModel) {
    doctorModel.doctor.favorites = !doctorModel.doctor.favorites;
    allDoctorsFlat.refresh();
    applyFilters();
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

    if (showFavoritesOnly.value) {
      filtered = filtered.where((d) => d.doctor.favorites).toList();
    }

    if (selectedRating.value > 0.0) {
      filtered = filtered
          .where((d) => d.doctor.overallRating >= selectedRating.value)
          .toList();
    }

    if (sortByAZ.value) {
      filtered.sort((a, b) => a.doctor.name.compareTo(b.doctor.name));
    }

    filteredDoctors.value = filtered;
  }

  void refreshDoctors() async {
    isLoading.value = true;
    await fetchDoctors();
    isLoading.value = false;
  }
}
