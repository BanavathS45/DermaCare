import 'package:cutomer_app/Booings/BooingService.dart';
import 'package:cutomer_app/Dashboard/DashBoardController.dart';
import 'package:get/get.dart';
import '../../BottomNavigation/Appoinments/PostBooingModel.dart';
import 'AppointmentService.dart';
import 'GetAppointmentModel.dart';

class AppointmentController extends GetxController {
  final RxList<Getappointmentmodel> doctorBookings =
      <Getappointmentmodel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedTab = 'UPCOMING'.obs;

  final RxInt upcomingCountRx = 0.obs;
  final RxInt videoConsultationCountRx = 0.obs;
  final RxList<Getappointmentmodel> inProgressBookings =
      <Getappointmentmodel>[].obs; // 👈 Add this
  final AppointmentService appointmentService = AppointmentService();
  final dashboardcontroller =
      Get.find<Dashboardcontroller>(); // 👈 Access global mobile number

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final mobileNumber = dashboardcontroller.mobileNumber.value.trim();
    if (mobileNumber.isEmpty) return;

    isLoading.value = true;

    try {
      final List<Getappointmentmodel> response =
          await appointmentService.fetchAppointments(mobileNumber);

      print("📥 Bookings fetched: ${response.length}");

      if (response.isNotEmpty) {
        doctorBookings.assignAll(response);
        print("🩺 Bookings assigned: ${doctorBookings.length}");

        // Calculate counts...
        upcomingCountRx.value = doctorBookings.where((b) {
          final status = b.status.toLowerCase();
          final consultationType = b.consultationType.toLowerCase();
          return (status == 'pending' || status == 'confirmed') &&
              consultationType != 'online consultation';
        }).length;

        videoConsultationCountRx.value = doctorBookings.where((b) {
          final type = b.consultationType.trim().toLowerCase();
          final status = b.status.trim().toLowerCase();
          return type == 'online consultation' && status != 'completed';
        }).length;

        inProgressBookings.assignAll(
          doctorBookings
              .where((b) => b.status.toLowerCase() == 'in_progress')
              .toList(),
        );
      } else {
        doctorBookings.clear();
        upcomingCountRx.value = 0;
        videoConsultationCountRx.value = 0;
      }
    } catch (e) {
      print("❌ Error in fetchBookings(): $e");
      doctorBookings.clear();
      upcomingCountRx.value = 0;
      videoConsultationCountRx.value = 0;
    } finally {
      // Always stop loader
      isLoading.value = false;
      print("🔁 isLoading set to false");
    }
  }

  List<Getappointmentmodel> get filteredBookings {
    print("🔍 Selected Tab: ${selectedTab.value}");
    print("📋 Total doctorBookings: ${doctorBookings.length}");

    if (selectedTab.value == 'UPCOMING') {
      final filtered = doctorBookings.where((b) {
        final status = b.status.toLowerCase().trim();
        final consultationType = b.consultationType.toLowerCase().trim();
        final isMatch = (status == 'pending' ||
                status == 'confirmed' ||
                status == 'in_progress' ||
                status == 'rejected') &&
            consultationType != 'online consultation';

        print("🧪 Checking Booking ID: ${b.bookingId}, Status: $status, "
            "Type: $consultationType => Match: $isMatch");

        return isMatch;
      }).toList();

      print("✅ Filtered UPCOMING bookings count: ${filtered.length}");
      return filtered;
    } else if (selectedTab.value == 'COMPLETED') {
      final filtered = doctorBookings
          .where((b) => b.status.toLowerCase().trim() == 'completed')
          .toList();

      print("✅ Filtered COMPLETED bookings count: ${filtered.length}");
      return filtered;
    } else {
      print("📤 Returning all bookings");
      return doctorBookings;
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> refreshBookings() async {
    await fetchBookings(); // 👈 Mobile number is fetched internally
  }
}
