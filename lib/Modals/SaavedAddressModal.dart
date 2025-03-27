class SaavedAddressModal {
  final String houseNo;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String apartment;
  final String direction;
  final double latitude;
  final double longitude;
  // final String saveAs;
  // final String receiverName;
  // final String receiverMobileNumber;

  SaavedAddressModal({
    required this.houseNo,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.apartment,
    required this.direction,
    required this.latitude,
    required this.longitude,
    // required this.saveAs,
    // required this.receiverName,
    // required this.receiverMobileNumber,
  });

  // Optional: Factory method to create Address from JSON
  factory SaavedAddressModal.fromJson(Map<String, dynamic> json) {
    return SaavedAddressModal(
      houseNo: json['houseNo'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      apartment: json['apartment'] ?? '',
      direction: json['direction'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      // saveAs: json['saveAs'] ?? '',
      // receiverName: json['receiverName'] ?? '',
      // receiverMobileNumber: json['receiverMobileNumber'] ?? '',
    );
  }

  // Optional: Method to convert Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'houseNo': houseNo,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'apartment': apartment,
      'direction': direction,
      'latitude': latitude,
      'longitude': longitude,
      // 'saveAs': saveAs,
      // 'receiverName': receiverName,
      // 'receiverMobileNumber': receiverMobileNumber,
    };
  }
}
