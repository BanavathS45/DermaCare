// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ConfirmBooking/ConsultationController.dart';
import '../Inputs/CustomInputField.dart';
import '../Inputs/CustomTextAera.dart';
import '../Registration/RegisterController.dart';
import '../SigninSignUp/LoginController.dart';
import '../Utils/Constant.dart';
import 'PatientDetailsFormController.dart';

class PatientDetailsForm extends StatefulWidget {
  const PatientDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  State<PatientDetailsForm> createState() => _PatientDetailsFormState();
}

class _PatientDetailsFormState extends State<PatientDetailsForm> {
  final patientdetailsformcontroller = Get.put(Patientdetailsformcontroller());
  final registercontroller = Get.put(Registercontroller());
  SiginSignUpController siginSignUpController = SiginSignUpController();
  final consultationController = Get.find<Consultationcontroller>();
  @override
  void initState() {
    super.initState();
    // Add listener to update UI on typing
    patientdetailsformcontroller.notesController.addListener(() {
      if (patientdetailsformcontroller.formKey.currentState != null) {
        patientdetailsformcontroller.formKey.currentState!.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: patientdetailsformcontroller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Patient Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          // Self / Someone toggle
          Row(
            children: ["Self", "Someone"].map((option) {
              final isSelected =
                  patientdetailsformcontroller.selectedFor == option;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? patientdetailsformcontroller.activeColor
                        : patientdetailsformcontroller.inactiveColor,
                    side: BorderSide(
                        color: patientdetailsformcontroller.activeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() =>
                        patientdetailsformcontroller.selectedFor = option);
                  },
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : patientdetailsformcontroller.activeColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Name Field
          CustomTextField(
            controller: patientdetailsformcontroller.nameController,
            labelText: 'Enter Full Name',
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: (value) =>
                siginSignUpController.validatedata(value, "full name"),
          ),

          // Age Field
          CustomTextField(
            controller: patientdetailsformcontroller.ageController,
            labelText: 'Enter Age',
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUnfocus,
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) => siginSignUpController.validateAge(value),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gender',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: registercontroller.genderOptions.map((gender) {
                    final bool isSelected =
                        registercontroller.selectedGender == gender;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            registercontroller.selectedGender = gender;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? mainColor : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected ? mainColor : Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              gender,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: secondaryColor),

          // Notes textarea
          const SizedBox(height: 16),
          if (consultationController
                  .selectedConsultation.value!.consultationType
                  .toLowerCase() ==
              "services & treatments")
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Describe your problem",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextAera(
                    controller: patientdetailsformcontroller.notesController,
                    labelText: "Enter Your problem....",
                    autovalidateMode: AutovalidateMode
                        .onUserInteraction, // ✅ Real-time validation
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Problem";
                      }
                      if (value.trim().length < 10) {
                        return "Problem must be at least 10 characters";
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
