import 'package:cutomer_app/ConfirmBooking/ConsultationServices.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/CopyRigths.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Screens/CategoryAndServicesForm.dart';
import '../Utils/GradientTextWidget .dart';
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
  List<ConsultationModel> _consultations = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final consultations = await getConsultationDetails();
      if (consultations.isNotEmpty) {
        setState(() {
          _consultations = consultations;
        });
      }
    });
  }

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
            colors: [Colors.white, secondaryColor, mainColor],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Top Banner
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/DermaText.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 26),
                        Text(
                          "Hi, Welcome",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.white, // Fill color
                          ),
                        ),
                        Text(
                          "${capitalizeEachWord(widget.username)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black45,
                              ),
                            ], // Placeholder color for ShaderMask
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // Buttons Section
                  _consultations.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: _consultations.map((consultation) {
                              return _serviceButton(
                                consultation.consultationType,
                                Colors.white,
                                consultation.consultationId,
                                _getIconForType(consultation.consultationType),
                                consultation,
                              );
                            }).toList(),
                          ),
                        ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Copyrights(
          color: Colors.white,
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    if (type.toLowerCase().contains("clinic")) {
      return Icons.local_hospital_outlined;
    } else if (type.toLowerCase().contains("online")) {
      return Icons.video_call_outlined;
    } else {
      return Icons.medical_services_outlined;
    }
  }

  Widget _serviceButton(String title, Color backgroundColor, String id,
      IconData icon, ConsultationModel consultation) {
    return GestureDetector(
      onTap: () {
        consultationcontroller.setConsultation(consultation);

        showSnackbar("Selected", "$title [$id]", "success");
        String firstId = _consultations.first.consultationId;

        // Check if the 'id' matches the first consultationId in any consultation
        if (firstId == id) {
          Get.to(BottomNavController(
            mobileNumber: widget.mobileNumber,
            username: widget.username,
            index: 0,
          ));
        } else {
          Get.to(CategoryAndServicesForm(
            mobileNumber: widget.mobileNumber,
            username: widget.username,
            consulationType: title,
          ));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
