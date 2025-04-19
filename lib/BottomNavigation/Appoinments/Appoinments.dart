import 'package:cutomer_app/BottomNavigation/Appoinments/PostBooingModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../APIs/BaseUrl.dart';
import '../../Booings/BooingService.dart';
import '../../Doctors/ListOfDoctors/DoctorController.dart';
import '../../Doctors/ListOfDoctors/DoctorModel.dart';
import '../../Doctors/ListOfDoctors/DoctorService.dart';
import '../../Help/Numbers.dart';
import '../../Utils/AppointmentCard.dart';
import '../../Utils/Header.dart';

class AppointmentPage extends StatefulWidget {
  final String mobileNumber;

  AppointmentPage({required this.mobileNumber});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with AutomaticKeepAliveClientMixin {
  final DoctorController doctorController = Get.put(DoctorController());
  final DoctorService doctorService = DoctorService();

  bool isLoading = true;

  String _selectedTab = 'UPCOMING';

  @override
  void initState() {
    super.initState();
    // _fetchDoctor();
    fetchBookings();
  }

  List<PostBookingModel> doctorBookings = [];

  void fetchBookings() async {
    final bookingsJson =
        await getBookingsByDoctorId(doctorController.doctorId.toString());
    print("Received bookings JSON: $bookingsJson");

    if (bookingsJson != null && bookingsJson is List) {
      List<PostBookingModel> parsedBookings = [];
      for (var item in bookingsJson) {
        try {
          final booking = PostBookingModel.fromJson(item);
          parsedBookings.add(booking);
        } catch (e, st) {
          print("❌ Failed to parse booking: $e");
          print("Stack trace: $st");
          print("❗ Faulty item: $item");
        }
      }

      setState(() {
        doctorBookings = parsedBookings;
        isLoading = false;
      });

      print("✅ Parsed doctor bookings: $doctorBookings");
    } else {
      setState(() {
        isLoading = false;
      });
      print("❌ Error: bookingsJson is not a list or is null");
    }
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  Future<void> _onRefresh() async {
    // await _fetchDoctor();
    print("_onRefresh called for AppointmentPage");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CommonHeader(
        title: "Appointments",
        onNotificationPressed: () {},
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
                  Expanded(child: _buildTabButton('UPCOMING', Colors.amber)),
                  const SizedBox(width: 10.0),
                  Expanded(child: _buildTabButton('COMPLETED', Colors.green)),
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : doctorBookings.isEmpty
                    ? const Center(child: Text('No bookings found'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: doctorBookings.length,
                          itemBuilder: (context, index) {
                            final booking = doctorBookings[index];
                            return AppointmentCard(
                              doctorData:
                                  booking, // Assuming your AppointmentCard takes a BookingDetailsModel
                            );
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }

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
          alignment: Alignment.center,
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

  @override
  bool get wantKeepAlive => true;
}
