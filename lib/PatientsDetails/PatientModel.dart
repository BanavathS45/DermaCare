class PatientModel {
  final String name;
  final String age;
  final String gender;
  final String bookingFor;
  final String mobileNumber;
  final String problem;
  final String monthYear;
  final String serviceDate;
  final String servicetime;

  PatientModel(
      {required this.name,
      required this.monthYear,
      required this.serviceDate,
      required this.servicetime,
      required this.mobileNumber,
      required this.age,
      required this.gender,
      required this.bookingFor,
      required this.problem});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      bookingFor: json['bookingFor'] ?? '',
      problem: json['problem'] ?? '',
      monthYear: json['sele'] ?? json['monthYear'] ?? '',
      serviceDate: json['serviceDate']?.toString() ?? '',
      servicetime: json['servicetime']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'age': age,
      'gender': gender,
      'bookingFor': bookingFor,
      'problem': problem,
      'monthYear': monthYear,
      'serviceDate': serviceDate,
      'servicetime': servicetime,
    };
  }
}
