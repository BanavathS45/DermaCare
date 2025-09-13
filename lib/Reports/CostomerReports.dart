import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerReportsPage extends StatelessWidget {
  CustomerReportsPage({super.key});
  final List<Patient> patientReports = [
    Patient(
      patientId: "P001",
      name: "John Doe",
      date: "2025-08-20",
      pastReports: [
        Report(
            title: "Blood Test",
            fileUrl: "https://example.com/bloodtest_john.pdf"),
        Report(title: "X-Ray", fileUrl: "https://example.com/xray_john.pdf"),
      ],
      prescriptions: [
        Prescription(fileUrl: "https://example.com/john_prescription.pdf"),
      ],
    ),
    Patient(
      patientId: "P002",
      name: "Jane Roe",
      date: "2025-08-15",
      pastReports: [
        Report(title: "MRI Scan", fileUrl: "https://example.com/mri_jane.pdf"),
      ],
      prescriptions: [
        Prescription(fileUrl: "https://example.com/jane_prescription.pdf"),
      ],
    ),
  ];

  Future<void> _openPdf(String url) async {
    final Uri pdfUri = Uri.parse(url);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Customer Reports",
      ),
      body: ListView.builder(
        itemCount: patientReports.length,
        itemBuilder: (context, index) {
          final patient = patientReports[index];
          return Card(
            margin: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${patient.patientId} - ${patient.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(patient.date,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              children: [
                // Past Reports
                ExpansionTile(
                  title: const Text("Past Reports"),
                  children: patient.pastReports.map((report) {
                    return ListTile(
                      title: Text(report.title),
                      trailing:
                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                      onTap: () => _openPdf(report.fileUrl),
                    );
                  }).toList(),
                ),
                // Prescriptions
                ExpansionTile(
                  title: const Text("Prescriptions"),
                  children: patient.prescriptions.map((pres) {
                    return ListTile(
                      title: const Text("Download Prescription"),
                      trailing:
                          const Icon(Icons.picture_as_pdf, color: Colors.blue),
                      onTap: () => _openPdf(pres.fileUrl),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Report {
  final String title;
  final String fileUrl;

  Report({required this.title, required this.fileUrl});
}

class Prescription {
  final String fileUrl;

  Prescription({required this.fileUrl});
}

class Patient {
  final String patientId;
  final String name;
  final String date;
  final List<Report> pastReports;
  final List<Prescription> prescriptions;

  Patient({
    required this.patientId,
    required this.name,
    required this.date,
    required this.pastReports,
    required this.prescriptions,
  });
}
