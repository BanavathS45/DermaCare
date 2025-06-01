class GetCustomerModel {
  final String customerId;
  final String fullName;
  final String mobileNumber;
  final String gender;
  final String? fcm; // Nullable field
  final String emailId;
  final String referCode;
  final String dateOfBirth;

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
    };
  }
}
