import 'dart:convert';
import 'dart:typed_data';
import 'package:cutomer_app/ConfirmBooking/ConfirmBookingDetails.dart';
import 'package:cutomer_app/Controller/CustomerController.dart';
import 'package:cutomer_app/Doctors/Schedules/ConsentFormAPI.dart';
import 'package:cutomer_app/Doctors/Schedules/ConsentFromModal.dart';
import 'package:cutomer_app/Help/Numbers.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/SavePdfToDownloads.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signature/signature.dart';

import 'package:cutomer_app/PatientsDetails/PatientModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ListOfDoctors/HospitalAndDoctorModel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SkinCareConsentFormScreen extends StatefulWidget {
  final HospitalDoctorModel doctor;
  final PatientModel patient;
  const SkinCareConsentFormScreen({
    Key? key,
    required this.doctor,
    required this.patient,
  }) : super(key: key);

  @override
  State<SkinCareConsentFormScreen> createState() =>
      _SkinCareConsentFormScreenState();
}

class _SkinCareConsentFormScreenState extends State<SkinCareConsentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final SignatureController _patientSignController;
  // final SignatureController patientSignController = SignatureController();
  DateTime _procedureDate = DateTime.now();
  final selectedServicesController = Get.find<SelectedServicesController>();
  // consent points

  final Map<String, bool> _consentPoints = {
    "I have read and understand the information": true,
    "I consent to the procedure": true,
    "I consent to the use of my data": true,
    "I agree to receive follow-up communications": true,
  };

  bool _agreed = false;
  bool _signatureSaved = false;
  Uint8List? _pdfBytes;
  bool _patientSigned = false;
  Map<String, dynamic>? consentFormData;

  @override
  void initState() {
    super.initState();
    _patientSignController = SignatureController(penStrokeWidth: 2);
    fetchConsentForm();
  }

  @override
  void dispose() {
    _patientSignController.dispose();
    super.dispose();
  }

  void _openQuestions() {
    // Navigate to your Questions page or show a dialog
    print('Questions button clicked');
  }

  // Future<void> _openPatientSignSheet() async {
  //   await showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
  //     builder: (ctx) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
  //           left: 16,
  //           right: 16,
  //           top: 16,
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text("Patient Signature",
  //                   style: TextStyle(fontWeight: FontWeight.w600)),
  //               const SizedBox(height: 12),
  //               AspectRatio(
  //                 aspectRatio: 3.5,
  //                 child: DecoratedBox(
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.grey.shade400),
  //                     color: Colors.white,
  //                   ),
  //                   child: Signature(
  //                     controller: patientSignController,
  //                     backgroundColor: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               Row(
  //                 children: [
  //                   TextButton(
  //                       onPressed: () => _patientSignController.clear(),
  //                       child: const Text("Clear")),
  //                   const Spacer(),
  //                   FilledButton(
  //                     onPressed: () async {
  //                       final data = await _patientSignController.toPngBytes();
  //                       if (data != null) {
  //                         final pdf =
  //                             await _buildPdf(); // generate PDF immediately
  //                         setState(() {
  //                           _patientSigned = true;
  //                           _signatureSaved = true;
  //                           _pdfBytes = pdf;
  //                         });
  //                         Navigator.pop(context); // close sheet
  //                       }
  //                     },
  //                     child: const Text("Save"),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

