import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Utils/Constant.dart';
import '../../Widget/Bottomsheet.dart';
import '../ListOfDoctors/DoctorSlotModel.dart';

class ScheduleController extends GetxController {
  // Language labels for doctor languages
  final Map<String, String> languageLabels = {
    "English": "English",
    "Hindi": "हिन्दी",
    // ... keep all your language mappings ...
  };

  // Reactive state variables
  final currentSlots = <Slot>[].obs;
  final weekDates = <DateTime>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedDayIndex = 0.obs;
  final selectedSlotIndex = (-1).obs;
  final selectedSlotText = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   initializeWeekDates();
  // }

  // void initializeWeekDates() {
  //   final today = DateTime.now();
  //   weekDates.assignAll(
  //       List.generate(7, (index) => today.add(Duration(days: index))))             ;
  //   selectedDate.value = weekDates.first;
  // }
  Future<void> initializeWeekDates() async {
    final today = DateTime.now();
    final generatedDates =
        List.generate(7, (index) => today.add(Duration(days: index)));
    weekDates.assignAll(generatedDates);

    await Future.delayed(Duration.zero); // Allow build to complete
    selectedDate.value = generatedDates.first;

    // ✅ Set day index matching selectedDate
    selectedDayIndex.value = 0;
  }

  @override
  void onReady() {
    super.onReady();
    initializeWeekDates();
  }

  void filterSlotsForSelectedDate(List<DoctorSlot> allSlots) {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final slotsForDate = allSlots
              .firstWhereOrNull((slot) => slot.date == dateStr)
              ?.availableSlots ??
          [];

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

  // void selectDate(DateTime date, List<DoctorSlot> allSlots) {
  //   selectedDate.value = date;
  //   selectedSlotIndex.value = -1;
  //   selectedSlotText.value = '';
  //   _updateSlotsForDate(allSlots, date);
  // }
  // void selectDate(DateTime date, List<DoctorSlot> allSlots) {
  //   final index = weekDates.indexWhere((d) =>
  //       DateFormat('yyyy-MM-dd').format(d) ==
  //       DateFormat('yyyy-MM-dd').format(date));

  //   selectedDate.value = date;
  //   selectedDayIndex.value = index;
  //   selectedSlotIndex.value = -1;
  //   selectedSlotText.value = '';
  //   _updateSlotsForDate(allSlots, date);
  // }
  void selectDate(DateTime date, List<DoctorSlot> allSlots) {
    selectedDate.value = date;
    selectedSlotIndex.value = -1;
    selectedSlotText.value = '';

    // ✅ Set selectedDayIndex to the index of the selected date in weekDates
    final index = weekDates.indexWhere((d) =>
        DateFormat('yyyy-MM-dd').format(d) ==
        DateFormat('yyyy-MM-dd').format(date));
    if (index != -1) {
      selectedDayIndex.value = index;
    }

    _updateSlotsForDate(allSlots, date);
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
