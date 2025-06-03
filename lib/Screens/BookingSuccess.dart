import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/PatientsDetails/PatientModel.dart';
import 'package:cutomer_app/Utils/GradintColor.dart';
import 'package:cutomer_app/Utils/MapOnGoogle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Doctors/DoctorDetails/DoctorDetailsController.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import '../Doctors/ListOfDoctors/DoctorService.dart';
import '../Help/Numbers.dart';

class SuccessScreen extends StatefulWidget {
  final HospitalDoctorModel serviceDetails;
  final PatientModel patient;
  final String paymentId;
  final String mobileNumber;
  const SuccessScreen({
    super.key,
    required this.serviceDetails,
    required this.paymentId,
    required this.patient,
    required this.mobileNumber,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  DoctorService service = DoctorService();
  final doctorController = Get.put(DoctorController());
  Doctordetailscontroller doctordetailscontroller = Doctordetailscontroller();
  var getDoctor;

  @override
  void initState() {
    super.initState();
    print("servicesAddedList: ${widget..serviceDetails}");
    // getDoctor = service.getDoctorById(widget.serviceDetails.doctor.doctorId);
    // doctorController.setDoctorId(widget.serviceDetails.doctor.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                            "${widget.serviceDetails.doctor.doctorName}, ${widget.serviceDetails.doctor.qualification}",
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
                                    "${widget.patient.serviceDate}, ${widget.patient.servicetime}",
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
                  doctordetailscontroller.buildTimingAndContactSection(
                      timing: widget.serviceDetails.doctor.availableTimes,
                      // doctor: doctor,
                      onCall: () {
                        customerCare();
                      },
                      onDirection: () {
                        String address =
                            "${widget.serviceDetails.hospital.name},${widget.serviceDetails.hospital.address}";
                        MapUtils.openMapByAddress(address);
                      },
                      hospitalNumber:
                          widget.serviceDetails.hospital.contactNumber,
                      days: widget.serviceDetails.doctor.availableDays),
                ],
              ),
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
            Get.offAll(
              BottomNavController(
                mobileNumber: widget.mobileNumber,
                username: widget.serviceDetails.doctor.doctorName,
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
