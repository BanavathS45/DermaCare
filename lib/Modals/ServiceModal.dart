import 'dart:convert';
import 'dart:typed_data';

class Service {
  final String serviceName;
  final String serviceId;
  final String categoryName;
  final String description;
  final double pricing;
  final double discount;
  final double discountCost;
  final double tax;
  final double discountedCost;
  final double finalCost;
  final double taxAmount;
  final String status;
  final String minTime;
  final String includes;
  final String readyPeriod;
  final String viewDescription;
  final String preparation;
  final Uint8List serviceImage; // To hold the decoded image
  int quantity;

  // Constructor with named parameters
  Service(
      {required this.serviceName,
      required this.serviceId,
      required this.categoryName,
      required this.description,
      required this.pricing,
      required this.discount,
      required this.finalCost,
      required this.discountCost,
      required this.discountedCost,
      required this.minTime,
      required this.taxAmount,
      required this.tax,
      required this.includes,
      required this.readyPeriod,
      required this.viewDescription,
      required this.preparation,
      required this.serviceImage, // Ensure it's a named parameter
      this.quantity = 0,
      required this.status});

  // Factory constructor for creating a Service from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> imagesMap =
        Map<String, dynamic>.from(json['images'] ?? {});
    final decodedImage = base64Decode(imagesMap['serviceImage'] ?? "");
    imagesMap['serviceImage'] = decodedImage; // Decode the image

    return Service(
      serviceName: json['serviceName'] as String? ?? "",
      serviceId: json['serviceId'] as String? ?? "",
      categoryName: json['categoryName'] as String? ?? "",
      description: json['description'] as String? ?? "",
      minTime: json['minTime'] as String? ?? "",
      pricing: double.tryParse(json['pricing'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      discountCost: double.tryParse(json['discountCost'].toString()) ?? 0.0,
      finalCost: double.tryParse(json['finalCost'].toString()) ?? 0.0,
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      taxAmount: double.tryParse(json['taxAmount'].toString()) ?? 0.0,
      discountedCost: double.tryParse(json['discountedCost'].toString()) ?? 0.0,
      status: json['status'] as String? ?? "",
      includes: json['includes'] as String? ?? "",
      readyPeriod: json['readyPeriod'] as String? ?? "",
      viewDescription: json['viewDescription'] as String? ?? "",
      preparation: json['preparation'] as String? ?? "",
      quantity: json['quantity'] as int? ?? 0,
      serviceImage: decodedImage, // Pass the decoded image
    );
  }
}
