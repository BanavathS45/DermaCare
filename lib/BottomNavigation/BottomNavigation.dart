import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Dashboard/Dashboard.dart';
import '../Doctors/ListOfDoctors/DoctorController.dart';
import 'Appoinments/Appoinments.dart';
import 'Profile/Profile.dart';
import 'Wellness/Wellness.dart';

class BottomNavController extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final int index;

  const BottomNavController({
    Key? key,
    required this.mobileNumber,
    required this.username,
    required this.index,
  }) : super(key: key);

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  late int _selectedIndex;
  final doctorController = Get.find<DoctorController>();
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    print(
        "doctorController.appointmentCount ${doctorController.appointmentCount}");
    _selectedIndex = widget.index;

    // Initialize pages
    _pages = [
      DashboardScreen(
        mobileNumber: widget.mobileNumber,
        username: widget.username,
      ),
      AppointmentPage(
        mobileNumber: widget.mobileNumber,
      ),
      ProfilePage(
        customerLatitude: 17.368784,
        customerLongitude: 78.524673,
      ),
      WellnessPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF456F62), // Top-left
              Color(0xFF82D1B8), // Bottom-right
            ],
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor:
              Colors.transparent, // Make it transparent to show gradient
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.calendar_month),
                  if (doctorController.appointmentCount.value > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          doctorController.appointmentCount.value > 10
                              ? '10+'
                              : '${doctorController.appointmentCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),

            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.video_call),
                  if (doctorController.appointmentCount.value > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          doctorController.appointmentCount.value > 10
                              ? '10+'
                              : '${doctorController.appointmentCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Video Consultation',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.video_call),
            //   label: 'Video Consultation',
            // ),
          ],
        ),
      ),
    );
  }
}
