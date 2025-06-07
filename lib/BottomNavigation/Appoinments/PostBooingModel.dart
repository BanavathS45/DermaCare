import '../../PatientsDetails/PatientModel.dart';

class BookingDetailsModel {
  final String subServiceName;
  final String subServiceId;
  final String doctorId;
  final String consultationType;
  final double totalFee;
  final double consultattionFee; // kept as-is based on your earlier message
  final String status;
  final String? resoan;
  final String clinicId;

  BookingDetailsModel({
    required this.subServiceName,
    required this.subServiceId,
    required this.doctorId,
    required this.consultationType,
    required this.totalFee,
    required this.consultattionFee,
    required this.status,
    this.resoan,
    required this.clinicId,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      subServiceName: json['subServiceName'],
      status: json['status'],
      subServiceId: json['subServiceId'],
      clinicId: json['clinicId'],
      doctorId: json['doctorId'],
      consultationType: json['consultationType'],
      resoan: json['resoan'],
      totalFee: (json['totalFee'] ?? 0).toDouble(),
      consultattionFee: (json['consultattionFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subServiceName': subServiceName,
      'resoan': resoan,
      'status': status,
      'subServiceId': subServiceId,
      'doctorId': doctorId,
      'consultationType': consultationType,
      'totalFee': totalFee,
      'consultattionFee': consultattionFee,
      'clinicId': clinicId,
    };
  }
}

class PostBookingModel {
  final PatientModel patient;
  final BookingDetailsModel booking;
  PostBookingModel({
    required this.patient,
    required this.booking,
  });

  factory PostBookingModel.fromJson(Map<String, dynamic> json) {
    return PostBookingModel(
      patient: PatientModel.fromJson(json),
      booking: BookingDetailsModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...patient.toJson(),
      ...booking.toJson(),
    };
  }
}
