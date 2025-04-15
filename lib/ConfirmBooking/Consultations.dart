import 'package:cutomer_app/Utils/CopyRigths.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Screens/CategoryAndServicesForm.dart';
import 'ConfirmBookingDetails.dart';
import 'ConsultationController.dart';

class ConsultationsType extends StatefulWidget {
  final String mobileNumber;
  final String username;

  const ConsultationsType({
    super.key,
    required this.mobileNumber,
    required this.username,
  });

  @override
  ConsultationsTypeState createState() => ConsultationsTypeState();
}

class ConsultationsTypeState extends State<ConsultationsType> {
  final consultationcontroller = Get.find<Consultationcontroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF679B75),
              Color(0xFF84D8C1),
              Color(0xFFCFAF96),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Top Banner
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Container(
                            width: 110,
                            height: 98,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                "https://storage.googleapis.com/tagjs-prod.appspot.com/85ADYlVskG/hiota0r5.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Dermatology center",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 36),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Daily skincare is essential to maintain healthy, glowing skin and prevent premature aging.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 46),
                          const Text(
                            "Welcome ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Fill color
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${capitalizeFirstLetter(widget.username)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Fill color
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),

                    // Buttons Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          _serviceButton("Services and Treatments",
                              const Color(0xFF426C5F), 1),
                          _serviceButton(
                              "In-Clinic", const Color(0xFF679B75), 2),
                          _serviceButton(
                              "Video Consultation", const Color(0xFFCFAF96), 3),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Copyrights(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _serviceButton(String title, Color backgroundColor, int id) {
    return GestureDetector(
      onTap: () {
        switch (id) {
          case 1:
            showSnackbar("Success", "Service and Treatment ${id}", "success");

            consultationcontroller.setConsultationId(1);

            Get.offAll(BottomNavController(
              mobileNumber: widget.mobileNumber,
              username: widget.username,
              index: 0,
            ));
            break;
          case 2:
            consultationcontroller.setConsultationId(2);
            showSnackbar("Warning", "In-Clinic ${id}", "warning");
            Get.to(CategoryAndServicesForm(
               mobileNumber: widget.mobileNumber,
              username: widget.username,
                // doctor: widget.doctorData,
                ));
            break;
          case 3:
            consultationcontroller.setConsultationId(3);
            showSnackbar("Success", "Video Consultation ${id}", "success");
            Get.to(CategoryAndServicesForm(
               mobileNumber: widget.mobileNumber,
              username: widget.username,
                // doctor: widget.doctorData,
                ));
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 11,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
