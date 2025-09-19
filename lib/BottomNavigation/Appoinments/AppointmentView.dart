import 'dart:convert';
import 'dart:io';
import 'package:cutomer_app/Reports/DownloadReports.dart';
import 'package:cutomer_app/Reports/FilePreviewScreen.dart';
import 'package:cutomer_app/Utils/SavePdfToDownloads.dart';
import 'package:cutomer_app/Utils/ScaffoldMessageSnacber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import '../../Doctors/Schedules/ConsentForm.dart';
import '../../Doctors/DoctorDetails/DoctorDetailsScreen.dart';
import '../../Reports/ReportsDownload.dart';
import '../../Utils/Constant.dart';

import '../../Utils/Header.dart';

import 'GetAppointmentModel.dart';

class AppointmentPreview extends StatefulWidget {
  final HospitalDoctorModel doctor;
  final Getappointmentmodel doctorBookings;

  const AppointmentPreview({
    Key? key,
    required this.doctor,
    required this.doctorBookings,
  }) : super(key: key);

  @override
  State<AppointmentPreview> createState() => _AppointmentPreviewState();
}

class _AppointmentPreviewState extends State<AppointmentPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final patient = widget.doctorBookings;
    final doctor = widget.doctor;

    String base64String = doctor.doctor.doctorPicture;
    final regex = RegExp(r'data:image/[^;]+;base64,');
    base64String = base64String.replaceAll(regex, '');
    final prefix = 'data:image/jpeg;base64,';
    if (base64String.startsWith(prefix)) {
      base64String = base64String.substring(prefix.length);
    }

    Future<bool> requestStoragePermission() async {
      if (Platform.isAndroid) {
        // ✅ Android 11+ (Scoped Storage)
        if (await Permission.manageExternalStorage.isGranted) return true;

        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        // ✅ iOS or other platforms - no special permission needed
        return true;
      }
    }

    final isCompletedStatus = patient.status.toLowerCase() == 'completed';
    final showReports = patient.status.toLowerCase() == 'completed' ||
        patient.status.toLowerCase() == 'in-progress';

    return Scaffold(
      appBar: CommonHeader(title: "Appointment Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (patient.status.toLowerCase() == "rejected")
              Card(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Reason For Reject",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${patient.reasonForCancel}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Hospital Accordion
            ExpansionTile(
              title: Text("Clinic Details"),
              leading: Icon(Icons.local_hospital_outlined, color: Colors.blue),
              children: [
                _infoRow("Hospital", patient.clinicName),
                _infoRow("Branch", doctor.hospital.branch),
                // _infoRow("Location", doctor.hospital.address),
                // _infoRow("Contact", doctor.hospital.contactNumber),
              ],
            ),
            const SizedBox(height: 8),
            // Doctor Accordion
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(doctor.doctor.doctorName),
                  TextButton(
                    onPressed: () {
                      Get.to(DoctorDetailScreen(doctorData: doctor));
                    },
                    child: Text("About Doctor"),
                  ),
                ],
              ),
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: doctor.doctor.doctorPicture.isNotEmpty
                    ? MemoryImage(base64Decode(base64String))
                    : const AssetImage('assets/placeholder.png')
                        as ImageProvider,
              ),
              children: [
                _infoRow("Specialization", doctor.doctor.specialization),
                _infoRow("Experience", "${doctor.doctor.experience} years"),
              ],
            ),
            const SizedBox(height: 8),
            // Patient Info Accordion
            ExpansionTile(
              title: Text("Patient Details"),
              leading: Icon(Icons.account_circle_outlined, color: Colors.blue),
              children: [
                _infoRow("Name", patient.name),
                _infoRow("Age", patient.age.toString()),
                _infoRow("Gender", patient.gender),
                _infoRow("Booking For", patient.bookingFor),
                _infoRow("Date", patient.serviceDate),
                _infoRow("Time", patient.servicetime),
                _infoRow("Problem", patient.problem),
              ],
            ),
            const SizedBox(height: 8),
            // Service / Payment Info Accordion
            ExpansionTile(
              title: Text("Service & Payment Details"),
              leading: Icon(Icons.payment_outlined, color: Colors.blue),
              children: [
                _infoRow("Service", patient.subServiceName),
                _infoRow("Consultation Type", patient.consultationType),
                _infoRow("Consultation Fee", "₹${patient.consultationFee}"),
                _infoRow("Total Fee", "₹${patient.totalFee}"),
              ],
            ),
            const SizedBox(height: 8),
            // Reports Accordion

            if (showReports)
              ExpansionTile(
                title: Text("Patient Reports"),
                leading:
                    Icon(Icons.picture_as_pdf_outlined, color: Colors.blue),
                children: [
                  // ✅ Prescription PDF (if available)
                  if (patient.priscriptionPdf != null &&
                      patient.priscriptionPdf!.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Text("Prescription",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: Icon(Icons.visibility, color: mainColor),
                          onPressed: () async {
                            try {
                              final bytes =
                                  base64Decode(patient.priscriptionPdf!);
                              final tempDir = await getTemporaryDirectory();
                              final filePath =
                                  "${tempDir.path}/Prescription.pdf";
                              final file = File(filePath);
                              await file.writeAsBytes(bytes);
                              await OpenFilex.open(file.path);
                            } catch (e) {
                              ScaffoldMessageSnackbar.show(
                                context: context,
                                message: "Failed to open prescription: $e",
                                type: SnackbarType.error,
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.download, color: mainColor),
                          onPressed: () async {
                            if (!await requestStoragePermission()) {
                              ScaffoldMessageSnackbar.show(
                                context: context,
                                message: "Storage permission is required",
                                type: SnackbarType.warning,
                              );

                              return;
                            }
                            try {
                              final bytes =
                                  base64Decode(patient.priscriptionPdf!);
                              final downloadDir =
                                  Directory("/storage/emulated/0/Download");
                              if (!await downloadDir.exists()) {
                                await downloadDir.create(recursive: true);
                              }

                              final filePath =
                                  "${downloadDir.path}/Prescription.pdf";
                              final file = File(filePath);
                              await file.writeAsBytes(bytes);
                              ScaffoldMessageSnackbar.show(
                                context: context,
                                message: "Prescription saved to Downloads",
                                type: SnackbarType.success,
                              );

                              await OpenFilex.open(file.path);
                            } catch (e) {
                              ScaffoldMessageSnackbar.show(
                                context: context,
                                message: "Failed to download: $e",
                                type: SnackbarType.error,
                              );
                            }
                          },
                        ),
                      ],
                    ),

                  if (patient.priscriptionPdf != null &&
                      patient.priscriptionPdf!.isNotEmpty)
                    Divider(),

                  // ✅ Reports Section
                  if (patient.reports != null &&
                      patient.reports!.reportsList.isNotEmpty)
                    ...patient.reports!.reportsList.map((reportItem) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reportItem.reportName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(reportItem.reportDate,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              ...reportItem.reportFile.map((fileBase64) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility,
                                          color: mainColor),
                                      onPressed: () async {
                                        try {
                                          final bytes =
                                              base64Decode(fileBase64);
                                          final tempDir =
                                              await getTemporaryDirectory();
                                          final filePath =
                                              "${tempDir.path}/${reportItem.reportName.replaceAll(" ", "_")}.pdf";
                                          final file = File(filePath);
                                          await file.writeAsBytes(bytes);
                                          await OpenFilex.open(file.path);
                                        } catch (e) {
                                          ScaffoldMessageSnackbar.show(
                                            context: context,
                                            message:
                                                "Failed to open report: $e",
                                            type: SnackbarType.error,
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.download,
                                          color: mainColor),
                                      onPressed: () async {
                                        // if (!await requestStoragePermission()) {
                                        //   ScaffoldMessageSnackbar.show(
                                        //     context: context,
                                        //     message:
                                        //         "Storage permission is required",
                                        //     type: SnackbarType.success,
                                        //   );

                                        //   return;
                                        // }
                                        try {
                                          final bytes =
                                              base64Decode(fileBase64);
                                          await downloadAndOpenReport(
                                              fileBase64);

                                          final downloadDir = Directory(
                                              "/storage/emulated/0/Download");
                                          if (!await downloadDir.exists()) {
                                            await downloadDir.create(
                                                recursive: true);
                                          }

                                          final filePath =
                                              "${downloadDir.path}/${reportItem.reportName.replaceAll(" ", "_")}.pdf";
                                          final file = File(filePath);
                                          await file.writeAsBytes(bytes);
                                          ScaffoldMessageSnackbar.show(
                                            context: context,
                                            message:
                                                "${reportItem.reportName} saved to Downloads",
                                            type: SnackbarType.success,
                                          );

                                          await OpenFilex.open(file.path);
                                        } catch (e) {
                                          ScaffoldMessageSnackbar.show(
                                            context: context,
                                            message:
                                                "Failed to download report: $e",
                                            type: SnackbarType.error,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),

                  // ✅ No reports or prescription
                  if ((patient.priscriptionPdf == null ||
                          patient.priscriptionPdf!.isEmpty) &&
                      (patient.reports == null ||
                          patient.reports!.reportsList.isEmpty))
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("📝🩺 No reports available"),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
