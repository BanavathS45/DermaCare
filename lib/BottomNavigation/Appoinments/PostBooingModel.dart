import '../../PatientsDetails/PatientModel.dart';

class BookingDetailsModel {
 
  final String categoryName;
  final String categoryId;
  final String servicename;
  final String serviceId;
  final String subServiceName;
  final String subServiceId;
  final String clinicId;
  final String clinicName;
  final String clinicAddress;
  final String doctorId;
  final String doctorName;
  final String doctorDeviceId;
 
  final String consultationType;
  final double consultationFee;
  final double totalFee;

  BookingDetailsModel({
 
    required this.categoryName,
    required this.categoryId,
    required this.servicename,
    required this.serviceId,
    required this.subServiceName,
    required this.subServiceId,
    required this.clinicId,
    required this.clinicName,
    required this.clinicAddress,
    required this.doctorId,
    required this.doctorName,
    required this.doctorDeviceId,
 
 
    required this.consultationType,
    required this.consultationFee,
    required this.totalFee,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
   
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      servicename: json['servicename'],
      serviceId: json['serviceId'],
      subServiceName: json['subServiceName'],
      subServiceId: json['subServiceId'],
      clinicId: json['clinicId'],
      clinicName: json['clinicName'],
      clinicAddress: json['clinicAddress'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorDeviceId: json['doctorDeviceId'],
 
 
      consultationType: json['consultationType'],
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
      totalFee: (json['totalFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
   
      'categoryName': categoryName,
      'categoryId': categoryId,
      'servicename': servicename,
      'serviceId': serviceId,
      'subServiceName': subServiceName,
      'subServiceId': subServiceId,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorDeviceId': doctorDeviceId,
 
     
      'consultationType': consultationType,
      'consultationFee': consultationFee,
      'totalFee': totalFee,
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
