class HospitalCardModel {
  final String hospitalId;
  final String hospitalName;
  final String hospitalLogo; // base64 string
  final bool recommanded;
  final String serviceName;
  final String subServiceName;
  final double subServicePrice;
  final double price;
  final double discountedCost;
  final double taxAmount;
  final int discountPercentage;
  final double hospitalOverallRating;
  final String website;
  final double consultationFee;
  final String walkthrough;

  HospitalCardModel({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalLogo,
    required this.recommanded,
    required this.serviceName,
    required this.subServiceName,
    required this.subServicePrice,
    required this.price,
    required this.discountedCost,
    required this.taxAmount,
    required this.discountPercentage,
    required this.hospitalOverallRating,
    required this.website,
    required this.consultationFee,
    required this.walkthrough,
  });

  factory HospitalCardModel.fromJson(Map<String, dynamic> json) {
    return HospitalCardModel(
      hospitalId: json['hospitalId'] ?? "",
      hospitalName: json['hospitalName'] ?? "",
      hospitalLogo: json['hospitalLogo'] ?? "",
      recommanded: json['recommanded'] ?? false,
      serviceName: json['serviceName'] ?? "",
      subServiceName: json['subServiceName'] ?? "",
      subServicePrice: (json['subServicePrice'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      discountedCost: (json['discountedCost'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toInt(),
      hospitalOverallRating: (json['hospitalOverallRating'] ?? 0).toDouble(),
      website: json['website'] ?? "",
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
      walkthrough: json['walkthrough'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "hospitalId": hospitalId,
        "hospitalName": hospitalName,
        "hospitalLogo": hospitalLogo,
        "recommanded": recommanded, // 👈 keep same spelling as backend
        "serviceName": serviceName,
        "subServiceName": subServiceName,
        "subServicePrice": subServicePrice,
        "price": price,
        "discountedCost": discountedCost,
        "taxAmount": taxAmount,
        "discountPercentage": discountPercentage,
        "hospitalOverallRating": hospitalOverallRating,
        "website": website,
        "consultationFee": consultationFee,
        "walkthrough": walkthrough,
      };
}
