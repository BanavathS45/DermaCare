import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorModel.dart';
import 'package:cutomer_app/PatientsDetails/PatientModel.dart';
import 'package:cutomer_app/ServiceSumarry/ServiceIDModal.dart';
import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import '../Doctors/ListOfDoctors/DoctorService.dart';
import '../Utils/AdreessFormat.dart';

class SuccessScreen extends StatefulWidget {
  final HospitalDoctorModel serviceDetails;
  final Patientmodel patient;
  final String paymentId;

  const SuccessScreen({
    super.key,
    required this.serviceDetails,
    required this.paymentId,
    required this.patient,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  DoctorService service = DoctorService();
  final doctorController = Get.put(DoctorController());

  var getDoctor;

  @override
  void initState() {
    super.initState();
    print("servicesAddedList: ${widget..serviceDetails}");
    getDoctor = service.getDoctorById(widget.serviceDetails.doctor.doctorId);
    doctorController.setDoctorId(widget.serviceDetails.doctor.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: appGradient()),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'Congratulation',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Payment is Successfully',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Thank you for trusting us! Our team is ready to serve you with excellence.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "You have successfully booked an appointment with",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "${widget.serviceDetails.doctor.name}, ${widget.serviceDetails.doctor.qualification}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("${widget.patient.monthYear}",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${widget.patient.dayDate}, ${widget.patient.slot}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(gradient: appGradient()),
        child: TextButton(
          onPressed: () {
            Get.to(
              BottomNavController(
                mobileNumber: widget.serviceDetails.hospital.contactNumber,
                username: widget.serviceDetails.doctor.name,
                index: 1,
              ),
            );
          },
          child: Text(
            "View Booking Details".toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
