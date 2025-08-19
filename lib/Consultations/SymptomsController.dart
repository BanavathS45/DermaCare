import 'dart:io';
import 'package:get/get.dart';

class SymptomsController extends GetxController {
  var symptoms = ''.obs;
  var duration = ''.obs;
  var visitType = ''.obs;
  var attachments = <File>[].obs;

  void updateSymptoms(String value) {
    symptoms.value = value;
  }

  void updateDuration(String value) {
    duration.value = value;
  }

  void updateVisitType(String value) {
    visitType.value = value;
  }

  void addAttachment(File file) {
    attachments.add(file);
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  void clearForm() {
    symptoms.value = '';
    duration.value = '';
    attachments.value = [];
  }
}
