import 'dart:convert';
import 'dart:typed_data';
import 'package:cutomer_app/ConfirmBooking/ConfirmBookingDetails.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';

import 'package:cutomer_app/PatientsDetails/PatientModel.dart';
import '../ListOfDoctors/HospitalAndDoctorModel.dart';

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

  DateTime _procedureDate = DateTime.now();

  // consent points

  final Map<String, bool> _consentPoints = {
    "I understand the purpose and nature of the dermal filler procedure.":
        false,
    "I understand possible risks, side effects, and potential complications.":
        false,
    "I understand the expected results are temporary and may vary between individuals.":
        false,
    "I consent to photographs for medical records (not for marketing).": false,
    "I have had the opportunity to ask questions and they were answered.":
        false,
    "I understand bruising, swelling, redness, or tenderness may occur and are usually temporary.":
        false,
    "I understand rare complications such as vascular occlusion, infection, or allergic reaction may occur.":
        false,
    "I have disclosed my full medical history, including medications, allergies, and prior cosmetic procedures.":
        false,
    "I understand that results may not be exactly as desired and multiple sessions may be needed.":
        false,
    "I understand that touching or massaging the treated area without instruction may affect results.":
        false,
    "I agree to follow all pre- and post-procedure instructions given by my provider.":
        false,
    "I understand that dermal fillers are not permanent and maintenance treatments are required.":
        false,
    "I confirm I am not pregnant or breastfeeding.": false,
    "I understand that medical emergencies (e.g., severe pain, vision changes, skin blanching) require immediate attention.":
        false,
    "I give consent for the provider to perform the dermal filler procedure.":
        false,
  };

  bool _agreed = false;
  bool _signatureSaved = false;
  Uint8List? _pdfBytes;
  bool _patientSigned = false;
  @override
  void initState() {
    super.initState();
    _patientSignController = SignatureController(penStrokeWidth: 2);
  }

  @override
  void dispose() {
    _patientSignController.dispose();
    super.dispose();
  }

  Future<void> _openPatientSignSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Patient Signature",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 3.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                  ),
                  child: Signature(
                    controller: _patientSignController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                      onPressed: () => _patientSignController.clear(),
                      child: const Text("Clear")),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      final data = await _patientSignController.toPngBytes();
                      if (data != null) {
                        final pdf =
                            await _buildPdf(); // generate PDF immediately
                        setState(() {
                          _patientSigned = true;
                          _signatureSaved = true;
                          _pdfBytes = pdf;
                        });
                        Navigator.pop(context); // close sheet
                      }
                    },
                    child: const Text("Save"),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

// Utility
  Uint8List? decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;

    // Remove "data:image/png;base64," if present
    final cleaned = base64String.split(',').last;
    return base64Decode(cleaned);
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
                      "Branch: ${(widget.doctor.hospital.branch != null && widget.doctor.hospital.branch != "" && widget.doctor.hospital.branch!.isNotEmpty) ? widget.doctor.hospital.branch : widget.doctor.hospital.city}",
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
    if (!_agreed) {
      _showSnack("You must agree to proceed");
      return;
    }
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
          pdfBytes: pdfBytes, // pass pdf to next screen
        ));
  }

  void _showSnack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Consent Form"),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section(
              title: 'Consent Points',
              child: Column(
                children:
                    _consentPoints.keys.toList().asMap().entries.map((entry) {
                  final index = entry.key + 1; // numbering starts from 1
                  final point = entry.value;

                  return CheckboxListTile(
                    title: Text("$index. $point"),
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
            _Section(
              title: "Agreement",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: const Text("I Agree to the above terms"),
                    value: _agreed,
                    onChanged: (val) {
                      setState(() {
                        _agreed = val ?? false;
                      });
                      if (val == true) {
                        _openPatientSignSheet(); // open signature pad when agree
                      }
                    },
                  ),

                  // ✅ Show tick when signature saved
                  if (_patientSigned)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.check,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Signature Saved",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: (_signatureSaved && _pdfBytes != null)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PdfPreviewScreen(pdfBytes: _pdfBytes!),
                          ),
                        );
                      }
                    : null, // disables button if condition not met
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(
                  (_signatureSaved && _pdfBytes != null)
                      ? "Preview PDF"
                      : "Complete form to enable", // dynamic label
                ),
              ),
            )
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
          icon: const Icon(
            Icons.check,
            color: Colors.white,
            size: 25,
          ),
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
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          child
        ]),
      ),
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  const PdfPreviewScreen({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Consent PDF Preview"),
      body: PdfPreview(
        build: (format) async => pdfBytes,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}
