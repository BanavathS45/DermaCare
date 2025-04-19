import 'package:get/get.dart';

class Appointmentcontroller extends GetxController {
  RxInt bookingLength = 0.obs;
  void setBookingLength(int id) {
    bookingLength.value = id;
    print("bookingLength ${bookingLength}");
  }
}
