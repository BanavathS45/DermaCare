class AddressModel {
  String houseNo;
  String street;
  String city;
  String state;
  String postalCode;
  String country;
  String? apartment;
  String? direction;
  double latitude;
  double longitude;
  // String? saveAs;
  // String? receiverName;
  // int? receiverMobileNumber;

  // Constructor
  AddressModel({
    required this.houseNo,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.apartment,
    this.direction,
    required this.latitude,
    required this.longitude,
    // this.saveAs,
    // this.receiverName,
    // this.receiverMobileNumber,
  });

  // Factory method to create an instance from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      houseNo: json['houseNo'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      apartment: json['apartment'],
      direction: json['direction'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      // saveAs: json['saveAs'],
      // receiverName: json['receiverName'],
      // receiverMobileNumber: json['receiverMobileNumber'],
    );
  }

  // Method to convert an instance to JSON
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

  @override
  String toString() {
    return '$houseNo,$apartment,$street,$city,$state, $country - $postalCode, $direction';
  }
}
