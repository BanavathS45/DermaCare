class HospitalDoctorModel {
  final Doctor doctor;
  final Hospital hospital;

  HospitalDoctorModel({required this.doctor, required this.hospital});

  factory HospitalDoctorModel.fromJson(
      Map<String, dynamic> doctorJson, Map<String, dynamic> clinicJson) {
    return HospitalDoctorModel(
      doctor: Doctor.fromJson(doctorJson),
      hospital: Hospital.fromJson(clinicJson),
    );
  }
}

class Doctor {
  final String id;
  final String doctorId;
  final String hospitalId;
  final String doctorName;
  final String doctorPicture;
  final String doctorLicence;
  final String doctorMobileNumber;
  final List<Category> category;
  final List<Service> service;
  final List<SubService> subServices;
  final String specialization;
  final String gender;
  final String experience;
  final String qualification;
  final String availableDays;
  final String availableTimes;
  final String profileDescription;
  final DoctorFees doctorFees;
  final List<String> focusAreas;
  final List<String> languages;
  final List<String> highlights;
  final bool doctorAvailabilityStatus;

  Doctor({
    required this.id,
    required this.doctorId,
    required this.hospitalId,
    required this.doctorName,
    required this.doctorPicture,
    required this.doctorLicence,
    required this.doctorMobileNumber,
    required this.category,
    required this.service,
    required this.subServices,
    required this.specialization,
    required this.gender,
    required this.experience,
    required this.qualification,
    required this.availableDays,
    required this.availableTimes,
    required this.profileDescription,
    required this.doctorFees,
    required this.focusAreas,
    required this.languages,
    required this.highlights,
    required this.doctorAvailabilityStatus,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      hospitalId: json['hospitalId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorPicture: json['doctorPicture'] ?? '',
      doctorLicence: json['doctorLicence'] ?? '',
      doctorMobileNumber: json['doctorMobileNumber'] ?? '',
      category:
          (json['category'] as List).map((e) => Category.fromJson(e)).toList(),
      service:
          (json['service'] as List).map((e) => Service.fromJson(e)).toList(),
      subServices: (json['subServices'] as List)
          .map((e) => SubService.fromJson(e))
          .toList(),
      specialization: json['specialization'] ?? '',
      gender: json['gender'] ?? '',
      experience: json['experience'] ?? '',
      qualification: json['qualification'] ?? '',
      availableDays: json['availableDays'] ?? '',
      availableTimes: json['availableTimes'] ?? '',
      profileDescription: json['profileDescription'] ?? '',
      doctorFees: DoctorFees.fromJson(json['doctorFees']),
      focusAreas: List<String>.from(json['focusAreas'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      highlights: List<String>.from(json['highlights'] ?? []),
      doctorAvailabilityStatus: json['doctorAvailabilityStatus'] ?? false,
    );
  }
}

class Hospital {
  final String hospitalId;
  final String name;
  final String address;
  final String city;
  final String contactNumber;
  final String hospitalRegistrations;
  final String openingTime;
  final String closingTime;
  final String hospitalLogo;
  final bool recommended;

  Hospital({
    required this.hospitalId,
    required this.name,
    required this.address,
    required this.city,
    required this.contactNumber,
    required this.hospitalRegistrations,
    required this.openingTime,
    required this.closingTime,
    required this.hospitalLogo,
    required this.recommended,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      hospitalId: json['hospitalId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      hospitalRegistrations: json['hospitalRegistrations'] ?? '',
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      hospitalLogo: json['hospitalLogo'] ?? '',
      recommended: json['recommended'] ?? false,
    );
  }
}

class DoctorFees {
  final int inClinicFee;
  final int vedioConsultationFee;

  DoctorFees({
    required this.inClinicFee,
    required this.vedioConsultationFee,
  });

  factory DoctorFees.fromJson(Map<String, dynamic> json) {
    return DoctorFees(
      inClinicFee: json['inClinicFee'] ?? 0,
      vedioConsultationFee: json['vedioConsultationFee'] ?? 0,
    );
  }
}

class Category {
  final String categoryId;
  final String categoryName;

  Category({required this.categoryId, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
    );
  }
}

class Service {
  final String serviceId;
  final String serviceName;

  Service({required this.serviceId, required this.serviceName});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
    );
  }
}

class SubService {
  final String subServiceId;
  final String subServiceName;

  SubService({required this.subServiceId, required this.subServiceName});

  factory SubService.fromJson(Map<String, dynamic> json) {
    return SubService(
      subServiceId: json['subServiceId'] ?? '',
      subServiceName: json['subServiceName'] ?? '',
    );
  }
}
