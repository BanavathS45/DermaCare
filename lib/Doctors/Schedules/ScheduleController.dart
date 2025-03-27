import 'package:get/get.dart';

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

  /// Currently selected indices
  int selectedDayIndex = 0;
  int selectedSlotIndex = -1;

  /// List of 7 dates from today
  List<DateTime> weekDates = [];

  /// The date corresponding to selectedDayIndex
  // DateTime selectedDate = DateTime.now();

  /// List of time slots (with booking info)
  // List<Map<String, dynamic>> timeSlots = [];

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
}
