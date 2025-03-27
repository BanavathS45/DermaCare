class CaluclationModel {
  final String serviceId;
  final String serviceName;
  final double price;
  final double discount;
  final double discountAmount;
  final double discountedCost;
  final double tax;
  final double taxAmount;
  final double finalCost;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final int numberOfDays;
  final String numberOfHours;

  CaluclationModel({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.discount,
    required this.discountAmount,
    required this.discountedCost,
    required this.tax,
    required this.taxAmount,
    required this.finalCost,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfDays,
    required this.numberOfHours,
  });

  /// Convert model to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'price': price,
      'discount': discount,
      'discountAmount': discountAmount,
      'discountedCost': discountedCost,
      'tax': tax,
      'taxAmount': taxAmount,
      'finalCost': finalCost,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'numberOfDays': numberOfDays,
      'numberOfHours': numberOfHours,
    };
  }

  /// Convert JSON response back to model
  factory CaluclationModel.fromJson(Map<String, dynamic> json) {
    return CaluclationModel(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
      discountedCost: (json['discountedCost'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0.0).toDouble(),
      finalCost: (json['finalCost'] ?? 0.0).toDouble(),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      numberOfDays: json['numberOfDays'] ?? 0,
      numberOfHours: json['numberOfHours'] ?? '',
       
    );
  }
}
