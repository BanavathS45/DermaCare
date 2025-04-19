import 'package:cutomer_app/BottomNavigation/Appoinments/PostBooingModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
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
import 'AppointmentController.dart';

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

  Future<void> fetchBookings() async {
    final bookingsJson = await getBookingsByMobileNumber(widget.mobileNumber);
    print("Received bookings JSON: ${bookingsJson}");
    print("Received bookings JSON: ${widget.mobileNumber}");

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

      print("✅ Parsed doctor bookings: ${doctorBookings}");
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
    await fetchBookings();
    print("_onRefresh called for AppointmentPage");
  }

  List<PostBookingModel> _filteredBookings() {
    if (_selectedTab == 'UPCOMING') {
      return doctorBookings.where((b) {
        final status = b.booking.status.toLowerCase();
        final consultationType = b.booking.consultationType.toLowerCase();

        return (status == 'pending' || status == 'confirmed') &&
            consultationType != 'online consultation';
      }).toList();
    } else if (_selectedTab == 'COMPLETED') {
      return doctorBookings
          .where((b) => b.booking.status.toLowerCase() == 'completed')
          .toList();
    } else {
      return doctorBookings;
    }
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
                  Expanded(child: _buildTabButton('UPCOMING', mainColor)),
                  const SizedBox(width: 10.0),
                  Expanded(child: _buildTabButton('COMPLETED', secondaryColor)),
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
                  color: mainColor,
                ),
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBookings().isEmpty
                    ? const Center(
                        child: Text('No bookings found for this tab'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _filteredBookings().length,
                          itemBuilder: (context, index) {
                            final booking = _filteredBookings()[index];
                            return AppointmentCard(
                              doctorData: booking,
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
