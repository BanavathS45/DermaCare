class Patient {
  String fullName;
  String mobileNumber;
  String gender;
  String bloodGroup;
  int age;
  String email;
  bool registrationCompleted;
  List<Address> addresses;

  // Constructor
  Patient({
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    required this.bloodGroup,
    required this.age,
    required this.email,
    required this.registrationCompleted,
    required this.addresses,
  });

  // From JSON to Patient
  factory Patient.fromJson(Map<String, dynamic> json) {
    var addressList = json['addresses'] as List?;
    List<Address> addresses = addressList != null
        ? addressList
            .map((addressJson) => Address.fromJson(addressJson))
            .toList()
        : [];

    return Patient(
      fullName: json['fullName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      age: json['age'] ?? 0,
      email: json['emailId'] ?? '',
      registrationCompleted: json['registrationCompleted'] ?? false,
      addresses: addresses,
    );
  }

  // From Patient to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'age': age,
      'emailId': email,
      'registrationCompleted': registrationCompleted,
      'addresses': addresses.map((address) => address.toJson()).toList(),
    };
  }

  // Get formatted address (using the addresses list from the patient)
  String get formattedAddress {
    if (addresses.isNotEmpty) {
      Address address =
          addresses[0]; // Assuming you want to display the first address
      return '${address.houseNo},${address.apartment},${address.street},${address.city},${address.state}, ${address.country} - ${address.postalCode}, ${address.direction}';
    }
    return 'No address available';
  }
}

class Address {
  String? id;
  String houseNo;
  String street;
  String city;
  String state;
  String postalCode;
  String country;
  String saveAs;
  String apartment;
  String direction;
  double? latitude;
  double? longitude;
  // String? receiverName;
  // String? receiverMobileNumber;

  // Constructor
  Address({
    this.id,
    required this.houseNo,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.saveAs,
    required this.apartment,
    required this.direction,
    this.latitude,
    this.longitude,
    // this.receiverName,
    // this.receiverMobileNumber,
  });

  // From JSON to Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      houseNo: json['houseNo'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      saveAs: json['saveAs'] ?? '',
      apartment: json['apartment'] ?? '',
      direction: json['direction'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      // receiverName: json['receiverName'],
      // receiverMobileNumber: json['receiverMobileNumber'],
    );
  }

  // From Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseNo': houseNo,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'saveAs': saveAs,
      'apartment': apartment,
      'direction': direction,
      'latitude': latitude,
      'longitude': longitude,
      // 'receiverName': receiverName,
      // 'receiverMobileNumber': receiverMobileNumber,
    };
  }
}
