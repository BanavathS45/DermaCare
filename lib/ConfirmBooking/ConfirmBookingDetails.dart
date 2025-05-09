import 'package:cutomer_app/ConfirmBooking/ConsultationServices.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorModel.dart';
import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../BottomNavigation/Appoinments/PostBooingModel.dart';
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
  final PatientModel patient;

  Confirmbookingdetails(
      {super.key, required this.doctor, required this.patient});

  @override
  State<Confirmbookingdetails> createState() => _ConfirmbookingdetailsState();
}

class _ConfirmbookingdetailsState extends State<Confirmbookingdetails> {
  final selectedServicesController = Get.find<SelectedServicesController>();
  final consultationController = Get.find<Consultationcontroller>();
  // final confirmbookingcontroller = Get.find<Confirmbookingcontroller>();
  Doctor? doctor;
  Hospital? hospital;
  List<ConsultationModel> _consultations = [];
  int consultationFee = 0;
  int totalFee = 0;
  @override
  void initState() {
    super.initState();
    doctor = widget.doctor.doctor;
    hospital = widget.doctor.hospital;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final selectedId =
          consultationController.selectedConsultation.value!.consultationId;

      final consultations = await getConsultationDetails();

      if (consultations.isNotEmpty) {
        setState(() {
          _consultations = consultations;
        });

        // Now execute based on matched ID
        if (selectedId == consultations[0].consultationId) {
          setState(() {
            consultationFee = selectedServicesController
                .selectedSubServices.first.finalCost
                .toInt();
          });
        } else if (selectedId == consultations[1].consultationId) {
          setState(() {
            consultationFee = doctor?.fee.inClinicFee ?? 0;
          });
        } else if (selectedId == consultations[2].consultationId) {
          setState(() {
            consultationFee = doctor?.fee.videoConsultationFee ?? 0;
          });
        } else {
          setState(() {
            consultationFee = 0;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    totalFee = platformFee + consultationFee;

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
                FutureBuilder(
                  future: _getServiceButton(consultationController
                      .selectedConsultation.value!.consultationId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // or SizedBox.shrink()
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return snapshot.data as Widget; // ✅ Your returned widget
                    }
                  },
                )
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
            infoRow("Patient Name", widget.patient.name),
            infoRow("Patient Age", "${widget.patient.age} Yrs"),
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
                infoRow("Service Cost", "₹ ${consultationFee}"),
                infoRow("Platform Fee", "₹ ${platformFee}"),
                infoRow("Total Fee", "₹ ${totalFee}"),
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
            print("PayAmount to be confirmbookingcontroller ${totalFee}");
            final bookingDetails = BookingDetailsModel(
              servicename: selectedServicesController
                  .selectedSubServices.first.serviceName,
              serviceId: selectedServicesController
                  .selectedSubServices.first.subServiceId,
              doctorId: widget.doctor.doctor.doctorId,
              consultationType: consultationController
                  .selectedConsultation.value!.consultationType,
              consultattionFee: consultationFee.toDouble(),
              totalFee: (totalFee).toDouble(),
              status: 'pending',
            );

            Get.to(RazorpaySubscription(
              context: context,
              amount: totalFee.toString(),
              onPaymentInitiated: () {
                showSnackbar("Warning", "Paytments Initiated", "warning");
              },
              serviceDetails: widget.doctor,
              patient: widget.patient,
              bookingDetails: PostBookingModel(
                  patient: widget.patient, booking: bookingDetails),
              mobileNumber: widget.patient.mobileNumber,
            ));
          },
          child: Text(
            "BOOKING & PAY (₹ ${totalFee})",
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

  Future<Widget> _getServiceButton(String id) async {
    Color color = Colors.white;
    String consultationType = "";
    int consultationFee = 0;

    // Find the consultation matching the passed 'id' (consultationId)

    final consultations = await getConsultationDetails();
    // Dynamically set the fee based on the consultation type
    if (consultations[0].consultationId == id) {
      color = Colors.white;
      consultationFee = selectedServicesController
          .selectedSubServices.first.finalCost
          .toInt();
      ;

      consultationType = consultations[0].consultationType;
    } else if (consultations[1].consultationId == id) {
      color = Colors.white;
      consultationFee = doctor!.fee.inClinicFee;
      consultationType = consultations[1].consultationType;
    } else if (consultations[2].consultationId == id) {
      color = Colors.white;
      consultationFee = doctor!.fee.videoConsultationFee;
      consultationType = consultations[2].consultationType;
    } else {
      color = Colors.grey;
      consultationType = "Consultation Fee";
      consultationFee = 0;
    }

    // Set the consultation fee in the controller

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _serviceButton(consultationType, color, id, consultationFee),
        SlotBookingAndConsltation(consultationType, consultationFee, id),
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
    print("title __ ${title}");
    print("fee __ ${fee}");
    print("id __ ${id}");
    final services = selectedServicesController.selectedSubServices;
    print(
        "selectedServicesControllersdds __ ${selectedServicesController.selectedSubServices.first.finalCost}");

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
                "${widget.patient.serviceDate}, ${widget.patient.servicetime}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 5),
          Expanded(child: Obx(() {
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedServicesController
                            .selectedSubServices.first.subServiceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        "Price: ₹ ${(fee).toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }))
        ],
      ),
    );
  }
}
