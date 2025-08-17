import 'dart:convert';

import 'package:cutomer_app/Booings/BooingService.dart';
import 'package:cutomer_app/ConfirmBooking/ConsultationServices.dart';
import 'package:cutomer_app/Consultations/SymptomsController.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';

import 'package:cutomer_app/Screens/BookingSuccess.dart';

import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../BottomNavigation/Appoinments/PostBooingModel.dart';
import '../Controller/CustomerController.dart';
import '../Doctors/DoctorDetails/DoctorDetailsScreen.dart';
import '../PatientsDetails/PatientModel.dart';
import '../Payments/AllPayments.dart';
import '../Payments/PaymentMode.dart';
import '../Utils/Constant.dart';
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
  final SymptomsController symptomsController = Get.put(SymptomsController());

  // final confirmbookingcontroller = Get.find<Confirmbookingcontroller>();
  Doctor? doctor;
  Hospital? hospital;
  List<ConsultationModel> _consultations = [];
  int consultationFee = 0;
  int totalFee = 0;
  // globals.dart
  String globalServiceId = '';
  @override
  void initState() {
    super.initState();
    doctor = widget.doctor.doctor;
    hospital = widget.doctor.hospital;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final selectedId =
          consultationController.selectedConsultation.value?.consultationId ??
              "";
      globalServiceId = selectedId;
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
            consultationFee = doctor?.doctorFees.inClinicFee ?? 0;
          });
        } else if (selectedId == consultations[2].consultationId) {
          setState(() {
            consultationFee = doctor?.doctorFees.vedioConsultationFee ?? 0;
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
    // totalFee = platformFee + consultationFee;
    totalFee = consultationFee;
    Widget? consultationWidget;
    bool loading = false;
    String? currentConsultationId;

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
                Obx(() {
                  final consultationId = consultationController
                      .selectedConsultation.value?.consultationId;
                  if (consultationId == null) return SizedBox();

                  print("consultationId: $consultationId");

                  return FutureBuilder(
                    key: ValueKey(consultationId),
                    future: _getServiceButton(consultationId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        print("🔥 Error: ${snapshot.error}");
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return snapshot.data as Widget;
                      }
                    },
                  );
                })
              ],
            ),

            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PaymentModeSelector(
                  consultationType: consultationController
                      .selectedConsultation.value!.consultationType,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Patient Details",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 20,
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

            if (symptomsController.symptoms.value == "")
              infoColumn("Patient Problem", widget.patient.problem),

            SizedBox(
              height: 15,
            ),
            SizedBox(height: 15),

// Show Symptoms if available
            if (symptomsController.symptoms.value.isNotEmpty)
              Obx(() {
                return infoColumn(
                    "Symptoms", symptomsController.symptoms.value);
              }),

            SizedBox(height: 15),

// Show Symptoms if available
            if (symptomsController.duration.value.isNotEmpty)
              Obx(() {
                return infoColumn(
                    "Duration", "${symptomsController.duration.value} days");
              }),

            SizedBox(height: 15),
            if (symptomsController.visitType.value.isNotEmpty)
              Obx(() {
                return infoColumn(
                    "Visit Type", "${symptomsController.visitType.value} ");
              }),

            SizedBox(height: 15),

// Show Attachment if available
            if (symptomsController.attachment.value != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 4),
                    child: Text(
                      "Attachment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  symptomsController.attachment.value!.path
                          .toLowerCase()
                          .endsWith('.pdf')
                      ? Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(Icons.picture_as_pdf, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              symptomsController.attachment.value!.path
                                  .split('/')
                                  .last,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                symptomsController.attachment.value!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 15),
                ],
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoRow("${consultationType} Fee", "₹ ${consultationFee}"),

                // infoRow("Platform Fee", "₹ ${platformFee}"),
                // infoRow("Total Fee", "₹ ${consultationFee}"),
              ],
            ),

            SizedBox(
              height: 25,
            ),
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            // PaymentModeSelector(
            //   consultationType: consultationController
            //       .selectedConsultation.value!.consultationType,
            // ),
            // const SizedBox(height: 20),
            // Obx(() => Text(selectedServicesController.selectedPayment.value)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(gradient: appGradient()),
        child: TextButton(
          onPressed: () async {
            final selectedPayment =
                selectedServicesController.selectedPayment.value;

            print("Selected Payment: $selectedPayment");

            final bookingDetails = BookingDetailsModel(
                subServiceName: globalServiceId == "ST_01"
                    ? selectedServicesController
                        .selectedSubServices.first.subServiceName
                    : "NA",
                subServiceId: globalServiceId == "ST_01"
                    ? selectedServicesController
                        .selectedSubServices.first.subServiceId
                    : "NA",
                doctorId: widget.doctor.doctor.doctorId,
                consultationType: consultationController
                    .selectedConsultation.value!.consultationType,
                consultationFee: consultationFee.toDouble(),
                totalFee: (consultationFee).toDouble(),
                clinicId: widget.doctor.hospital.hospitalId,
                doctorDeviceId: widget.doctor.doctor.deviceId,
                clinicAddress: widget.doctor.hospital.address,
                categoryName: globalServiceId == "ST_01"
                    ? selectedServicesController
                        .selectedSubServices.first.categoryName
                    : "NA",
                categoryId: globalServiceId == "ST_01"
                    ? selectedServicesController
                        .selectedSubServices.first.categoryId
                    : "NA",
                servicename: globalServiceId == "ST_01"
                    ? selectedServicesController
                        .selectedSubServices.first.serviceName
                    : "NA",
                serviceId: globalServiceId == "ST_01"
                    ? selectedServicesController
                        .selectedSubServices.first.serviceID
                    : "NA",
                clinicName: widget.doctor.hospital.name,
                doctorName: widget.doctor.doctor.doctorName,
                // consultationExpiration:
                //     widget.doctor.hospital.consultationExpiration,
                consultationExpiration: "15 days",
                paymentType: "Pay at Hospital",
                visitType: 'firsttime',
                symptomsDuration: "1 week" //TODO:develop in UI
                );

            // 📦 Model ready for API
            final postBookingPayload = PostBookingModel(
              patient: widget.patient,
              booking: bookingDetails,
            );

            if (selectedPayment == "Pay at Hospital") {
              // 🏥 DIRECTLY POST BOOKING
              print('[🏥] Booking via Pay at Hospital');

              var responseData = await postBookings(postBookingPayload);
              print('[DEBUG] Response Data: $responseData');

              if (responseData != null &&
                  responseData['statusCode'] == 201 &&
                  responseData['data'] != null) {
                print('[✅] Booking successful');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SuccessScreen(
                        serviceDetails: widget.doctor,
                        paymentId: "pay_at_hospital",
                        patient: widget.patient,
                        mobileNumber: widget.patient.mobileNumber,
                        paymentType: "cash"),
                  ),
                  (route) => false,
                );
              } else {
                print(
                    '[❌] Booking failed or unexpected response: $responseData');
                showSnackbar("Error", "Booking failed", "error");
              }
            } else {
              // 💳 GO TO PAYMENT SCREEN
              print('[💳] Navigating to Razorpay...');

              Get.to(RazorpaySubscription(
                context: context,
                amount: consultationFee.toString(),
                onPaymentInitiated: () {
                  showSnackbar("Info", "Payment Initiated", "info");
                },
                serviceDetails: widget.doctor,
                patient: widget.patient,
                bookingDetails: postBookingPayload,
                mobileNumber: widget.patient.mobileNumber,
              ));
              // }
              // void handleNextScreen(BuildContext context, Map<String, dynamic> payload) async {
              //   final response = await http.get(Uri.parse(
              //       'https://rainbow.exwyn.com/api/generateTransactionId'));

              //   if (response.statusCode == 200) {
              //     final restxnId =
              //         response.body; // assuming plain string or parse accordingly
              //     final txnidData = json.decode(restxnId);
              //     print("txnidData ${restxnId}");

              //     final txnId = txnidData['data'];

              //     var finalPayload = ({
              //           "PatientName": "John",
              //           "EmailAddress": "john@example.com",
              //           "MobileNumber": "9999999999",
              //           "payment_type": "ONLINE",
              //           "price": consultationFee.toString()
              //         }),
              //         payload = FinalPayload.fromJson(finalPayload);

              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => PayUWebViewScreen(
              //           txnId: txnId,
              //           amount: consultationFee.toString(),
              //           payuUrl: "https://test.payu.in/_payment",
              //           serviceDetails: widget.doctor,
              //           mobileNumber: widget.patient.mobileNumber,
              //           context: context,
              //           patient: widget.patient,
              //           bookingDetails: postBookingPayload,
              //           finalPayload: payload, // Use live URL in production
              //         ),
              //       ),
              //     );
              //   } else {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('Transaction ID fetch failed')));
              //   }
            }
          },
          child: Obx(() {
            final selectedPayment =
                selectedServicesController.selectedPayment.value;

            final isPayAtHospital =
                selectedPayment.toLowerCase() == 'pay at hospital';
            final buttonText = isPayAtHospital
                ? "BOOK APPOINTMENT (₹ $consultationFee)"
                : "BOOK & PAY (₹ $consultationFee)";

            return Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            );
          }),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Divider(
              height: 1,
              color: secondaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: doctor!.doctorPicture.isNotEmpty
                      ? Image.memory(
                          base64Decode(doctor!.doctorPicture.split(',').last),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "https://via.placeholder.com/150",
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
                        "${doctor!.doctorName}",
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

  String consultationType = "";
  Future<Widget> _getServiceButton(String id) async {
    Color color = Colors.white;
    int consultationFee = 0;

    final consultations = await getConsultationDetails();

    // Find consultation by ID safely
    final matchedConsultation = consultations.firstWhere(
      (c) => c.consultationId == id,
      orElse: () => ConsultationModel(
        consultationId: '',
        consultationType: 'Unknown',
      ),
    );

    consultationType = matchedConsultation.consultationType;

    if (consultationType.toLowerCase().contains('service')) {
      consultationFee = selectedServicesController
          .selectedSubServices.first.finalCost
          .toInt();
    } else if (consultationType.toLowerCase().contains('clinic')) {
      consultationFee = doctor?.doctorFees.inClinicFee ?? 0;
    } else if (consultationType.toLowerCase().contains('online')) {
      consultationFee = doctor?.doctorFees.vedioConsultationFee ?? 0;
    } else {
      consultationFee = 0;
      color = Colors.grey;
    }

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
    DateTime date = DateTime.parse(widget.patient.serviceDate);
    String dayName = DateFormat('EEEE').format(date);
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
                "${dayName}, ${widget.patient.servicetime}",
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "${consultationController.selectedConsultation.value?.consultationId == "ST_01" ? selectedServicesController.selectedSubServices.first.subServiceName : ""}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Price: ₹ ${(fee).toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: mainColor,
                        ),
                        textAlign: TextAlign.center,
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