// Utility
  Uint8List? decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;

    // Remove "data:image/png;base64," if present
    final cleaned = base64String.split(',').last;
    return base64Decode(cleaned);
  }

  final consentFormService = ConsentFormService();

  void fetchConsentForm() async {
    final data = await consentFormService.getConsentForm(
      clinicId: widget.doctor.hospital.hospitalId,
      subServiceId:
          selectedServicesController.selectedSubServices.first.subServiceId,
      procedureId: "1", // 👈 fallback generic form
    );

    if (data != null) {
      setState(() {
        consentFormData = data;
      });

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ConsentFormScreen(consentFormData: consentFormData!),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No consent form available")),
      );
    }
  }

  Future<Uint8List> _buildPdf() async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('dd MMM yyyy');

    // ✅ Load logo if available

    final logoBytes = decodeBase64Image(
        widget.doctor.hospital.hospitalLogo); // Uint8List from constructor
    final doctorSignPng = widget.doctor.doctor.doctorSignature;
    final patientSignPng = _patientSignController.isNotEmpty
        ? await _patientSignController.toPngBytes()
        : null;

    Uint8List? base64ToUint8List(String? base64String) {
      if (base64String == null || base64String.isEmpty) return null;

      // Remove prefix if exists (like "data:image/png;base64,")
      final cleaned = base64String.split(',').last;

      return base64Decode(cleaned);
    }

    final Uint8List? doctorSignBytes = base64ToUint8List(doctorSignPng);
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // 🏥 Header with Logo + Clinic Info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              if (logoBytes != null)
                pw.Container(
                  height: 60,
                  width: 60,
                  child: pw.Image(pw.MemoryImage(logoBytes)),
                ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(widget.doctor.hospital.name,
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      "Branch: ${(widget.doctor.hospital.branches != null && widget.doctor.hospital.branches != "" && widget.doctor.hospital.branches!.isNotEmpty) ? widget.doctor.hospital.branches : widget.doctor.hospital.city}",
                      style: pw.TextStyle(fontSize: 12)),
                ],
              )
            ],
          ),

          pw.SizedBox(height: 16),

          pw.Center(
            child: pw.Text("Consent for Skin Care Procedure",
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),

          pw.Divider(),

          // 🧑‍⚕️ Doctor Info Section
          pw.Text("Doctor Information",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.Text("Name: ${widget.doctor.doctor.doctorName}"),
          pw.Text("Specialization: ${widget.doctor.doctor.specialization}"),
          pw.Text("License No: ${widget.doctor.doctor.doctorLicence}"),
          pw.SizedBox(height: 12),

          // 👩‍🦰 Patient Info Section
          pw.Text("Patient Information",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.Text("Name: ${widget.patient.name}"),
          pw.Text("Mobile: ${widget.patient.mobileNumber}"),
          pw.Text("Gender: ${widget.patient.gender}"),
          pw.Text("Age: ${widget.patient.age}"),
          // pw.Text("Address: ${widget.patient.}"),
          pw.Text("Procedure Date: ${dateFmt.format(_procedureDate)}"),
          pw.SizedBox(height: 12),

          // ✅ Consent Points
          pw.Text("Agreed Consent Points:",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ..._consentPoints.entries
              .where((e) => e.value)
              .map((e) => pw.Bullet(text: e.key))
              .toList(),
          pw.SizedBox(height: 20),

          // 🖊 Signatures Section
          pw.Row(children: [
            pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Doctor Signature"),
                    pw.SizedBox(height: 6),
                    if (doctorSignBytes != null)
                      pw.Image(
                        pw.MemoryImage(doctorSignBytes),
                        height: 60,
                      )
                    else
                      pw.Text("No signature available"),
                  ]),
            ),
            pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Patient Signature"),
                    pw.SizedBox(height: 6),
                    if (patientSignPng != null)
                      pw.Image(pw.MemoryImage(patientSignPng), height: 60)
                  ]),
            ),
          ]),

          pw.SizedBox(height: 30),
          pw.Divider(),

          // 📌 Footer
          pw.Center(
            child: pw.Text(
                "This consent form is digitally generated and valid with a physical signature.",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          )
        ],
      ),
    );

    return pdf.save();
  }

  void _onSubmit() async {
    // if (!_agreed) {
    //   _showSnack("You must agree to proceed");
    //   return;
    // }
    if (!_signatureSaved) {
      _showSnack("Please provide your signature");
      return;
    }

    // ✅ Generate PDF
    final pdfBytes = await _buildPdf();

    // ✅ Navigate to confirm booking screen & pass pdf
    Get.to(() => Confirmbookingdetails(
          doctor: widget.doctor,
          patient: widget.patient,
          pdfBytes: pdfBytes!, // pass pdf to next screen
        ));
  }

  void _showSnack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // Save PDF to app directory and optionally share
  Future<void> _savePdf() async {
    final pdfBytes = await _buildPdf();

    Directory dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/patient_signature.pdf";
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    setState(() {
      _pdfBytes = pdfBytes;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved to: $filePath")),
    );
  }

  // Share PDF file
  Future<void> _sharePdf() async {
    if (_pdfBytes == null) return;

    Directory dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/patient_signature.pdf";
    final file = File(filePath);
    await file.writeAsBytes(_pdfBytes!);

    await Share.shareFiles([file.path], text: "Patient Consent Form PDF");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Patient Consent Form"),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name : ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text("${capitalizeEachWord(widget.patient.name)}"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Age : ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.patient.age} Yrs"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile Number : ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.patient.mobileNumber}"),
                      ],
                    ),
                  ]),
            ),
            _Section(
              title: 'Consent',
              child: Column(
                children:
                    _consentPoints.keys.toList().asMap().entries.map((entry) {
                  final index = entry.key; // 0-based index
                  final point = entry.value; // actual text

                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: GestureDetector(
                      onTap: () {
                        // ✅ make only specific indexes clickable
                        if (index == 0) {
                          if (consentFormData != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConsentFormScreen(
                                  consentFormData: consentFormData!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Consent form not loaded yet")),
                            );
                          }
                        } else if (index == 1) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => AnotherScreen(),
                          //   ),
                          // );
                        }
                      },
                      child: Text(
                        "${index + 1}. $point", // adds numbering
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.2,
                          color: (index == 0 || index == 1)
                              ? Colors.blue
                              : Colors.black,
                          decoration: (index == 0 || index == 1)
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    value: _consentPoints[point],
                    onChanged: (val) {
                      setState(() {
                        _consentPoints[point] = val ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Your data will be kept confidential and used in accordance with our ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.8, // <--- controls line height (default is ~1.5)
                  ),
                  children: [
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        height: 1.2, // <--- match parent line height
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const url = 'https://www.example.com/privacy-policy';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Questions Button
                  ElevatedButton.icon(
                    onPressed: _openQuestions,
                    icon: Icon(Icons.question_answer),
                    label: Text('Questions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  SizedBox(width: 20), // spacing between buttons

                  // WhatsApp Button
                  ElevatedButton.icon(
                    onPressed: whatsUpChat,
                    icon: Icon(Icons.whatshot),
                    label: Text('Help via WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Patient Signature",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),

            // Signature box
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // border color
                    width: 2, // border thickness
                  ),
                  borderRadius:
                      BorderRadius.circular(8), // optional rounded corners
                ),
                child: AspectRatio(
                  aspectRatio: 3.5,
                  child: Signature(
                    controller: _patientSignController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            // Buttons Row
            Row(
              children: [
                TextButton(
                  onPressed: () => _patientSignController.clear(),
                  child: const Text("Clear"),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () async {
                    final data = await _patientSignController.toPngBytes();
                    if (data != null) {
                      final pdf = await _buildPdf(); // generate PDF
                      setState(() {
                        _patientSigned = true;
                        _signatureSaved = true;
                        _pdfBytes = pdf;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Signature Saved Successfully ✅"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            ),

            // ✅ Saved Indicator
            if (_patientSigned)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Signature Saved",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),

                    // 👁 Preview PDF
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      tooltip: "Preview PDF",
                      onPressed: (_pdfBytes != null)
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PdfPreviewScreen(pdfBytes: _pdfBytes!),
                                ),
                              );
                            }
                          : null,
                    ),

                    // ⬇️ Download PDF
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: _pdfBytes != null ? _sharePdf : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: mainColor,
        child: FilledButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor:
                MaterialStateProperty.all(Colors.black), // text/icon color
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          onPressed: _onSubmit,
          // icon: const Icon(
          //   Icons.check,
          //   color: Colors.white,
          //   size: 25,
          // ),
          label: const Text(
            "SUBMIT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ),
        child
      ]),
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List? pdfBytes;
  const PdfPreviewScreen({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Consent PDF Preview"),
      body: PdfPreview(
        build: (format) async => pdfBytes!,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}
