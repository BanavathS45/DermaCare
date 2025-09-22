import 'package:cutomer_app/Doctors/Schedules/DoctorSlotService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Constant.dart';
import '../../Widget/Bottomsheet.dart';
import '../ListOfDoctors/DoctorSlotModel.dart';

class ScheduleController extends GetxController {
  // Language labels for doctor languages
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

  // Reactive state variables
  final currentSlots = <Slot>[].obs;
  final weekDates = <DateTime>[].obs;
  final selectedDate = DateTime.now().obs;
  RxInt selectedDayIndex = 0.obs;

  final selectedSlotIndex = (-1).obs;
  final selectedSlotText = ''.obs;

  Future<void> initializeWeekDates() async {
    final now = DateTime.now();

    // Normalize to start of the day (00:00)
    final today = DateTime(now.year, now.month, now.day);

    final generatedDates =
        List.generate(15, (index) => today.add(Duration(days: index)));

    weekDates.assignAll(generatedDates);

    await Future.delayed(Duration.zero);

    selectedDate.value = generatedDates.first;
    selectedDayIndex.value = 0;
  }

  void scheduleMidnightRefresh({
    required String doctorId,
    required String hospitalId,required String branchId
  }) {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    Future.delayed(durationUntilMidnight, () async {
      print("⏰ Refreshing slots after midnight...");
      // final prefs = await SharedPreferences.getInstance();
      // var branchId = await prefs.getString('branchId');
      await initializeWeekDates();
      final slots = await DoctorSlotService.fetchDoctorSlots(
          doctorId, hospitalId, branchId);
      filterSlotsForSelectedDate(slots);

      // Schedule again for the next night
      scheduleMidnightRefresh(doctorId: doctorId, hospitalId: hospitalId, branchId: branchId);
    });
  }

  @override
  void onReady() {
    super.onReady();
    initializeWeekDates();
  }

  void filterSlotsForSelectedDate(List<DoctorSlot> allSlots) {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      print("slotsForDate : ${dateStr}");

      final slotsForDate = allSlots
              .firstWhereOrNull((slot) => slot.date == dateStr)
              ?.availableSlots ??
          [];
      print("slotsForDate : ${slotsForDate}");

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
    } catch (e) {
      currentSlots.clear();
      print('Error filtering slots: $e');
    }
  }

  DateTime _parseSlotTime(String slot) {
    try {
      final date = selectedDate.value;
      final parsedTime = DateFormat('hh:mm a').parse(slot);
      return DateTime(
        date.year,
        date.month,
        date.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      print('Error parsing slot time: $e');
      return DateTime.now().add(const Duration(hours: 1));
    }
  }

  void selectDate(DateTime date, List<DoctorSlot> allSlots) {
    selectedDate.value = date;
    selectedSlotIndex.value = -1;
    selectedSlotText.value = '';

    final index = weekDates.indexWhere((d) =>
        DateFormat('yyyy-MM-dd').format(d) ==
        DateFormat('yyyy-MM-dd').format(date));
    if (index != -1) {
      selectedDayIndex.value = index;
      selectedDayIndex.refresh(); // ✅ Force rebuild
      print("selectedDayIndex updated: $index");
    }

    filterSlotsForSelectedDate(allSlots);
  }

  void _updateSlotsForDate(List<DoctorSlot> allSlots, DateTime date) {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final slotData =
          allSlots.firstWhereOrNull((e) => e.date == dateStr)?.availableSlots ??
              [];
      currentSlots.assignAll(slotData);
    } catch (e) {
      currentSlots.clear();
      print('Error updating slots: $e');
    }
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
                    title: Text(option.title),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected?.call(option.title);
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
