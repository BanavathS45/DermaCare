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
      abImages: [
        AbImages(
            fileUrl:
                "https://i.pinimg.com/originals/7a/70/d6/7a70d66837d5888b9d3e0a0a861e9127.jpg"),
        AbImages(fileUrl: "https://picsum.photos/300/300"),
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
      abImages: [
        AbImages(
            fileUrl:
                "https://tse1.explicit.bing.net/th/id/OIP.62Z1nqyliooNDHMTCF7yogHaHa?pid=ImgDet&w=207&h=207&c=7&dpr=1.5&o=7&rm=3"),
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

  Future<void> _openImage(String url) async {
    final Uri imageUri = Uri.parse(url);
    if (await canLaunchUrl(imageUri)) {
      await launchUrl(imageUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(title: "Customer Reports"),
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
                // Images with preview + download button
                ExpansionTile(
                  title: const Text("Images"),
                  children: patient.abImages.map((img) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            img.fileUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Image failed to load"),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text("View / Download"),
                          onPressed: () => _openImage(img.fileUrl),
                        ),
                        const Divider(),
                      ],
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

class AbImages {
  final String fileUrl;

  AbImages({required this.fileUrl});
}

class Patient {
  final String patientId;
  final String name;
  final String date;
  final List<Report> pastReports;
  final List<Prescription> prescriptions;
  final List<AbImages> abImages;

  Patient({
    required this.patientId,
    required this.name,
    required this.date,
    required this.pastReports,
    required this.prescriptions,
    required this.abImages,
  });
}
