import 'dart:io';
import 'package:get/get.dart';

class SymptomsController extends GetxController {
  var symptoms = ''.obs;
  var duration = ''.obs;
  var visitType = ''.obs;
  var attachment = Rx<File?>(null);

  void updateSymptoms(String value) {
    symptoms.value = value;
  }
   void updateDuration(String value) {
    duration.value = value;
  }
    void updateVisitType(String value) {
    visitType.value = value;
  }

  void updateAttachment(File file) {
    attachment.value = file;
  }

  void clearForm() {
    symptoms.value = '';
    duration.value = '';
    attachment.value = null;
  }
}
