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
  final String? notes;
  final List<Report>? reports;

  PatientModel(
      {required this.name,
      required this.monthYear,
      required this.serviceDate,
      required this.servicetime,
      required this.mobileNumber,
      required this.age,
      required this.gender,
      required this.bookingFor,
      this.notes,
      this.reports,
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
      notes: json['notes'] ?? "",
      reports: json['reports'] != null
          ? List<Report>.from(
              json['reports'].map((x) => Report.fromJson(x)),
            )
          : null,
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

class Report {
  final String reportId;
  final String reportName;
  final String reportDate;
  final String reportStatus;
  final String reportType;
  final String reportFile;

  Report({
    required this.reportId,
    required this.reportName,
    required this.reportDate,
    required this.reportStatus,
    required this.reportType,
    required this.reportFile,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['reportId'],
      reportName: json['reportName'],
      reportDate: json['reportDate'],
      reportStatus: json['reportStatus'],
      reportType: json['reportType'],
      reportFile: json['reportFile'],
    );
  }
}
