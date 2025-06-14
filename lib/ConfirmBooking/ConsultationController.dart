import 'package:cutomer_app/ConfirmBooking/ConsultationServices.dart';
import 'package:get/get.dart';

class Consultationcontroller extends GetxController {
  Rx<ConsultationModel?> selectedConsultation = Rx<ConsultationModel?>(null);

  void setConsultation(ConsultationModel consultation) {
    selectedConsultation.value = consultation;
    print("✅ Consultation set: ${consultation.consultationType}");
  }

  // ✅ Method to clear the selected consultation with print
  void clear() {
    print("🧹 Clearing selected consultation...");
    selectedConsultation.value = null;
    print("✅ selectedConsultation cleared: ${selectedConsultation.value}");
  }
}
