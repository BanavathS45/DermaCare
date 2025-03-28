class Patientmodel {
  final String patientName;
  final String patientAge;
  final String gender;
  final String bookingFor;
  final String problem;
  final String monthYear;
  final String dayDate;
  final String slot;

  Patientmodel(
      {required this.patientName,
      required this.monthYear,
      required this.dayDate,
      required this.slot,
      required this.patientAge,
      required this.gender,
      required this.bookingFor,
      required this.problem});

  factory Patientmodel.fromJson(Map<String, dynamic> json) {
    return Patientmodel(
      patientName: json['patientName'],
      patientAge: json['patientAge'],
      gender: json['gender'],
      bookingFor: json['bookingFor'],
      problem: json['problem'],
      monthYear: json['monthYear'],
      dayDate: json['dayDate'],
      slot: json['slot'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'patientAge': patientAge,
      'gender': gender,
      'bookingFor': bookingFor,
      'problem': problem,
      'monthYear': monthYear,
      'dayDate': dayDate,
      'slot': slot,
    };
  }
}
