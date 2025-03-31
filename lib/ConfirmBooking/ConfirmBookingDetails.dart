import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorModel.dart';
import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/CustomerController.dart';
import '../Doctors/DoctorDetails/DoctorDetailsScreen.dart';
import '../PatientsDetails/PatientModel.dart';
import '../Payments/AllPayments.dart';
import '../Utils/Constant.dart';

import '../Utils/ScaffoldMessageSnacber.dart';
import 'ConsultationController.dart';

class Confirmbookingdetails extends StatefulWidget {
  final HospitalDoctorModel doctor;
  final Patientmodel patient;
  Confirmbookingdetails(
      {super.key, required this.doctor, required this.patient});

  @override
  State<Confirmbookingdetails> createState() => _ConfirmbookingdetailsState();
}

class _ConfirmbookingdetailsState extends State<Confirmbookingdetails> {
  final selectedServicesController = Get.find<SelectedServicesController>();
  final consultationController = Get.find<Consultationcontroller>();
  Doctor? doctor;
  Hospital? hospital;
  int? consultationFee;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    doctor = widget.doctor.doctor;
    hospital = widget.doctor.hospital;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonHeader(
        title: "Confirm Booking",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 85), // ✅ Remove extra padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Card
            profileCard(),
            _getServiceButton(consultationController.consultationId.value),

            const SizedBox(height: 20),
            infoRow("Booking For", widget.patient.bookingFor),
            infoRow("Patient Name", widget.patient.patientName),
            infoRow("Patient Age", "${widget.patient.patientAge} Yrs"),
            infoRow("Patient Gender", widget.patient.gender),
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            infoColumn("Patient Problem", widget.patient.problem),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(gradient: appGradient()),
        child: TextButton(
          onPressed: () {
            Get.to(RazorpaySubscription(
              context: context,
              amount: consultationFee.toString(),
              onPaymentInitiated: () {
                showSnackbar("Warning", "Paytments Initiated", "warning");
              },
              serviceDetails: widget.doctor, patient: widget.patient,
            ));
          },
          child: Text(
            "Booking & Pay",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  infoRow(String title, dynamic info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${title} ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(info)
        ],
      ),
    );
  }

  infoColumn(String title, dynamic info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${title}: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(info)
        ],
      ),
    );
  }

  Widget profileCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mainColor,
              secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "${hospital!.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    hospital!.city,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 209, 207, 207)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      doctor!.profileImage.isNotEmpty
                          ? doctor!.profileImage
                          : "https://via.placeholder.com/150",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Text Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "${doctor!.name}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          doctor!.qualification,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          doctor!.specialization,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 206, 211, 207),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () {
                                Get.to(() => DoctorDetailScreen(
                                    doctorData: widget.doctor));
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                side: const BorderSide(
                                    color: Colors.white,
                                    width: 1), // ✅ White border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // ✅ Rounded corners
                                ),
                              ),
                              child: const Text(
                                "About",
                                style: TextStyle(
                                    color:
                                        Colors.white), // ✅ Optional: white text
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getServiceButton(int id) {
    // id = 2; // ✅ Test case 2
    Color color;
    String consultationType;

    switch (id) {
      case 1:
        color = Colors.white;
        consultationFee = doctor!.fee.treatmentFee;
        consultationType = "Services And Treatments Fee";

        break;
      case 2:
        color = Colors.white;
        consultationFee = doctor!.fee.inClinicFee;
        consultationType = "In-Clinic Fee";

        break;
      case 3:
        color = Colors.white;
        consultationFee = doctor!.fee.videoConsultationFee;
        consultationType = "Consultation Fee";

        break;
      default:
        color = Colors.grey;
        consultationType = "Consultation Fee";
        consultationFee = 0;
    }

    // return _serviceButton(consultationType, color, id, consultationFee);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _serviceButton(consultationType, color, id, consultationFee!),
        SlotBookingAndConsltation(consultationType, consultationFee!, id),
      ],
    );
  }

  Widget _serviceButton(String title, Color backgroundColor, int id, int fee) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 6,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Consultation Type",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SlotBookingAndConsltation(String title, int fee, int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.patient.monthYear,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${widget.patient.dayDate}, ${widget.patient.slot}",
              style: TextStyle(fontSize: 14),
            ),
          ]),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              // color: mainColor,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedServicesController.selectedServices
                              .map((service) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: [
                                  Text(
                                    // "${service.serviceName} (Discounted: ₹${service.discountedCost})",
                                    "${id == 1 ? service.serviceName : title} ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "Price: ₹ ${id == 1 ? (service.discountedCost + doctor!.fee.treatmentFee).toStringAsFixed(0) : fee}",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  Text(
                                    "Including Treatment fee and Doctor Consultation Fee",
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
