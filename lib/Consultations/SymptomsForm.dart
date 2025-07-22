import 'dart:io';
import 'package:cutomer_app/Consultations/SymptomsController.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../ConfirmBooking/ConsultationPrice.dart';
import '../Doctors/ListOfDoctors/ConsuationDoctors.dart';

class SymptomsForm extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final String consulationType;

  const SymptomsForm(
      {super.key,
      required this.mobileNumber,
      required this.username,
      required this.consulationType});
  @override
  State<SymptomsForm> createState() => _SymptomsFormState();
}

class _SymptomsFormState extends State<SymptomsForm> {
  final SymptomsController controller = Get.put(SymptomsController());
  final TextEditingController _textController = TextEditingController();

  String? errorText;
  int charCount = 0;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );
    if (result != null && result.files.single.path != null) {
      controller.updateAttachment(File(result.files.single.path!));
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      controller.updateAttachment(File(pickedFile.path));
    }
  }

  void _onSubmit() {
    final text = _textController.text.trim();
    final length = text.length;

    if (length == 0) {
      setState(() => errorText = "Symptoms field is required.");
      return;
    }
    if (length < 20) {
      setState(() => errorText = "Minimum 20 characters required.");
      return;
    }
    if (length > 1000) {
      setState(() => errorText = "Maximum 1000 characters allowed.");
      return;
    }

    // Save and Clear
    controller.updateSymptoms(text);
    print("Symptoms: ${controller.symptoms.value}");
    print("Attachment: ${controller.attachment.value?.path}");

    // controller.clearForm();

    setState(() {
      charCount = 0;
      errorText = null;
    });
    Get.to(ConsultationPrice(
      mobileNumber: widget.mobileNumber,
      username: widget.consulationType,
      consulationType: widget.consulationType,
      subserviceName: 'PRP Injection Procedure',
      subserviceid: '687b91e50ce982692fd1aeb2',
      serviceId: '687b91540ce982692fd1aeb0',
      categoryId: '687b90d80ce982692fd1aeae',
      serviceName: 'PRP Therapy',
      categoryName: 'Hair Treatments',
    ));
    // Get.snackbar("Submitted", "Appointment form submitted successfully");
  }

  @override
  void dispose() {
    Get.delete<SymptomsController>(); // This clears controller on back
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Symptoms & Attachment"),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF1F1F1), // light background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Consultation Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.consulationType,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter your symptoms",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      maxLength: 1000,
                      decoration: InputDecoration(
                        labelText: "Symptoms",
                        border: OutlineInputBorder(),
                        errorText: errorText,
                        counterText: "${charCount}/1000 characters",
                      ),
                      onChanged: (val) {
                        setState(() {
                          charCount = val.length;
                          errorText = null;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    Text("Attach any document",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                          label: Text("PDF"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: Icon(Icons.camera_alt, color: Colors.black),
                          label: Text("Camera"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: Icon(Icons.photo_library, color: Colors.green),
                          label: Text("Gallery"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Obx(() {
                        final file = controller.attachment.value;
                        if (file == null) return Text("No attachment selected");

                        final isPDF = file.path.toLowerCase().endsWith('.pdf');
                        return isPDF
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf,
                                      color: Colors.red, size: 30),
                                  SizedBox(width: 8),
                                  Text(
                                    file.path.split('/').last,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(file, fit: BoxFit.cover),
                                ),
                              );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text("Submit", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
