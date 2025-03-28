import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Constant.dart';
import '../../Widget/Bottomsheet.dart';
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

  List<Map<String, dynamic>> timeSlots = [];

  DateTime selectedDate = DateTime.now();
  var selectedSlotText = "".obs;

  /// Currently selected indices
  int selectedDayIndex = 0;
  int selectedSlotIndex = -1;

  /// List of 7 dates from today
  List<DateTime> weekDates = [];

 

  /// Initialize 7-day calendar
  void initializeWeekDates() {
    final today = DateTime.now();
    weekDates = List.generate(7, (index) => today.add(Duration(days: index)));
    selectedDate = weekDates[0];
  }

  /// Set time slots from doctor data (like availableSlots)
  void setTimeSlots(List<Map<String, dynamic>> slots) {
    timeSlots = slots;
  }

  /// Select a date by index
  void selectDate(int index) {
    selectedDayIndex = index;
    selectedDate = weekDates[index];
  }

  /// Select a time slot by index
  void selectSlot(int index) {
    selectedSlotIndex = index;
  }

  /// Reset all selections
  void reset() {
    selectedDayIndex = 0;
    selectedSlotIndex = -1;
    selectedDate = weekDates.isNotEmpty ? weekDates[0] : DateTime.now();
    timeSlots.clear();
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
