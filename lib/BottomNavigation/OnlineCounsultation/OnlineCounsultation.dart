import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Booings/BooingService.dart';
import '../../Doctors/ListOfDoctors/DoctorController.dart';
import '../../Doctors/ListOfDoctors/DoctorService.dart';
import '../../Utils/AppointmentCard.dart';
import '../Appoinments/PostBooingModel.dart';

class OnlineCounsultation extends StatefulWidget {
  final String mobileNumber;
  OnlineCounsultation({required this.mobileNumber});

  @override
  _OnlineCounsultationState createState() => _OnlineCounsultationState();
}

class _OnlineCounsultationState extends State<OnlineCounsultation> {
  final DoctorController doctorController = Get.put(DoctorController());
  final DoctorService doctorService = DoctorService();

  bool isLoading = true;
  List<PostBookingModel> doctorBookings = [];

  @override
  void initState() {
    super.initState();
    print("📞 initState triggered with mobile number: ${widget.mobileNumber}");
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final bookingsJson = await getBookingsByMobileNumber(widget.mobileNumber);
      print("📥 Received bookings JSON: ${bookingsJson}");

      if (bookingsJson != null && bookingsJson is List) {
        List<PostBookingModel> parsedBookings = [];

        for (var item in bookingsJson) {
          try {
            final booking = PostBookingModel.fromJson(item);
            print(
                "✅ Parsed Booking ConsultationType: ${booking.booking.consultationType}");
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
      } else {
        setState(() {
          isLoading = false;
        });
        print("❌ Error: bookingsJson is not a list or is null");
      }
    } catch (e) {
      print("🚨 Exception during fetch: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    print("🔁 Refresh triggered");
    await fetchBookings();
  }

  List<PostBookingModel> _filteredBookings() {
    return doctorBookings.where((b) {
      final type = b.booking.consultationType.trim().toLowerCase();
      final status = b.booking.status.trim().toLowerCase();
      return type == 'online consultation' && status == 'pending';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: 'Online Consultation',
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: _filteredBookings().isEmpty
                  ? ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 150),
                        Center(child: Text('No Online Consultations found.')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredBookings().length,
                      itemBuilder: (context, index) {
                        final booking = _filteredBookings()[index];
                        return AppointmentCard(
                          doctorData: booking,
                        );
                      },
                    ),
            ),
    );
  }
}
