import 'package:flutter/material.dart';
import '../Dashboard/Dashboard.dart';
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

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Wellness',
            ),
          ],
        ),
      ),
    );
  }
}
