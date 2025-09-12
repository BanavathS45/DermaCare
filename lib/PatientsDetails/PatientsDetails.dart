// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cutomer_app/Inputs/CustomDropdownField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../Consultations/SymptomsController.dart';
import '../ConfirmBooking/ConsultationController.dart';
import '../Dashboard/GetCustomerData.dart';
import '../Inputs/CustomInputField.dart';
import '../Inputs/CustomTextAera.dart';
import '../Registration/RegisterController.dart';
import '../SigninSignUp/LoginController.dart';
import '../Utils/Constant.dart';
import 'PatientDetailsFormController.dart';

class PatientDetailsForm extends StatefulWidget {
  final String mobileNumber;
  final String username;
  const PatientDetailsForm({
    Key? key,
    required this.mobileNumber,
    required this.username,
  }) : super(key: key);

  @override
  State<PatientDetailsForm> createState() => _PatientDetailsFormState();
}

class _PatientDetailsFormState extends State<PatientDetailsForm> {
  final patientdetailsformcontroller = Get.put(Patientdetailsformcontroller());
  final SymptomsController controller = Get.put(SymptomsController());
  final registercontroller = Get.put(Registercontroller());
  final consultationController = Get.find<Consultationcontroller>();
  final SiginSignUpController siginSignUpController =
      Get.put(SiginSignUpController());
  final TextEditingController _durationController = TextEditingController();
  String? fullName;
  String? age;
  String? _selectedDurationType;
  final List<String> durationTypes = ["Hours", "Days", "Months", "Years"];
  @override
  void initState() {
    super.initState();
    getUserData();
    controller
        .updateDuration("${_durationController.text} ${_selectedDurationType}");
  }

