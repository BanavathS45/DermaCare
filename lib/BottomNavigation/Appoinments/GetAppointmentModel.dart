// class Getappointmentmodel {
//   final String bookingId;
//   final String bookingFor;
//   final String name;
//   final int age;
//   final String gender;
//   final String mobileNumber;
//   final String problem;
//   final String subServiceName;
//   final String subServiceId;
//   final String doctorId;
//   final String clinicId;
//   final String serviceDate;
//   final String servicetime;
//   final String consultationType;
//   final double consultationFee;
//   final String? channelId;
//   final String status;
//   final double totalFee;
//   final String bookeAt;

//   Getappointmentmodel({
//     required this.bookingId,
//     required this.bookingFor,
//     required this.name,
//     required this.age,
//     required this.gender,
//     required this.mobileNumber,
//     required this.problem,
//     required this.subServiceName,
//     required this.subServiceId,
//     required this.doctorId,
//     required this.clinicId,
//     required this.serviceDate,
//     required this.servicetime,
//     required this.consultationType,
//     required this.consultationFee,
//     required this.channelId,
//     required this.status,
//     required this.totalFee,
//     required this.bookeAt,
//   });

//   /// Deserialize from JSON
//   factory Getappointmentmodel.fromJson(Map<String, dynamic> json) {
//     return Getappointmentmodel(
//       bookingId: json['bookingId'] ?? '',
//       bookingFor: json['bookingFor'] ?? '',
//       name: json['name'] ?? '',
//       age: int.tryParse(json['age'].toString()) ?? 0,
//       gender: json['gender'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       problem: json['problem'] ?? '',
//       subServiceName: json['subServiceName'] ?? '',
//       subServiceId: json['subServiceId'] ?? '',
//       doctorId: json['doctorId'] ?? '',
//       clinicId: json['clinicId'],
//       serviceDate: json['serviceDate'] ?? '',
//       servicetime: json['servicetime'] ?? '',
//       consultationType: json['consultationType'] ?? '',
//       consultationFee:
//           double.tryParse(json['consultationFee'].toString()) ?? 0.0,
//       channelId: json['channelId'],
//       status: json['status'] ?? '',
//       totalFee: double.tryParse(json['totalFee'].toString()) ?? 0.0,
//       bookeAt: json['bookeAt'] ?? '',
//     );
//   }

//   /// Serialize to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'bookingId': bookingId,
//       'bookingFor': bookingFor,
//       'name': name,
//       'age': age,
//       'gender': gender,
//       'mobileNumber': mobileNumber,
//       'problem': problem,
//       'subServiceName': subServiceName,
//       'subServiceId': subServiceId,
//       'doctorId': doctorId,
//       'clinicId': clinicId,
//       'serviceDate': serviceDate,
//       'servicetime': servicetime,
//       'consultationType': consultationType,
//       'consultationFee': consultationFee,
//       'channelId': channelId,
//       'status': status,
//       'totalFee': totalFee,
//       'bookeAt': bookeAt,
//     };
//   }
// }

class Getappointmentmodel {
  final String bookingId;
  final String bookingFor;
  final String name;
  final String age;
  final String gender;
  final String mobileNumber;
  final String problem;
  final String subServiceName;
  final String subServiceId;
  final String doctorId;
  final String clinicId;
  final String serviceDate;
  final String servicetime;
  final String consultationType;
  final double consultationFee;
  final String? channelId;
  final String? reasonForCancel;
  final String? notes; // ✅ make nullable
  final List<Reports>? reports; // instead of single Reports?

  final String status;
  final double totalFee;
  final String bookedAt;
  final String? relation;
  final String patientId;
  final int freeFollowUps;
  final String clinicName;
  final String doctorName;
  final String? priscriptionPdf;
  final int freeFollowUpsLeft;
  // final String customerId;
  final String? branchname;
  final String? branchId;
  final String? consentFormPdf;
  final String? doctorRefCode;

