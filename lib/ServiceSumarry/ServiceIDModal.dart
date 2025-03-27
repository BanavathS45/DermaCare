import 'package:cutomer_app/Modals/AddressModal.dart';

class BookingDetails {
  String patientName;
  String relationship;
  String patientNumber;
  String gender;
  String emailId;
  String age;
  String customerNumber;
  AddressModel addressDto;
  String categoryName;
  List<ServiceAdded> servicesAdded;
  double totalPrice;
  double totalDiscountAmount;
  double totalDiscountedAmount;
  double totalTax;
  double payAmount;

  BookingDetails({
    required this.patientName,
    required this.relationship,
    required this.patientNumber,
    required this.gender,
    required this.emailId,
    required this.age,
    required this.customerNumber,
    required this.addressDto,
    required this.categoryName,
    required this.servicesAdded,
    required this.totalPrice,
    required this.totalDiscountAmount,
    required this.totalDiscountedAmount,
    required this.totalTax,
    required this.payAmount,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      patientName: json['patientName'],
      relationship: json['relationShip'],
      patientNumber: json['patientNumber'],
      gender: json['gender'],
      emailId: json['emailId'],
      age: json['age'],
      customerNumber: json['customerNumber'],
      addressDto: AddressModel.fromJson(json['addressDto']),
      categoryName: json['categoryName'],
      servicesAdded: (json['servicesAdded'] as List)
          .map((service) => ServiceAdded.fromJson(service))
          .toList(),
      totalPrice: json['totalPrice'],
      totalDiscountAmount: json['totalDiscountAmount'],
      totalDiscountedAmount: json['totalDiscountedAmount'],
      totalTax: json['totalTax'],
      payAmount: json['payAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'relationShip': relationship,
      'patientNumber': patientNumber,
      'gender': gender,
      'emailId': emailId,
      'age': age,
      'customerNumber': customerNumber,
      'addressDto': addressDto.toJson(),
      'categoryName': categoryName,
      'servicesAdded':
          servicesAdded.map((service) => service.toJson()).toList(),
      'totalPrice': totalPrice,
      'totalDiscountAmount': totalDiscountAmount,
      'totalDiscountedAmount': totalDiscountedAmount,
      'totalTax': totalTax,
      'payAmount': payAmount,
    };
  }
}

class AddressDto {
  String houseNo;
  String street;
  String city;
  String state;
  String postalCode;
  String country;
  String apartment;
  String direction;
  double latitude;
  double longitude;

  AddressDto({
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
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
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
    );
  }

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
    };
  }
}

class ServiceAdded {
  String status;
  String serviceId;
  String serviceName;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  int numberOfDays;
  String numberOfHours;
  double price;
  double discount;
  double discountAmount;
  double discountedCost;
  double tax;
  double taxAmount;
  double finalCost;
  double latitude;
  double longitude;

  ServiceAdded({
    required this.status,
    required this.serviceId,
    required this.serviceName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfDays,
    required this.numberOfHours,
    required this.price,
    required this.discount,
    required this.discountAmount,
    required this.discountedCost,
    required this.tax,
    required this.taxAmount,
    required this.finalCost,
    required this.latitude,
    required this.longitude,
  });

  factory ServiceAdded.fromJson(Map<String, dynamic> json) {
    return ServiceAdded(
      status: json['status'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      numberOfDays: json['numberOfDays'],
      numberOfHours: json['numberOfHours'],
      price: json['price'],
      discount: json['discount'],
      discountAmount: json['discountAmount'],
      discountedCost: json['discountedCost'],
      tax: json['tax'],
      taxAmount: json['taxAmount'],
      finalCost: json['finalCost'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'numberOfDays': numberOfDays,
      'numberOfHours': numberOfHours,
      'price': price,
      'discount': discount,
      'discountAmount': discountAmount,
      'discountedCost': discountedCost,
      'tax': tax,
      'taxAmount': taxAmount,
      'finalCost': finalCost,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
