import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Registration/RegisterController.dart';

class Patientdetailsformcontroller extends GetxController {
  String selectedFor = "Self";
  String selectedGender = "Male";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Registercontroller registercontroller = Registercontroller();
  final Color activeColor = Colors.green.shade900;
  final Color inactiveColor = Colors.transparent;
  final Color borderColor = Colors.green.shade300;
  final formKey = GlobalKey<FormState>();

  submitSchedule() {
    // showSnackbar("Success", "Form Validated out side", "success");
    if (formKey.currentState!.validate()) {
      showSnackbar("Success", "Form Validated", "success");
    }
  }
}
