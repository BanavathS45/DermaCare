import 'package:get/get.dart';

class Consultationcontroller extends GetxController {
  RxString consultationId = ''.obs;

  void setConsultationId(String id) {
    consultationId.value = id;
  }
}
