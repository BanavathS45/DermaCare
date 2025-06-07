class Getappointmentmodel {
  final String bookingId;
  final String bookingFor;
  final String name;
  final int age;
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
  final String status;
  final double totalFee;
  final String bookeAt;

  Getappointmentmodel({
    required this.bookingId,
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
    required this.channelId,
    required this.status,
    required this.totalFee,
    required this.bookeAt,
  });

  /// Deserialize from JSON
  factory Getappointmentmodel.fromJson(Map<String, dynamic> json) {
    return Getappointmentmodel(
      bookingId: json['bookingId'] ?? '',
      bookingFor: json['bookingFor'] ?? '',
      name: json['name'] ?? '',
      age: int.tryParse(json['age'].toString()) ?? 0,
      gender: json['gender'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      problem: json['problem'] ?? '',
      subServiceName: json['subServiceName'] ?? '',
      subServiceId: json['subServiceId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      clinicId: json['clinicId'],
      serviceDate: json['serviceDate'] ?? '',
      servicetime: json['servicetime'] ?? '',
      consultationType: json['consultationType'] ?? '',
      consultationFee:
          double.tryParse(json['consultationFee'].toString()) ?? 0.0,
      channelId: json['channelId'],
      status: json['status'] ?? '',
      totalFee: double.tryParse(json['totalFee'].toString()) ?? 0.0,
      bookeAt: json['bookeAt'] ?? '',
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'bookingFor': bookingFor,
      'name': name,
      'age': age,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'problem': problem,
      'subServiceName': subServiceName,
      'subServiceId': subServiceId,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'serviceDate': serviceDate,
      'servicetime': servicetime,
      'consultationType': consultationType,
      'consultationFee': consultationFee,
      'channelId': channelId,
      'status': status,
      'totalFee': totalFee,
      'bookeAt': bookeAt,
    };
  }
}
