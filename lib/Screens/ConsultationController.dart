import 'package:cutomer_app/AddPatient/AddPatientOther.dart';
import 'package:get/get.dart';

class Consultationcontroller extends GetxController {
  RxInt consultationId = 0.obs;

  void setConsultationId(int id) {
    consultationId.value = id;
  }

  int get getConsultationId => consultationId.value;
}
