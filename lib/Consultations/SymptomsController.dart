import 'dart:io';
import 'package:get/get.dart';

class SymptomsController extends GetxController {
  var symptoms = ''.obs;
  var attachment = Rx<File?>(null);

  void updateSymptoms(String value) {
    symptoms.value = value;
  }

  void updateAttachment(File file) {
    attachment.value = file;
  }

  void clearForm() {
    symptoms.value = '';
    attachment.value = null;
  }
}
