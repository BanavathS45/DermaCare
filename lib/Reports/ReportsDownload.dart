import 'package:cutomer_app/BottomNavigation/Appoinments/GetAppointmentModel.dart';
import 'package:cutomer_app/Reports/DownloadReports.dart';
import 'package:cutomer_app/Reports/FilePreviewScreen.dart';
import 'package:flutter/material.dart';

import '../PatientsDetails/PatientModel.dart';

Future<void> showReportDownloadSheet(
    BuildContext context, List<ReportItem> reports) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Available Reports",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...reports.expand((report) => report.reportFile.map((file) {
                    final isPdf = file.toLowerCase().endsWith('.pdf') ||
                        file.contains('data:application/pdf');

                    return Card(
                      child: ListTile(
                        title: Text(report.reportName),
                        subtitle: Text("Type: ${report.reportType}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye_outlined),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FilePreviewScreen(fileUrl: file),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () async {
                                Navigator.pop(context);
                                await downloadAndOpenReport(file);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            ],
          ),
        ),
      );
    },
  );
}
