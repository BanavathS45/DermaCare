import 'package:cutomer_app/Booings/BooingService.dart';
import 'package:cutomer_app/Dashboard/DashBoardController.dart';
import 'package:get/get.dart';
import '../../BottomNavigation/Appoinments/PostBooingModel.dart';

class AppointmentController extends GetxController {
  final RxList<PostBookingModel> doctorBookings = <PostBookingModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedTab = 'UPCOMING'.obs;

  final RxInt upcomingCountRx = 0.obs;
  final RxInt videoConsultationCountRx = 0.obs;
  final RxList<PostBookingModel> inProgressBookings =
      <PostBookingModel>[].obs; // 👈 Add this

  final dashboardcontroller =
      Get.find<Dashboardcontroller>(); // 👈 Access global mobile number

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final mobileNumber = dashboardcontroller.mobileNumber.value.trim();
    if (mobileNumber.isEmpty) return; // Safety check

    isLoading.value = true;
    try {
      final bookingsJson = await getBookingsByMobileNumber(mobileNumber);
      if (bookingsJson != null && bookingsJson is List) {
        doctorBookings.assignAll(
          bookingsJson.map((e) => PostBookingModel.fromJson(e)).toList(),
        );

        print("bookingsJsonbookingsJson${bookingsJson}");

        // Update counts
        upcomingCountRx.value = doctorBookings.where((b) {
          final status = b.booking.status.toLowerCase();
          final consultationType = b.booking.consultationType.toLowerCase();
          return (status == 'pending' || status == 'confirmed') &&
              consultationType != 'online consultation';
        }).length;

        videoConsultationCountRx.value = doctorBookings.where((b) {
          final type = b.booking.consultationType.trim().toLowerCase();
          final status = b.booking.status.trim().toLowerCase();
          return type == 'online consultation' && status != 'completed';
        }).length;

        inProgressBookings.assignAll(doctorBookings.where((b) {
          final status = b.booking.status.toLowerCase();
          
          return status == 'in_progress';
        }).toList());

      
      } else {
        doctorBookings.clear();
        upcomingCountRx.value = 0;
        videoConsultationCountRx.value = 0;
      }
    } catch (e) {
      print("❌ Error fetching bookings: $e");
      doctorBookings.clear();
      upcomingCountRx.value = 0;
      videoConsultationCountRx.value = 0;
    }
    isLoading.value = false;
  }

  List<PostBookingModel> get filteredBookings {
    if (selectedTab.value == 'UPCOMING') {
      return doctorBookings.where((b) {
        final status = b.booking.status.toLowerCase();
        final consultationType = b.booking.consultationType.toLowerCase();
        return (status == 'pending' ||
                status == 'confirmed' ||
                status == "in_progress" ||
                status == 'rejected') &&
            consultationType != 'online consultation';
      }).toList();
    } else if (selectedTab.value == 'COMPLETED') {
      return doctorBookings
          .where((b) => b.booking.status.toLowerCase() == 'completed')
          .toList();
    } else {
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
