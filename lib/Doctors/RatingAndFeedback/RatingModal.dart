class RatingSummary {
  final String doctorId;
  final String hospitalId;
  final double overallDoctorRating;
  final double overallHospitalRating;
  final List<Comment> comments;

  RatingSummary({
    required this.doctorId,
    required this.hospitalId,
    required this.overallDoctorRating,
    required this.overallHospitalRating,
    required this.comments,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      doctorId: json['doctorId'],
      hospitalId: json['hospitalId'],
      overallDoctorRating: (json['overallDoctorRating'] as num).toDouble(),
      overallHospitalRating: (json['overallHospitalRating'] as num).toDouble(),
      comments: (json['comments'] as List)
          .map((item) => Comment.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'hospitalId': hospitalId,
      'overallDoctorRating': overallDoctorRating,
      'overallHospitalRating': overallHospitalRating,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class Comment {
  final double doctorRating;
  final double hospitalRating;
  final String feedback;
  final String hospitalId;
  final String doctorId;
  final String customerMobileNumber;
  final String appointmentId;
  final bool rated;

  Comment({
    required this.doctorRating,
    required this.hospitalRating,
    required this.feedback,
    required this.hospitalId,
    required this.doctorId,
    required this.customerMobileNumber,
    required this.appointmentId,
    required this.rated,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      doctorRating: (json['doctorRating'] as num).toDouble(),
      hospitalRating: (json['hospitalRating'] as num).toDouble(),
      feedback: json['feedback'],
      hospitalId: json['hospitalId'],
      doctorId: json['doctorId'],
      customerMobileNumber: json['customerMobileNumber'],
      appointmentId: json['appointmentId'],
      rated: json['rated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorRating': doctorRating,
      'hospitalRating': hospitalRating,
      'feedback': feedback,
      'hospitalId': hospitalId,
      'doctorId': doctorId,
      'customerMobileNumber': customerMobileNumber,
      'appointmentId': appointmentId,
      'rated': rated,
    };
  }
}
