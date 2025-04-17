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
import 'ConfirmBookingController.dart';
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
  final confirmbookingcontroller = Get.find<Confirmbookingcontroller>();
  Doctor? doctor;
  Hospital? hospital;
  void initState() {
    super.initState();
    doctor = widget.doctor.doctor;
    hospital = widget.doctor.hospital;
    final id = consultationController.consultationId.value;

    // Get consultation fee based on type
    if (id == 1) {
      confirmbookingcontroller.consultationFee = doctor!.fee.treatmentFee;
    } else if (id == 2) {
      confirmbookingcontroller.consultationFee = doctor!.fee.inClinicFee;
    } else if (id == 3) {
      confirmbookingcontroller.consultationFee =
          doctor!.fee.videoConsultationFee;
    } else {
      confirmbookingcontroller.consultationFee = 0;
    }
    confirmbookingcontroller.calculations();
  }

  @override
  Widget build(BuildContext context) {
    final id = consultationController.consultationId.value;
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
            Column(
              children: [
                profileCard(),
                _getServiceButton(consultationController.consultationId.value),
              ],
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Patient Details",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),
            infoRow("Booking For", widget.patient.bookingFor),
            infoRow("Patient Name", widget.patient.patientName),
            infoRow("Patient Age", "${widget.patient.patientAge} Yrs"),
            infoRow("Patient Gender", widget.patient.gender),
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            infoColumn("Patient Problem", widget.patient.problem),

            SizedBox(
              height: 15,
            ),
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            SizedBox(
              height: 15,
            ),
            // patyment imaformation
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Payment Details",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (id == 1) ...[
                  infoRow("Service Cost (Before Discount)",
                      "₹${confirmbookingcontroller.serviceCost}"),
                  infoRow("Total Discount (Services Only)",
                      "₹${confirmbookingcontroller.discount}"),
                  infoRow("Service Cost (After Discount)",
                      "₹${confirmbookingcontroller.discountedCost}"),
                  infoRow("Tax",
                      "₹${confirmbookingcontroller.taxAmount.toStringAsFixed(0)}"),
                  infoRow("Total Payable Amount",
                      "₹${confirmbookingcontroller.totalCost}"),
                ] else ...[
                  infoRow("Service Cost",
                      "₹${confirmbookingcontroller.consultationFee!}"),
                ]
              ],
            ),

            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(gradient: appGradient()),
        child: TextButton(
          onPressed: () {
            print(
                "PayAmount to be confirmbookingcontroller ${confirmbookingcontroller.totalCost.toString()}");

            Get.to(RazorpaySubscription(
              context: context,
              amount: confirmbookingcontroller.totalCost.toString(),
              onPaymentInitiated: () {
                showSnackbar("Warning", "Paytments Initiated", "warning");
              },
              serviceDetails: widget.doctor,
              patient: widget.patient,
            ));
          },
          child: Text(
            "BOOKING & PAY (₹ ${id == 1 ? confirmbookingcontroller.totalCost : confirmbookingcontroller.consultationFee!})",
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
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
    );
  }

  Widget _getServiceButton(String id) {
    // id = 2; // ✅ Test case 2
    Color color;
    String consultationType;

    switch (id) {
      case 1:
        color = Colors.white;
        confirmbookingcontroller.consultationFee = doctor!.fee.treatmentFee;
        consultationType = "Services And Treatments Fee";

        break;
      case 2:
        color = Colors.white;
        confirmbookingcontroller.consultationFee = doctor!.fee.inClinicFee;
        consultationType = "In-Clinic Fee";

        break;
      case 3:
        color = Colors.white;
        confirmbookingcontroller.consultationFee =
            doctor!.fee.videoConsultationFee;
        consultationType = "Consultation Fee";

        break;
      default:
        color = Colors.grey;
        consultationType = "Consultation Fee";
        confirmbookingcontroller.consultationFee = 0;
    }

    // return _serviceButton(consultationType, color, id, consultationFee);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _serviceButton(consultationType, color, id,
            confirmbookingcontroller.consultationFee!),
        SlotBookingAndConsltation(
            consultationType, confirmbookingcontroller.consultationFee!, id),
      ],
    );
  }

  Widget _serviceButton(
      String title, Color backgroundColor, String id, int fee) {
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

  Widget SlotBookingAndConsltation(String title, int fee, String id) {
    final services = selectedServicesController.selectedServices;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
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
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${widget.patient.dayDate}, ${widget.patient.slot}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 5),
          Expanded(
            child: id == 1
                ? Obx(() {
                    if (services.isEmpty) {
                      return const Text(
                        "No services selected",
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                service.serviceName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                                maxLines: 2,
                              ),
                              Text(
                                "Price: ₹ ${(service.discountedCost + doctor!.fee.treatmentFee).toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: mainColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Text(
                                  "Including Treatment fee and Doctor Consultation Fee",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  })
                : Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: services.map((service) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${service.serviceName}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "${title}", // Replace with the correct field
                              style: const TextStyle(
                                fontSize: 16,
                                color: mainColor,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "Price: ₹ ${fee}", // Replace with the correct field
                              style: const TextStyle(
                                fontSize: 16,
                                color: mainColor,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }),
          )
        ],
      ),
    );
  }
}
