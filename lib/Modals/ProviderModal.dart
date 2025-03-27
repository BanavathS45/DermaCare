class ProviderDetailsInfo {
  String fullName;
  String providerMobileNumber;
  String profilePicture;
  String yearsOfExperience;
  List<String> courseSpecializations;
  String qualificationSpecialization;
  String overallRating;

  ProviderDetailsInfo({
    required this.fullName,
    required this.providerMobileNumber,
    required this.profilePicture,
    required this.yearsOfExperience,
    required this.courseSpecializations,
    required this.qualificationSpecialization,
    required this.overallRating,
  });

  factory ProviderDetailsInfo.fromJson(Map<String, dynamic> json) {
    return ProviderDetailsInfo(
      fullName: json['fullName'] ?? '',
      providerMobileNumber: json['providerMobileNumber'].toString(),
      profilePicture: json['profilePicture'] ?? '',
      yearsOfExperience: json['yearsOfExperience'].toString(),
      courseSpecializations:
          List<String>.from(json['courseSpecializations'] ?? []),
      qualificationSpecialization: json['qualificationSpecialization'] ?? [],
      overallRating: json['overallRating'].toString(),
    );
  }
}
