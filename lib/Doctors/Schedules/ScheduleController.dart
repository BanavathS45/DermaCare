import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorSlotModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Utils/Constant.dart';
import '../../Widget/Bottomsheet.dart';
import '../ListOfDoctors/DoctorModel.dart';
import 'Schedule.dart';

class ScheduleController extends GetxController {
  /// Language labels for doctor languages
  final Map<String, String> languageLabels = {
    "English": "English",
    "Hindi": "हिन्दी",
    "Telugu": "తెలుగు",
    "Urdu": "اردو",
    "Marathi": "मराठी",
    "Kannada": "ಕನ್ನಡ",
    "Gujarati": "ગુજરાતી",
    "Tamil": "தமிழ்",
    "Bengali": "বাংলা",
    "Punjabi": "ਪੰਜਾਬੀ",
    "Malayalam": "മലയാളം",
    "Odia": "ଓଡ଼ିଆ",
    "Assamese": "অসমীয়া",
    "Konkani": "कोंकणी",
    "Manipuri": "মৈতৈলোন্",
    "Santali": "ᱥᱟᱱᱛᱟᱲᱤ",
    "Bodo": "बर'",
    "Kashmiri": "کٲشُر",
    "Dogri": "ڈوگری",
    "Maithili": "मैथिली",
    "Sindhi": "سنڌي",
    "Sanskrit": "संस्कृतम्",
    "Nepali": "नेपाली",
    "Tulu": "ತುಳು",
    "Bhili": "भीली",
    "Khasi": "Khasi",
    "Mizo": "Mizo",
    "Garo": "Garo",
    "Nagamese": "Nagamese",
    "Ladakhi": "ལ་དྭགས་སྐད།",
    // Add more tribal/regional languages as needed
  };

 

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<Slot> currentSlots = <Slot>[].obs;
  final RxInt selectedSlotIndex = (-1).obs;
  final RxString selectedSlotText = ''.obs;
  List<Map<String, dynamic>> timeSlots = [];
  int selectedDayIndex = 0;
  List<DateTime> weekDates = [];

  void initializeWeekDates() {
    final today = DateTime.now();
    weekDates = List.generate(7, (index) => today.add(Duration(days: index)));
    selectedDate.value = weekDates[0];
  }

  // void setDoctorSlots(List<DoctorSlot> allSlots) {
  //   final date = selectedDate.value;
  //   final dateStr = DateFormat('yyyy-MM-dd').format(date);

  //   final slotsForDate =
  //       allSlots.firstWhereOrNull((e) => e.date == dateStr)?.availableSlots ??
  //           [];

  //   // 🕐 Filter only if selected date is today
  //   if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == dateStr) {
  //     final now = DateTime.now();

  //     final filtered = slotsForDate.where((slot) {
  //       final slotTime = _parseSlotTime(slot.slot);
  //       return slotTime.isAfter(now);
  //     }).toList();

  //     currentSlots.assignAll(filtered);
  //   } else {
  //     currentSlots.assignAll(slotsForDate);
  //   }
  // }

  void filterSlotsForSelectedDate(List<DoctorSlot> allSlots) {
  final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);

  final slotsForDate = allSlots.firstWhereOrNull(
    (slot) => slot.date == dateStr,
  )?.availableSlots ?? [];

  if (dateStr == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
    final now = DateTime.now();
    currentSlots.assignAll(
      slotsForDate.where((slot) {
        final slotTime = _parseSlotTime(slot.slot);
        return slotTime.isAfter(now);
      }).toList(),
    );
  } else {
    currentSlots.assignAll(slotsForDate);
  }
}


  DateTime _parseSlotTime(String slot) {
    final date = selectedDate.value;
    final parsedTime = DateFormat('hh:mm a').parse(slot); // e.g. "01:00 PM"
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  void selectDate(DateTime date, List<DoctorSlot> allSlots) {
    selectedDate.value = date;
    selectedSlotIndex.value = -1;
    selectedSlotText.value = '';
    _updateSlotsForDate(allSlots, date);
  }

  void _updateSlotsForDate(List<DoctorSlot> allSlots, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final slotData =
        allSlots.firstWhereOrNull((e) => e.date == dateStr)?.availableSlots ??
            [];
    currentSlots.assignAll(slotData);
  }

  void selectSlot(int index, String slotText) {
    selectedSlotIndex.value = index;
    selectedSlotText.value = slotText;
  }

  void showReportBottomSheet({
    required BuildContext context,
    required String title,
    required List<ReportOption> options,
    void Function(String selected)? onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 20),
              ...options.map((option) => ListTile(
                    // leading: Icon(option.icon, color: Colors.redAccent),
                    title: Text(option.title),
                    onTap: () {
                      Navigator.pop(context);
                      if (onSelected != null) {
                        onSelected(option.title);
                      }
                    },
                  )),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
