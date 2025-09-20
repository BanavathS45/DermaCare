class GetCustomerModel {
  final String customerId;
  final String fullName;
  final String mobileNumber;
  final String gender;
  final String? fcm; // Nullable field
  final String emailId;
  final String referCode;
  final String dateOfBirth;
  final String age;
  final Address address;
  final String patientId;
  // Constructor
  GetCustomerModel({
    required this.customerId,
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    this.fcm,
    required this.emailId,
    required this.referCode,
    required this.dateOfBirth,
    required this.age,
    required this.address,
    required this.patientId,
  });

  // Factory method to create a GetCustomerModel from JSON
  factory GetCustomerModel.fromJson(Map<String, dynamic> json) {
    // Check if 'data' key exists and extract the customer info
    final data = json['data'];
    return GetCustomerModel(
      customerId: data['customerId'] ?? '',
      fullName: data['fullName'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      gender: data['gender'] ?? '',
      fcm: data['fcm'], // Can be null
      emailId: data['emailId'] ?? '',
      referCode: data['referCode'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      age: data['age'] ?? '',
      patientId: data['patientId'] ?? '',
      address: Address.fromJson(data['address'] ?? {}),
    );
  }

  // Method to convert the object back to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'fcm': fcm,
      'emailId': emailId,
      'referCode': referCode,
      'dateOfBirth': dateOfBirth,
      'age': age,
      'patientId': patientId,
      'address': address.toJson(),
    };
  }
}

class Address {
  final String houseNo;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  Address({
    required this.houseNo,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      houseNo: json['houseNo'] ?? '',
      street: json['street'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseNo': houseNo,
      'street': street,
      'landmark': landmark,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }
}
