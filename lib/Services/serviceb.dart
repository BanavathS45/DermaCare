import 'dart:convert';
import 'dart:typed_data';

class Serviceb {
  final String categoryId;
  final String categoryName;
  final Uint8List categoryImage; // Use Uint8List for images

  Serviceb({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory Serviceb.fromJson(Map<String, dynamic> json) {
    return Serviceb(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryImage: base64Decode(json['categoryImage'] ?? ''),
    );
  }
}
