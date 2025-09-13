import 'dart:convert';

import 'package:cutomer_app/Booings/BooingService.dart';
import 'package:cutomer_app/Booings/FollowUpModal.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/AppointmentService.dart';
import 'package:cutomer_app/BottomNavigation/Appoinments/GetAppointmentModel.dart';
import 'package:cutomer_app/BottomNavigation/BottomNavigation.dart';
import 'package:cutomer_app/Consultations/SymptomsController.dart';
import 'package:cutomer_app/Dashboard/VisitController.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Doctors/Schedules/DoctorSlotService.dart';
import 'package:cutomer_app/Doctors/Schedules/Schedule.dart';
import 'package:cutomer_app/Doctors/Schedules/ScheduleController.dart';
import 'package:cutomer_app/Screens/BookingSuccess.dart';
import 'package:cutomer_app/Services/GetHospiatlsAndDoctorWithSubService.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ScaffoldMessageSnacber.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:cutomer_app/Widget/Bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../ConfirmBooking/ConsultationPrice.dart';

class VisitType extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final String consulationType;
  final ValueChanged<String> onVisitTypeChanged; // callback
  const VisitType({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.consulationType,
    required this.onVisitTypeChanged,
  });

  @override
  State<VisitType> createState() => _VisitTypeState();
}

HospitalDoctorModel? selectedHospitalDoctor;

class _VisitTypeState extends State<VisitType> {
  final SymptomsController controller = Get.put(SymptomsController());
  final appointmentService = Get.put(AppointmentService());
  final visitController = Get.put(VisitController());
  List<HospitalDoctorModel> hospitalDoctors = [];
  String selectedType = "First Time"; // default
  final scheduleController = Get.find<ScheduleController>();
  bool showAllRows = false;
  final ScrollController _dateScrollController = ScrollController();
  Getappointmentmodel? selectedBooking;

  @override
  @override
  void initState() {
    super.initState();
    _fetchAppointments();
    selectedType = "First Time";
    controller.updateVisitType("First Time");

    fetchHospitalDoctor().then((value) async {
      setState(() => hospitalDoctors = value);

      if (hospitalDoctors.isNotEmpty) {
        final today = scheduleController.weekDates[0]; // first date (today)
        final doctorId = hospitalDoctors.first.doctor.doctorId;
        final clinicId = hospitalDoctors.first.hospital.hospitalId;

        final slots =
            await DoctorSlotService.fetchDoctorSlots(doctorId, clinicId);
        scheduleController.selectDate(today, slots);
      }
    });
  }

  Future<void> _fetchAppointments() async {
    try {
      final appointments = await appointmentService
          .fetchInprogressAppointments(widget.mobileNumber);
      visitController.setBookings(appointments);
      print("jhgjjhjhg L::${appointments.length}");
    } catch (e) {
      print("❌ Error fetching appointments: $e");
    }
  }

  void _handleFirstTime() {
    controller.updateVisitType(selectedType);
    // Get.offAll(() => BottomNavController(
    //       mobileNumber: widget.mobileNumber,
    //       username: widget.username,
    //       index: 0,
    //     ));
  }

