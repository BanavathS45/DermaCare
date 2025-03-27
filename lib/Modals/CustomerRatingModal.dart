class CustomerRatingModal {
  String notificationId;
  String categoryName;
  String serviceName;
  String customerNumber;
  String providerNumber;
  String rating;
  String feedback;
  String date;

  // Constructor
  CustomerRatingModal({
    required this.notificationId,
    required this.categoryName,
    required this.serviceName,
    required this.customerNumber,
    required this.providerNumber,
    required this.rating,
    required this.feedback,
    required this.date,
  });

  // Factory method for creating an instance from JSON
  factory CustomerRatingModal.fromJson(Map<String, dynamic> json) {
    return CustomerRatingModal(
      notificationId: json['notificationId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      serviceName: json['serviceName'] ?? '',
      customerNumber: json['customerNumber'] ?? '',
      providerNumber: json['providerNumber'] ?? '',
      rating: json['rating'] ?? '',
      feedback: json['feedback'] ?? '',
      date: json['date'] ?? '',
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'categoryName': categoryName,
      'serviceName': serviceName,
      'customerNumber': customerNumber,
      'providerNumber': providerNumber,
      'rating': rating,
      'feedback': feedback,
      'date': date,
    };
  }

  // Override toString method
  @override
  String toString() {
    return 'CustomerRatingModal(notificationId: $notificationId, categoryName: $categoryName, '
        'serviceName: $serviceName, customerNumber: $customerNumber, '
        'providerNumber: $providerNumber, rating: $rating, feedback: $feedback, date: $date)';
  }
}
