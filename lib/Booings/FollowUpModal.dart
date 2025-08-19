class FollowUpModal {
  final String visitType;
  final String mobileNumber;
  final String serviceDate;
  final String serviceTime;
  final String patientId;
  final String bookingId;
  final String doctorId;

  FollowUpModal({
    required this.visitType,
    required this.mobileNumber,
    required this.serviceDate,
    required this.serviceTime,
    required this.patientId,
    required this.bookingId,
    required this.doctorId,
  });

  // Convert JSON → Object
  factory FollowUpModal.fromJson(Map<String, dynamic> json) {
    return FollowUpModal(
      visitType: json['visitType'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      serviceDate: json['serviceDate'] ?? '',
      serviceTime: json['serviceTime'] ?? '',
      patientId: json['patientId'] ?? '',
      bookingId: json['bookingId'] ?? '',
      doctorId: json['doctorId'] ?? '',
    );
  }

  // Convert Object → JSON
  Map<String, dynamic> toJson() {
    return {
      "visitType": visitType,
      "mobileNumber": mobileNumber,
      "serviceDate": serviceDate,
      "serviceTime": serviceTime,
      "patientId": patientId,
      "bookingId": bookingId,
      "doctorId": doctorId,
    };
  }
}