  Future<void> getUserData() async {
    print("getUserData called");

    final userData = await fetchUserData(widget.mobileNumber);
    print("Fetched userData: $userData");

    if (userData != null && userData.dateOfBirth != null) {
      try {
        print("DOB exists: ${userData.dateOfBirth}");

        // Parse using custom format
        DateFormat formatter = DateFormat("dd-MM-yyyy");
        DateTime dob = formatter.parse(userData.dateOfBirth);

        int calculatedAge = _calculateAge(dob);
        print("Calculated Age: $calculatedAge");

        setState(() {
          fullName = userData.fullName;
          age = calculatedAge.toString();
          patientdetailsformcontroller.setAge(age ?? "0");
        });
      } catch (e) {
        print("Error parsing DOB: $e");
      }
    } else {
      print("No DOB available or userData is null");
    }
  }

  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Pick PDF files
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      for (var file in result.files) {
        if (file.path != null) {
          controller.addAttachment(File(file.path!));
        }
      }
    }
  }

  /// Pick images (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.gallery) {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null) {
        for (var pickedFile in pickedFiles) {
          controller.addAttachment(File(pickedFile.path));
        }
      }
    } else {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        controller.addAttachment(File(pickedFile.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Form(
      key: patientdetailsformcontroller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          /// Self / Someone toggle
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

          /// Name Field
          patientdetailsformcontroller.selectedFor == "Self"
              ? CustomTextField(
                  controller:
                      TextEditingController(text: fullName ?? widget.username),
                  labelText: 'Full Name (Self)',
                  readOnly: true,
                  enabled: false,
                )
              : CustomTextField(
                  controller: patientdetailsformcontroller.nameController,
                  labelText: 'Enter Full Name',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      siginSignUpController.validatedata(value, "full name"),
                ),

          /// Relation Field
          patientdetailsformcontroller.selectedFor == "Self"
              ? CustomTextField(
                  controller: TextEditingController(text: "Self"),
                  labelText: 'Relation',
                  enabled: false,
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButtonFormField<String>(
                    value: patientdetailsformcontroller
                            .relationController.text.isNotEmpty
                        ? patientdetailsformcontroller.relationController.text
                        : null,
                    items: [
                      'Father',
                      'Mother',
                      'Brother',
                      'Sister',
                      'Spouse',
                      'Child',
                    ].map((relation) {
                      return DropdownMenuItem<String>(
                        value: relation,
                        child: Text(
                          relation,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      patientdetailsformcontroller.relationController.text =
                          value ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Relation',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    validator: (value) =>
                        siginSignUpController.validatedata(value, "Relation"),
                  ),
                ),

          /// Mobile Number
          patientdetailsformcontroller.selectedFor == "Self"
              ? CustomTextField(
                  controller: TextEditingController(text: widget.mobileNumber),
                  labelText: 'Mobile Number (Self)',
                  readOnly: true,
                  enabled: false,
                )
              : CustomTextField(
                  controller: patientdetailsformcontroller.mobileController,
                  labelText: 'Enter Patient Mobile Number',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // validator: (value) =>
                  //     siginSignUpController.validatePhone(value),
                ),

          /// Age Field
          patientdetailsformcontroller.selectedFor == "Self"
              ? CustomTextField(
                  suffixText: "Yrs",
                  controller: TextEditingController(text: age),
                  labelText: 'Age (Self)',
                  readOnly: true,
                  enabled: false,
                )
              : CustomTextField(
                  suffixText: "Yrs",
                  controller: patientdetailsformcontroller.ageController,
                  labelText: 'Enter Age',
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) =>
                      siginSignUpController.validateAge(value),
                ),

          /// Address
          CustomTextField(
            controller: patientdetailsformcontroller.addressController,
            labelText: 'Enter Address',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter Address";
              }
              if (value.trim().length < 5) {
                return "Address must be at least 5 characters";
              }
              return null;
            },
          ),

          /// Gender selection
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Gender",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  children: registercontroller.genderOptions.map((gender) {
                    final isSelected =
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
                                color: isSelected
                                    ? mainColor
                                    : Colors.grey.shade400),
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
                                      : FontWeight.normal),
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
          // Divider(color: secondaryColor),

          /// Problem Section
          if (consultationController.selectedConsultation.value != null &&
              consultationController
                      .selectedConsultation.value!.consultationType
                      .toLowerCase() ==
                  "services & treatments") ...[
            Text("Describe your problem / Symptoms",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: CustomTextAera(
                controller: patientdetailsformcontroller.notesController,
                hintText:
                    "If you have any specific concerns to discuss before the procedure, please mention them here.",

                // Limit to 2 lines
                maxLines: 3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                labelText: 'Enter Symptoms',
                // validator: (value) {
                //   if (value == null || value.trim().isEmpty) {
                //     return "Please enter Problem";
                //   }
                //   if (value.trim().length < 10) {
                //     return "Problem must be at least 10 characters";
                //   }
                //   return null;
                // },
              ),
            ),

            const SizedBox(height: 15),
            Text("Symptoms Duration",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Row(
              children: [
                // Duration Number
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: "Duration",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Duration Type Dropdown
                Expanded(
                  child: CustomDropdownField<String>(
                    value: _selectedDurationType,
                    labelText: "Select Type",
                    items: durationTypes
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDurationType = val;
                        controller.updateDuration(
                            "${_durationController.text} ${_selectedDurationType}");
                      });
                    },
                  ),
                ),
              ],
            ),

            // CustomTextField(
            //   controller: patientdetailsformcontroller.durationController,
            //   labelText: 'Enter Duration (in days)',
            //   keyboardType: TextInputType.number,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   inputFormatters: [
            //     LengthLimitingTextInputFormatter(3),
            //     FilteringTextInputFormatter.digitsOnly,
            //   ],
            // ),
            const SizedBox(height: 15),

            /// Attachments
            Text("Attach document (Previous reports if any)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text("PDF"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  label: Text("Camera"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library, color: Colors.white),
                  label: Text("Gallery"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Attachments Preview
            Obx(() {
              final files = controller.attachments;
              if (files.isEmpty) {
                return Center(child: Text("No attachments selected"));
              }
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(files.length, (index) {
                  final file = files[index];
                  final isPDF = file.path.toLowerCase().endsWith('.pdf');

                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (isPDF) {
                            await OpenFilex.open(file.path);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(title: Text("Image Preview")),
                                  body: Center(
                                    child: InteractiveViewer(
                                      child: Image.file(file),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: isPDF
                            ? Container(
                                width: 140,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf,
                                        color: Colors.red, size: 30),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        file.path.split('/').last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(file, fit: BoxFit.cover),
                                ),
                              ),
                      ),
                      Positioned(
                        right: -5,
                        top: -5,
                        child: InkWell(
                          onTap: () => controller.removeAttachment(index),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              );
            }),
          ]
        ],
      ),
    );
  }
}
