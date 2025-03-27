class HospitalDoctorModel {
  final String id; // Doctor object ID
  final Hospital hospital;
  final Doctor doctor;

  HospitalDoctorModel({
    required this.id,
    required this.hospital,
    required this.doctor,
  });

  factory HospitalDoctorModel.fromJson(Map<String, dynamic> json) {
    return HospitalDoctorModel(
      id: json['id'],
      hospital: Hospital.fromJson(json['hospital']),
      doctor: Doctor.fromJson(json['doctor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital': hospital.toJson(),
      'doctor': doctor.toJson(),
    };
  }
}

class Hospital {
  final String name;
  final String address;
  final String city;
  final String contactNumber;

  Hospital({
    required this.name,
    required this.address,
    required this.city,
    required this.contactNumber,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'contactNumber': contactNumber,
    };
  }
}

class Doctor {
  final String name;
  final String gender;
  final String qualification;
  final String specialization;

  final int experienceYears;
  final List<String> focusAreas;
  final String availableTimings;
  final List<Map<String, dynamic>> availableSlots;

  final String availableDays;

  final List<String> languagesKnown;
  final String profile;
  final String profileImage;
  final List<String> careerPath;
  final List<String> highlights;
  final double overallRating;
  final bool rated;
  final List<RatingComment> comments;

  bool favorites;
  final List<String> bookingSlots;
  final Fee fee;
  final Status status;

  Doctor({
    required this.name,
    required this.gender,
    required this.qualification,
    required this.specialization,
    required this.experienceYears,
    required this.focusAreas,
    required this.availableTimings,
    required this.availableDays,
    required this.languagesKnown,
    required this.profile,
    required this.profileImage,
    required this.careerPath,
    required this.highlights,
    required this.overallRating,
    required this.comments,
    required this.favorites,
    required this.bookingSlots,
    required this.fee,
    required this.status,
    required this.availableSlots,
    required this.rated,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      gender: json['gender'],
      qualification: json['qualification'],
      specialization: json['specialization'],
      experienceYears: json['experienceYears'],
      focusAreas: List<String>.from(json['focusAreas']),
      availableTimings: json['availableTimings'],
      availableSlots: List<Map<String, dynamic>>.from(json['availableSlots']),
      comments: (json['ratings']['comments'] as List)
          .map((e) => RatingComment.fromJson(e))
          .toList(),

      availableDays: json['availableDays'],
      languagesKnown: List<String>.from(json['languagesKnown']),
      profile: json['profile'],
      profileImage: json['profileImage'],
      careerPath: List<String>.from(json['careerPath']),
      highlights: List<String>.from(json['highlights']),
      overallRating: (json['ratings']['overall'] as num).toDouble(),
      rated: json['ratings']?['rated'] ?? false,

      // comments: List<String>.from(json['ratings']['comments']),
      favorites: json['favorites'],
      bookingSlots: List<String>.from(json['bookingSlots']),
      fee: Fee.fromJson(json['fee']),
      status: Status.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'qualification': qualification,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'focusAreas': focusAreas,
      'availableTimings': availableTimings,
      'availableDays': availableDays,
      'languagesKnown': languagesKnown,
      'profile': profile,
      'profileImage': profileImage,
      'careerPath': careerPath,
      'highlights': highlights,
      'ratings': {
        'overall': overallRating,
        'comments': comments,
      },
      'favorites': favorites,
      'bookingSlots': bookingSlots,
      'fee': fee.toJson(),
      'status': status.toJson(),
    };
  }
}

class RatingComment {
  final String userId;
  final int rating;
  final String comment;
  final String createdAt;
  final bool rated;

  RatingComment({
    required this.userId,
    required this.rating,
    required this.comment,
    required this.rated,
    required this.createdAt,
  });

  factory RatingComment.fromJson(Map<String, dynamic> json) {
    return RatingComment(
      userId: json['userId'] ?? "",
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? "",
      rated: json['rated'] ?? false,
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'rated': rated,
      'createdAt': createdAt,
    };
  }
}

class Fee {
  final int treatmentFee;
  final int inClinicFee;
  final int videoConsultationFee;

  Fee({
    required this.treatmentFee,
    required this.inClinicFee,
    required this.videoConsultationFee,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      treatmentFee: json['treatmentFee'],
      inClinicFee: json['inClinicFee'],
      videoConsultationFee: json['videoConsultationFee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatmentFee': treatmentFee,
      'inClinicFee': inClinicFee,
      'videoConsultationFee': videoConsultationFee,
    };
  }
}

class Status {
  final bool accepted;
  final bool rejected;
  final String? rejectionReason;

  Status({
    required this.accepted,
    required this.rejected,
    this.rejectionReason,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      accepted: json['accepted'],
      rejected: json['rejected'],
      rejectionReason: json['rejectionReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accepted': accepted,
      'rejected': rejected,
      'rejectionReason': rejectionReason,
    };
  }
}
