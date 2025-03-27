import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Help/Numbers.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Utils/AppointmentCard.dart';
import '../../Utils/DateConverter.dart';
import 'AppointmentService.dart';
import 'BookingModal.dart';

class AppointmentPage extends StatefulWidget {
  final String mobileNumber;

  AppointmentPage({required this.mobileNumber});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with AutomaticKeepAliveClientMixin {
  String _selectedTab = 'UPCOMING'; // Keeps track of the current tab
  List<AppointmentData> allAppointments = [];
  List<AppointmentData> filteredAppointments = [];
  bool isLoading = true;
  final AppointmentService _appointmentService = AppointmentService();
  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final appointments =
        await _appointmentService.fetchAppointments(widget.mobileNumber);
    setState(() {
      allAppointments = appointments;
      isLoading = false;
      _filterAppointments();
    });
  }

  // Prioritize statuses
  Map<String, int> statusPriority = {
    'in_progress': 0,
    'accepted': 1,
    'pending': 2, // Add other statuses if needed
    'completed': 3,
  };

  // Tab mapping
  Map<String, List<int>> tabPriority = {
    'UPCOMING': [0, 1, 2], // in-progress, accepted, pending
    'COMPLETED': [3], // completed
    // 'CANCELLED': [4], // cancelled (if needed)
  };

  List<AppointmentData> _sortAppointments(List<AppointmentData> appointments) {
    if (_selectedTab == 'COMPLETED') {
      appointments.sort((a, b) {
        // Sort by start date of the first service in descending order
        DateTime aDate = parseDate(a.servicesAdded.isNotEmpty
            ? a.servicesAdded.first.startDate
            : "01-01-1970");
        DateTime bDate = parseDate(b.servicesAdded.isNotEmpty
            ? b.servicesAdded.first.startDate
            : "01-01-1970");

        return bDate.compareTo(aDate); // Latest date first
      });
    } else {
      appointments.sort((a, b) {
        // Compare by status from the first service in servicesAdded
        String aStatus = a.servicesAdded.isNotEmpty
            ? a.servicesAdded.first.status.toLowerCase()
            : "unknown";
        String bStatus = b.servicesAdded.isNotEmpty
            ? b.servicesAdded.first.status.toLowerCase()
            : "unknown";

        int aPriority = statusPriority[aStatus] ?? 99;
        int bPriority = statusPriority[bStatus] ?? 99;

        if (aPriority != bPriority) {
          return aPriority.compareTo(bPriority); // Lower priority comes first
        }

        // If statuses are the same, compare by start date of the first service
        DateTime aDate = parseDate(a.servicesAdded.isNotEmpty
            ? a.servicesAdded.first.startDate
            : "01-01-1970");
        DateTime bDate = parseDate(b.servicesAdded.isNotEmpty
            ? b.servicesAdded.first.startDate
            : "01-01-1970");

        return aDate.compareTo(bDate); // Earliest date first
      });
    }
    return appointments;
  }

  void _filterAppointments() {
    setState(() {
      if (tabPriority.containsKey(_selectedTab)) {
        filteredAppointments = allAppointments.where((appointment) {
          // Access the status from the first item in servicesAdded
          final firstServiceStatus = appointment.servicesAdded.isNotEmpty
              ? appointment.servicesAdded.first.status.toLowerCase()
              : "unknown";

          final statusValue = statusPriority[firstServiceStatus] ?? 99;
          return tabPriority[_selectedTab]!.contains(statusValue);
        }).toList();
      }
    });
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
      _filterAppointments(); // Update the filtered list when switching tabs
    });
  }

  Future<void> _onRefresh() async {
    await fetchAppointments();
    print("_onRefresh called for AppointmentPage");
  }

  @override
  Widget build(BuildContext context) {
    List<AppointmentData> sortedAppointments =
        _sortAppointments(filteredAppointments);
    super.build(context);
    return Scaffold(
      appBar: CommonHeader(
        title: "Appointments",
        // onHelpPressed:(){} ,
        onNotificationPressed: () {
          print("Notification called for AppointmentPage");
          fetchAppointments();
        },
        onSettingPressed: () async {
          await whatsUpChat();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildTabButton('UPCOMING', Colors.amber),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: _buildTabButton('COMPLETED', Colors.green),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'MY APPOINTMENTS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B3FA0),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (filteredAppointments.isEmpty
                      ? const Center(child: Text('No appointments found'))
                      : ListView.builder(
                          itemCount: sortedAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = filteredAppointments[index];
                            return buildAppointmentCard(appointment, context);
                          },
                        )),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // Keep the page alive
  Widget _buildTabButton(String tabName, Color activeColor) {
    final bool isSelected = _selectedTab == tabName;

    return GestureDetector(
      onTap: () => _onTabSelected(tabName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 1,
          ),
        ),
        child: Align(
          alignment: Alignment.center, // This will center the text
          child: Text(
            tabName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
