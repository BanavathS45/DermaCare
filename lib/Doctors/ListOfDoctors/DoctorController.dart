import 'package:get/get.dart';
import 'DoctorModel.dart';
import 'DoctorService.dart';

class Doctorcontroller extends GetxController {
  DoctorService doctorService = DoctorService();
  RxList<HospitalDoctorModel> allDoctors = <HospitalDoctorModel>[].obs;
  RxList<HospitalDoctorModel> filteredDoctors = <HospitalDoctorModel>[].obs;

  RxString selectedGender = 'All'.obs;
  RxString selectedCity = 'All'.obs;
  RxBool showFavoritesOnly = false.obs;
  RxBool sortByAZ = false.obs;
  RxDouble selectedRating = 0.0.obs;

  RxList<String> cityList = <String>[].obs;
  RxString doctorId = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  setDoctorId(String DoctorId) {
    doctorId.value = DoctorId;
  }

  Future<void> fetchDoctors() async {
    print("iam calling from fetchDoctors:  "); // 👈 Add this

    try {
      final doctors = await doctorService.fetchDoctorAndHospital();
      print("Total Doctors fetched: ${doctors.length}"); // 👈 Add this
      allDoctors.value = doctors;

      final cities = doctors.map((e) => e.hospital.city).toSet().toList();
      cityList.value = ['All', ...cities];

      applyFilters();
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  var isLoading = false.obs;

  void refreshDoctors() async {
    isLoading.value = true;
    await fetchDoctors();
    isLoading.value = false;
  }

  void toggleFavorite(HospitalDoctorModel doctor) {
    doctor.doctor.favorites = !doctor.doctor.favorites;
    allDoctors.refresh();
    applyFilters();
  }

  void applyFilters() {
    List<HospitalDoctorModel> filtered = List.from(allDoctors);

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
}
