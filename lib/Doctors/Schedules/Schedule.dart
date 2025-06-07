import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorSlotModel.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Doctors/Schedules/ScheduleController.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/CustomerController.dart';
import '../../PatientsDetails/PatientDetailsFormController.dart';
import '../../PatientsDetails/PatientModel.dart';
import '../../PatientsDetails/PatientsDetails.dart';
import '../../Registration/RegisterController.dart';
import '../../ConfirmBooking/ConfirmBookingDetails.dart';
import '../../ConfirmBooking/ConsultationController.dart';
import '../../Utils/GradintColor.dart';
import '../../Widget/Bottomsheet.dart';

import 'package:intl/intl.dart';

import 'DoctorSlotService.dart';

class ScheduleScreen extends StatefulWidget {
  final HospitalDoctorModel doctorData;
  final String mobileNumber;
  const ScheduleScreen(
      {super.key, required this.doctorData, required this.mobileNumber});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScrollController _dateScrollController = ScrollController();
  // final scheduleController = Get.find<ScheduleController>();

  final scheduleController = Get.find<ScheduleController>();
  final patientdetailsformcontroller = Get.put(Patientdetailsformcontroller());
  final selectedServicesController = Get.find<SelectedServicesController>();
  final consultationController = Get.find<Consultationcontroller>();
  final registercontroller = Get.put(Registercontroller());
  String? id;
  List<DoctorSlot>? slots;

  @override
  void initState() {
    super.initState();
    scheduleController.initializeWeekDates();
    // scheduleController.setDoctorSlots(widget.doctorData.doctor);  //TODO:impement pending

    //  controller.setDoctorSlots(widget.doctor.slots);

    id = consultationController.selectedConsultation.value!.consultationId;
    fetchDoctorSlotsOnce();
    timeslots();
  }

  Future<void> fetchDoctorSlotsOnce() async {
    print("iam calling slots");
    final allSlots = await DoctorSlotService.fetchDoctorSlots(
        widget.doctorData.doctor.doctorId,
        widget.doctorData.hospital.hospitalId);
    scheduleController.filterSlotsForSelectedDate(allSlots);
    print("iam calling doctorId ${widget.doctorData.doctor.doctorId}");
    print("iam calling hospitalId ${widget.doctorData.hospital.hospitalId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Schedule",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month & Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM yyyy')
                        .format(scheduleController.selectedDate.value),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: mainColor),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _dateScrollController.animateTo(
                          _dateScrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),
              showDays(),

              const SizedBox(height: 16),

              const SizedBox(height: 24),
              timeslots(),

              const SizedBox(height: 24),
              Divider(color: secondaryColor),
              const SizedBox(height: 12),
              languagesKnown(),
              Divider(color: secondaryColor),

              PatientDetailsForm(), // ✅ Add your working form here
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: appGradient(),
          ),
          child: TextButton(
              onPressed: () {
                if (patientdetailsformcontroller.formKey.currentState!
                    .validate()) {
                  if (scheduleController.selectedSlotText.value.isNotEmpty) {
                    showSnackbar("Success", "Form Validated", "success");
                    String formattedDate = DateFormat('yyyy-MM-dd')
                        .format(scheduleController.selectedDate.value);
                    PatientModel patientmodel = PatientModel(
                        name: patientdetailsformcontroller.nameController.text,
                        age: patientdetailsformcontroller.ageController.text,
                        gender: registercontroller.selectedGender,
                        bookingFor: patientdetailsformcontroller.selectedFor,
                        problem:
                            patientdetailsformcontroller.notesController.text,
                        monthYear: DateFormat('MMMM dd, yyyy')
                            .format(scheduleController.selectedDate.value),
                        serviceDate: formattedDate,
                        servicetime: scheduleController.selectedSlotText.value,
                        mobileNumber: widget.mobileNumber);

                    print("patientmodel ${patientmodel.toJson()}");
                    Get.to(Confirmbookingdetails(
                      doctor: widget.doctorData,
                      patient: patientmodel,
                    ));
                  } else {
                    showSnackbar("Warning", "Please Select Slot", "warning");
                  }
                } else {
                  showSnackbar("Warning",
                      "Please fill the Patient Details Form", "warning");
                }
              },
              child: Text(
                "CONTINUE",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))),
    );
  }

  languagesKnown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Languages Known",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 20,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.doctorData.doctor.languages.map((lang) {
            String displayText =
                scheduleController.languageLabels[lang] ?? lang;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                displayText,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  timeslots() {
    // final filteredSlots = getFilteredSlots();

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
                    // Handle your action here
                  },
                );
              },
            )
          ],
        ),
        const SizedBox(height: 10),
        scheduleController.currentSlots.isNotEmpty
            ? Column(
                children: List.generate(
                  (scheduleController.currentSlots.length / 4).ceil(),
                  (rowIndex) {
                    final startIndex = rowIndex * 4;
                    final endIndex = (startIndex + 4 <
                            scheduleController.currentSlots.length)
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
                          final actualIndex = startIndex + i;

                          final isSelected = actualIndex ==
                              scheduleController.selectedSlotIndex.value;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: GestureDetector(
                                onTap: () {
                                  if (!isBooked) {
                                    setState(() {
                                      scheduleController.selectSlot(
                                          actualIndex, slotText);
                                    });
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
              )
            : const Text("No available slots",
                style: TextStyle(color: Colors.red)),
      ],
    );
  }

  showDays() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: scheduleController.weekDates.length,
        itemBuilder: (context, index) {
          final date = scheduleController.weekDates[index];
          final isSelected = index == scheduleController.selectedDayIndex;
          return GestureDetector(
            onTap: () async {
              final slots = await DoctorSlotService.fetchDoctorSlots(
                  widget.doctorData.doctor.doctorId,
                  widget.doctorData.hospital.hospitalId);

              setState(() {
                scheduleController.selectedDayIndex = index;
                scheduleController.selectedDate.value = date;
                scheduleController
                    .filterSlotsForSelectedDate(slots); // now typed correctly
              });
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? mainColor : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: mainColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('dd').format(date),
                      style: TextStyle(
                          color: isSelected ? Colors.white : mainColor,
                          fontWeight: FontWeight.bold)),
                  Text(DateFormat('E').format(date).toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : mainColor)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
