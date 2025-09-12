import 'package:cutomer_app/ConfirmBooking/ConsultationServices.dart';
import 'package:cutomer_app/Dashboard/DashBoardController.dart';
import 'package:cutomer_app/Dashboard/VisitType.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/CopyRigths.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Consultations/SymptomsForm.dart';
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
  bool loading = true;
  bool showConsultationOptions = false;
  final dashboardcontroller = Get.put(Dashboardcontroller());

  @override
  void initState() {
    super.initState();
    dashboardcontroller.setMobileNumber(widget.mobileNumber);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final consultations = await getConsultationDetails();
      setState(() {
        _consultations = consultations;
        loading = false;
      });
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
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
                              'assets/ic_launcher.png',
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
                            color: Colors.white,
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  loading
                      ? Center(child: CircularProgressIndicator())
                      : _consultations.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Center(
                                child: Text(
                                  "No service available",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: _buildFilteredConsultationButtons(),
                              ),
                            ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
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

  List<Widget> _buildFilteredConsultationButtons() {
    List<Widget> buttons = [];
    List<ConsultationModel> staticOptions = _consultations
        .where(
            (e) => e.consultationType.toLowerCase() == "services & treatments")
        .toList();

    List<ConsultationModel> dynamicOptions = _consultations
        .where((e) =>
            e.consultationType.toLowerCase().contains('clinic') ||
            e.consultationType.toLowerCase().contains('online'))
        .toList();

    buttons.addAll(staticOptions.map((consultation) => _serviceButton(
          consultation.consultationType,
          Colors.white,
          consultation.consultationId,
          _getIconForType(consultation.consultationType),
          consultation,
        )));

    buttons.add(_serviceButton(
      'Consultations',
      Colors.white,
      'show_more',
      Icons.expand_more,
      ConsultationModel(
          consultationId: 'show_more', consultationType: 'Consultation'),
    ));

    if (showConsultationOptions) {
      buttons.addAll(dynamicOptions.map((consultation) => _serviceButton(
            consultation.consultationType,
            Colors.white,
            consultation.consultationId,
            _getIconForType(consultation.consultationType),
            consultation,
          )));
    }

    return buttons;
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
      onTap: () async {
        if (id == 'show_more') {
          setState(() => showConsultationOptions = !showConsultationOptions);
          return;
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        if (_consultations.isNotEmpty &&
            !prefs.containsKey('firstConsultationId')) {
          await prefs.setString(
              'firstConsultationId', _consultations.first.consultationId);
          await prefs.setString(
              'firstConsultationType', _consultations.first.consultationType);
        }

        consultationcontroller.setConsultation(consultation);

        String? firstId = _consultations.isNotEmpty
            ? _consultations.first.consultationId
            : null;

        if (firstId != null && firstId == id) {
          Get.to(VisitType(
            mobileNumber: widget.mobileNumber,
            username: widget.username,
            consulationType: consultation.consultationType,
          ));
          // Get.to(BottomNavController(
          //   mobileNumber: widget.mobileNumber,
          //   username: widget.username,
          //   consultation: consultation,
          //   index: 0,
          // ));
        } else {
          Get.to(SymptomsForm(
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
            id != 'show_more'
                ? const Icon(Icons.arrow_forward_ios, color: Colors.white)
                : Icon(icon, color: Colors.white), // or SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