  void _handleFollowUp() {
    final screenHeight = MediaQuery.of(context).size.height;
    final appointments = visitController.bookings;
    if (appointments.isEmpty || appointments.length == 0) {
      ScaffoldMessageSnackbar.show(
        context: context,
        message: "No Appointments \n You don’t have any past bookings",
        type: SnackbarType.warning,
      );
      controller.updateVisitType(selectedType);
      return;
    }

    Get.bottomSheet(
      Container(
        height: screenHeight * 0.75,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Select Your Follow-Up Appointment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: visitController.bookings.length,
                  itemBuilder: (_, index) {
                    final Getappointmentmodel appt =
                        visitController.bookings[index];
                    selectedHospitalDoctor = hospitalDoctors.firstWhereOrNull(
                      (doc) => doc.doctor.doctorId == appt.doctorId,
                    );

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.shade300, // light border color
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${capitalizeEachWord(appt.name) ?? "Unknown Patient"}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Relation: ${appt.relation ?? "NA"}"),
                                  Text(
                                      "Clinic: ${selectedHospitalDoctor?.hospital.name ?? "NA"}"),
                                  Text(
                                      "Doctor: ${selectedHospitalDoctor?.doctor.doctorName ?? "-"}"),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Last Consultation: ${appt.serviceDate ?? "-"} ${appt.servicetime ?? "-"}",
                                    style: const TextStyle(
                                        color: Colors.redAccent, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Free Follow-Ups: ${appt.freeFollowUps != null ? appt.freeFollowUps : "0"} ",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    selectedBooking = appt;
                                    Get.back();
                                    final doctor =
                                        hospitalDoctors.firstWhereOrNull(
                                      (doc) =>
                                          doc.doctor.doctorId == appt.doctorId,
                                    );
                                    if (doctor != null &&
                                        doctor
                                            .doctor.doctorAvailabilityStatus) {
                                      Get.bottomSheet(
                                        bottomSlotWidget(
                                            selectedHospitalDoctor!
                                                .hospital.hospitalId,
                                            selectedHospitalDoctor!
                                                .doctor.doctorId,
                                            appt.patientId,
                                            appt.clinicName,
                                            appt.doctorName),
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                      );
                                      controller.updateVisitType(selectedType);
                                    } else {
                                      ScaffoldMessageSnackbar.show(
                                        context: context,
                                        message: "Doctor not Available Now",
                                        type: SnackbarType.warning,
                                      );
                                    }
                                  },
                                  child: const Text("Select"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget bottomSlotWidget(String hospitalId, String doctorId, String patientId,
      String clinicName, String doctorName) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Doctor & Clinic Info Card
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_hospital,
                                  color: Colors.redAccent, size: 22),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  clinicName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  color: Colors.blueAccent, size: 22),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctorName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Heading for Date Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Choose Date",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(">"),
                    ],
                  ),

                  const SizedBox(height: 12),
                  showDays(hospitalId, doctorId),
                  const Divider(height: 32),
                  timeslots(),
                ],
              ),
            ),
          ),

          // Sticky Submit Button
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (scheduleController.selectedSlotIndex.value != -1) {
                    // ✅ Book appointment logic
                    final selectedSlot = scheduleController.currentSlots[
                        scheduleController.selectedSlotIndex.value];
                    Get.back();
                    String formattedDate = DateFormat('yyyy-MM-dd')
                        .format(scheduleController.selectedDate.value);

                    final postBookingPayload = FollowUpModal(
                      bookingId: selectedBooking?.bookingId ?? "",
                      doctorId: selectedBooking?.doctorId ?? "",
                      visitType: selectedType,
                      mobileNumber: widget.mobileNumber, // ✅ always String
                      serviceDate: formattedDate,
                      servicetime: scheduleController.selectedSlotText.value,
                      patientId: patientId,
                    );

                    print(
                        '[DEBUG] Response Data:followUpBookings $postBookingPayload');

                    var resData = await followUpBookings(postBookingPayload);

                    if (resData != null &&
                        (resData['statusCode'] == 200 ||
                            resData['statusCode'] == 201)) {
                      print('[✅] Booking successful');
                      await _fetchAppointments();
                      ScaffoldMessageSnackbar.show(
                        context: context,
                        message:
                            "Appointment Booked \n You booked ${DateFormat('dd MMM').format(scheduleController.selectedDate.value)} ",
                        type: SnackbarType.success,
                      );
                      scheduleController.selectedSlotIndex.value = -1;
                      scheduleController.currentSlots.clear();
                      Get.to(BottomNavController(
                          mobileNumber: widget.mobileNumber,
                          username: widget.username,
                          index: 1));
                    } else {
                      print(
                          '[❌] Booking failed or unexpected response: $resData');
                      ScaffoldMessageSnackbar.show(
                        context: context,
                        message: "Error \n Booking failed",
                        type: SnackbarType.error,
                      );
                      if (resData != null && resData['message'] != null) {
                        ScaffoldMessageSnackbar.show(
                          context: context,
                          message: "Error \n ${resData['message']}",
                          type: SnackbarType.error,
                        );
                      }
                    }
                  } else {
                    ScaffoldMessageSnackbar.show(
                      context: context,
                      message:
                          "No Slot Selected \n Please choose a slot before booking",
                      type: SnackbarType.warning,
                    );
                  }
                },
                child: const Text(
                  "Book Appointment",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose Visit Type",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text("First Time")),
                  selected: selectedType == "First Time",
                  selectedColor: mainColor.withOpacity(0.2),
                  onSelected: (_) {
                    setState(() => selectedType = "First Time");
                    widget.onVisitTypeChanged(selectedType); // notify parent
                    _handleFirstTime();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text("Follow-Up")),
                  selected: selectedType == "Follow-Up",
                  selectedColor: mainColor.withOpacity(0.2),
                  onSelected: (_) {
                    setState(() => selectedType = "Follow-Up");
                    widget.onVisitTypeChanged(selectedType); // notify parent
                    _handleFollowUp();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget timeslots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Available Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.help, size: 20),
              onPressed: () {
                showReportBottomSheet(
                  context: context,
                  title: "Slots",
                  options: [
                    ReportOption(
                        icon: Icons.block,
                        title: "Booked Slot",
                        color: Colors.grey),
                    ReportOption(
                        icon: Icons.check_circle,
                        title: "Currently selected",
                        color: mainColor),
                    ReportOption(
                        icon: Icons.access_time,
                        title: "Available Slots",
                        color: Colors.white),
                  ],
                  onSelected: (selected) {
                    print("User selected: $selected");
                  },
                );
              },
            )
          ],
        ),
        const SizedBox(height: 10),

        // Slots
        Obx(() {
          if (scheduleController.currentSlots.isEmpty) {
            return const Text("No available slots",
                style: TextStyle(color: Colors.red));
          }

          return Column(
            children: [
              // Build rows of 4
              ...List.generate(
                showAllRows
                    ? (scheduleController.currentSlots.length / 4).ceil()
                    : ((scheduleController.currentSlots.length / 4).ceil() > 2
                        ? 2
                        : (scheduleController.currentSlots.length / 4).ceil()),
                (rowIndex) {
                  final startIndex = rowIndex * 4;
                  final endIndex =
                      (startIndex + 4 < scheduleController.currentSlots.length)
                          ? startIndex + 4
                          : scheduleController.currentSlots.length;

                  final rowSlots = scheduleController.currentSlots
                      .sublist(startIndex, endIndex);

                  return Row(
                    children: List.generate(4, (i) {
                      if (i < rowSlots.length) {
                        final slotData = rowSlots[i];
                        final slotText = slotData.slot;
                        final isBooked = slotData.slotbooked;

                        // 👇 Always map to the actual index in the main list
                        final actualIndex = startIndex + i;

                        final isSelected = actualIndex ==
                            scheduleController.selectedSlotIndex.value;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: GestureDetector(
                              onTap: () {
                                if (!isBooked) {
                                  scheduleController.selectSlot(
                                      actualIndex, slotText); // ✅ real index
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isBooked
                                      ? Colors.grey.shade300
                                      : isSelected
                                          ? mainColor
                                          : Colors.white,
                                  border: Border.all(
                                      color:
                                          isBooked ? Colors.grey : mainColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  slotText,
                                  style: TextStyle(
                                    color: isBooked
                                        ? Colors.grey
                                        : isSelected
                                            ? Colors.white
                                            : mainColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Expanded(child: SizedBox(height: 48));
                      }
                    }),
                  );
                },
              ),

              // Toggle view more / less
              if ((scheduleController.currentSlots.length / 4).ceil() > 2)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAllRows = !showAllRows;
                    });
                  },
                  child: Text(
                    showAllRows ? "View Less" : "View More",
                    style: TextStyle(color: mainColor),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget showDays(String clinicId, String doctorId) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: scheduleController.weekDates.length,
        itemBuilder: (context, index) {
          final date = scheduleController.weekDates[index];

          return Obx(() {
            final isSelected =
                index == scheduleController.selectedDayIndex.value;

            return GestureDetector(
              onTap: () async {
                final slots = await DoctorSlotService.fetchDoctorSlots(
                    doctorId, clinicId);
                scheduleController.selectDate(date, slots);
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? mainColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mainColor),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                          color: mainColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                          color: isSelected ? Colors.white : mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      DateFormat('E').format(date).toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : mainColor),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