  Getappointmentmodel(
      {required this.bookingId,
      required this.relation,
      required this.bookingFor,
      required this.name,
      required this.age,
      required this.gender,
      required this.mobileNumber,
      required this.problem,
      required this.subServiceName,
      required this.subServiceId,
      required this.doctorId,
      required this.clinicId,
      required this.serviceDate,
      required this.servicetime,
      required this.consultationType,
      required this.consultationFee,
      this.channelId,
      this.reasonForCancel,
      this.notes,
      this.reports,
      required this.status,
      required this.totalFee,
      required this.bookedAt,
      required this.patientId,
      required this.freeFollowUps,
      required this.freeFollowUpsLeft,
      required this.clinicName,
      required this.doctorName,
      // required this.customerId,
      this.branchname,
      this.consentFormPdf,
      this.doctorRefCode,
      this.branchId,
      this.priscriptionPdf});

  factory Getappointmentmodel.fromJson(Map<String, dynamic> json) {
    try {
      return Getappointmentmodel(
        bookingId: json['bookingId']?.toString() ?? '',
        patientId: json['patientId']?.toString() ?? '',
        relation: json['relation']?.toString() ?? '',
        bookingFor: json['bookingFor']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        age: json['age']?.toString() ?? '', // always String
        gender: json['gender']?.toString() ?? '',
        mobileNumber: json['mobileNumber']?.toString() ?? '',
        problem: json['problem']?.toString() ?? '',
        subServiceName: json['subServiceName']?.toString() ?? '',
        subServiceId: json['subServiceId']?.toString() ?? '',
        doctorId: json['doctorId']?.toString() ?? '',
        clinicId: json['clinicId']?.toString() ?? '',
        serviceDate: json['serviceDate']?.toString() ?? '',
        servicetime: json['servicetime']?.toString() ?? '',
        consultationType: json['consultationType']?.toString() ?? '',
        clinicName: json['clinicName']?.toString() ?? '',
        doctorName: json['doctorName']?.toString() ?? '',
        // customerId: json['customerId'],
        branchname: json['branchname'],
        branchId: json['branchId'],
        consentFormPdf: json['consentFormPdf'],
        doctorRefCode: json['doctorRefCode'],
        priscriptionPdf: json['priscriptionPdf']?.toString() ?? '',

        // 👇 Safely parse doubles
        consultationFee:
            double.tryParse(json['consultationFee'].toString()) ?? 0.0,

        channelId: json['channelId']?.toString(),
        reasonForCancel: json['reasonForCancel']?.toString(),
        notes: json['notes']?.toString(),

        reports: (json['reports'] as List?)
            ?.map((e) => Reports.fromJson(e as Map<String, dynamic>))
            .toList(),

        status: json['status']?.toString() ?? '',
        freeFollowUps: json['freeFollowUps'] ?? 0,
        freeFollowUpsLeft: json['freeFollowUpsLeft'] ?? 0,

        // 👇 Same for totalFee
        totalFee: double.tryParse(json['totalFee'].toString()) ?? 0.0,

        bookedAt: json['bookedAt']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ Error parsing Getappointmentmodel: $e\nData: $json');
      rethrow;
    }
  }
}

class Reports {
  final List<ReportItem> reportsList;

  Reports({required this.reportsList});

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      reportsList: (json['reportsList'] as List? ?? [])
          .map((e) => ReportItem.fromJson(e))
          .toList(),
    );
  }
}

class ReportItem {
  final String bookingId;
  final String customerMobileNumber;
  final String reportName;
  final String reportDate;
  final String reportStatus;
  final String reportType;
  final List<String> reportFile;

  ReportItem({
    required this.bookingId,
    required this.customerMobileNumber,
    required this.reportName,
    required this.reportDate,
    required this.reportStatus,
    required this.reportType,
    required this.reportFile,
  });

  factory ReportItem.fromJson(Map<String, dynamic> json) {
    return ReportItem(
      bookingId: json['bookingId'],
      customerMobileNumber: json['customerMobileNumber'] ?? '',
      reportName: json['reportName'],
      reportDate: json['reportDate'],
      reportStatus: json['reportStatus'],
      reportType: json['reportType'],
      reportFile: List<String>.from(json['reportFile'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'customerMobileNumber': customerMobileNumber,
      'reportName': reportName,
      'reportDate': reportDate,
      'reportStatus': reportStatus,
      'reportType': reportType,
      'reportFile': reportFile,
    };
  }
}
