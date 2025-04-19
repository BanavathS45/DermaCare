import 'package:cutomer_app/ConfirmBooking/ConsultationServices.dart';
import 'package:get/get.dart';

class Consultationcontroller extends GetxController {
  Rx<ConsultationModel?> selectedConsultation = Rx<ConsultationModel?>(null);

  void setConsultation(ConsultationModel consultation) {
    selectedConsultation.value = consultation;
  }
}
