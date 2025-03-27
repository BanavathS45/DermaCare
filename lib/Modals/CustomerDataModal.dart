import 'package:flutter/material.dart';

class CustomerData {
  final String formattedAddress;
  final String patientName;
  final String? patientNumber;
  final int age;
  final String email;
  final String username;
  final String gender;
  final String relation;
  final String saveAs;
  final List? selectedServices;
  final String address;
  final DateTime startDate;
  final DateTime endDate;
  final int noOfDays;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String noOfHours;

  CustomerData({
    required this.formattedAddress,
    required this.patientName,
     this.patientNumber,
    required this.age,
    required this.email,
    required this.username,
    required this.gender,
    required this.relation,
    required this.saveAs,
    this.selectedServices,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.noOfDays,
    required this.startTime,
    required this.endTime,
    required this.noOfHours,
  });

//   // Factory constructor for JSON deserialization
//   factory CustomerData.fromJson(Map<String, dynamic> json) {
//     return CustomerData(
//       formattedAddress: json['formattedAddress'] ?? '',
//       patientName: json['patientName'] ?? '',
//       age: json['age'] ?? 0, // Default to 0 if not provided
//       email: json['email'] ?? '',
//       username: json['username'] ?? '',
//       gender: json['gender'] ?? '',
//       relation: json['relation'] ?? '',
//       saveAs: json['saveAs'] ?? '',
//       selectedServices: json['selectedServices'] != null
//           ? List<String>.from(json['selectedServices'])
//           : null,
//       address: json['address'] ?? '',
//       startDate: json['startDate'] != null
//           ? DateTime.parse(json['startDate'])
//           : DateTime.now(), // Default to current date if null
//       endDate: json['endDate'] != null
//           ? DateTime.parse(json['endDate'])
//           : DateTime.now(), // Default to current date if null
//       noOfDays: json['noOfDays'] ?? 0, // Default to 0 if not provided
//       startTime: json['startTime'] != null
//           ? _stringToTimeOfDay(json['startTime'])
//           : TimeOfDay.now(), // Default to current time if null
//       endTime: json['endTime'] != null
//           ? _stringToTimeOfDay(json['endTime'])
//           : TimeOfDay.now(), // Default to current time if null
//       noOfHours: json['noOfHours'] ?? '0', // Default to '0' if not provided
//     );
//   }

//   // Method to convert to JSON serialization
//   Map<String, dynamic> toJson() {
//     return {
//       'formattedAddress': formattedAddress,
//       'patientName': patientName,
//       'age': age,
//       'email': email,
//       'username': username,
//       'gender': gender,
//       'relation': relation,
//       'saveAs': saveAs,
//       'selectedServices': selectedServices,
//       'address': address,
//       'endDate': endDate.toIso8601String(),
//       'startDate': startDate.toIso8601String(),
//       'noOfDays': noOfDays,
//       'startTime': _timeOfDayToString(startTime),
//       'endTime': _timeOfDayToString(endTime),
//       'noOfHours': noOfHours,
//     };
//   }

//   // Helper to convert TimeOfDay to String
//   static String _timeOfDayToString(TimeOfDay time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }

//   // Helper to convert String to TimeOfDay
//   static TimeOfDay _stringToTimeOfDay(String time) {
//     final parts = time.split(':');
//     return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
//   }
// }
}
