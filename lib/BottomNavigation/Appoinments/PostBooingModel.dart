 
import '../../PatientsDetails/PatientModel.dart';

class BookingDetailsModel {
  final String servicename;
  final String serviceId;
  final String doctorId;
  final String consultationType;
  final double totalFee;
  final double consultattionFee; // kept as-is based on your earlier message
  final String status;

  BookingDetailsModel( {
    required this.servicename,
    required this.serviceId,
    required this.doctorId,
    required this.consultationType,
    required this.totalFee,
    required this.consultattionFee,
    required this.status,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      servicename: json['servicename'],
      status: json['status'],
      serviceId: json['serviceId'],
      doctorId: json['doctorId'],
      consultationType: json['consultationType'],
      totalFee: (json['totalFee'] ?? 0).toDouble(),
      consultattionFee: (json['consultattionFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicename': servicename,
      'status': status,
      'serviceId': serviceId,
      'doctorId': doctorId,
      'consultationType': consultationType,
      'totalFee': totalFee,
      'consultattionFee': consultattionFee,
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


