import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import '../../Widget/Bottomsheet.dart';
import '../ListOfDoctors/DoctorModel.dart';
import 'package:intl/intl.dart';
import 'scheduleController.dart';

class ScheduleScreen extends StatefulWidget {
  final HospitalDoctorModel doctorData;

  const ScheduleScreen({super.key, required this.doctorData});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScrollController _dateScrollController = ScrollController();
  ScheduleController scheduleController = ScheduleController();

  @override
  void initState() {
    super.initState();
    scheduleController.initializeWeekDates();
    scheduleController.setTimeSlots(
        widget.doctorData.doctor.availableSlots); // default selected
  }

  TimeOfDay parseTimeOfDay(String timeStr) {
    timeStr = timeStr
        .replaceAll(RegExp(r'[\u00A0\u202F\u200B\uFEFF]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final format = DateFormat.jm(); // expects "hh:mm a"
    final dt = format.parse(timeStr);
    return TimeOfDay.fromDateTime(dt);
  }

  List<Map<String, dynamic>> getFilteredSlots() {
    final isToday = DateUtils.isSameDay(
      scheduleController.selectedDate,
      DateTime.now(),
    );

    final now = TimeOfDay.now();

    List<Map<String, dynamic>> rawSlots = scheduleController.timeSlots;

    final cleaned = rawSlots.where((slot) {
      final timeStr = slot["slot"] ?? "";
      try {
        final slotTime = parseTimeOfDay(timeStr);

        if (!isToday) return true;

        // Only keep future slots if today
        return (slotTime.hour > now.hour) ||
            (slotTime.hour == now.hour && slotTime.minute > now.minute);
      } catch (e) {
        print("❌ Failed to parse: $timeStr → $e");
        return false;
      }
    }).toList();

    print(
        "✅ Filtered Slots (${isToday ? 'Today' : 'Future'}): ${cleaned.length}");
    for (var slot in scheduleController.timeSlots) {
      print("🕒 Slot: ${slot["slot"]}, booked: ${slot["slotbooked"]}");
    }
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Schedule",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Month & Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy')
                      .format(scheduleController.selectedDate),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right, color: mainColor),
                  onPressed: () {
                    _dateScrollController.animateTo(
                      _dateScrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  },
                )
              ],
            ),

            // Date row
            showDays(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(
                          scheduleController.selectedDate), // e.g., March 2025
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, dd MMMM').format(scheduleController
                          .selectedDate), // e.g., Tuesday, 26 March
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Available Time Title

            timeslots(),
            SizedBox(
              height: 20,
            ),

            Divider(
              height: 3,
              color: secondaryColor,
            ),
            languagesKnown(),
            Divider(
              height: 3,
              color: secondaryColor,
            ),
          ],
        ),
      ),
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
          children: widget.doctorData.doctor.languagesKnown.map((lang) {
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

  Widget timeslots() {
    final filteredSlots = getFilteredSlots();

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
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Slot Info"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ReportOption(title: "Booked Slot", color:  Colors.grey),
                        // ReportOption(title: "Currently Selected", color:  Colors.blue),
                        // ReportOption(title:"Available Slot", color:  Colors.white),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
        const SizedBox(height: 10),
        filteredSlots.isNotEmpty
            ? Column(
                children: List.generate(
                  (filteredSlots.length / 4).ceil(),
                  (rowIndex) {
                    final startIndex = rowIndex * 4;
                    final endIndex = (startIndex + 4 < filteredSlots.length)
                        ? startIndex + 4
                        : filteredSlots.length;
                    final rowSlots =
                        filteredSlots.sublist(startIndex, endIndex);

                    return Row(
                      children: List.generate(4, (i) {
                        if (i < rowSlots.length) {
                          final slotData = rowSlots[i];
                          final slotText = slotData["slot"];
                          final isBooked = slotData["slotbooked"] == true;
                          final actualIndex =
                              scheduleController.timeSlots.indexOf(slotData);
                          final isSelected = actualIndex ==
                              scheduleController.selectedSlotIndex;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: GestureDetector(
                                onTap: () {
                                  if (!isBooked) {
                                    setState(() {
                                      scheduleController.selectedSlotIndex =
                                          actualIndex;
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
                                            ? Colors.blue
                                            : Colors.white,
                                    border: Border.all(
                                      color:
                                          isBooked ? Colors.grey : Colors.blue,
                                    ),
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
                                              : Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Expanded(
                            child: SizedBox(height: 48),
                          );
                        }
                      }),
                    );
                  },
                ),
              )
            : const Text(
                "No available slots",
                style: TextStyle(color: Colors.red),
              ),
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
            onTap: () {
              setState(() {
                scheduleController.selectedDayIndex = index;
                scheduleController.selectedDate = date;
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
