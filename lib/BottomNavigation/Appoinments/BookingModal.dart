import 'dart:convert';

class AppointmentData {
  final String appointmentId;
  final String patientName;
  final String relationShip;
  final String patientNumber;
  final String gender;
  final String emailId;
  final String age;
  final String customerNumber;
  final AddressDto addressDto;
  final String categoryName;
  final List<ServiceAdded> servicesAdded;
  final double totalPrice;
  final double totalDiscountAmount;
  final double totalDiscountedAmount;
  
  final double totalTax;
  final double payAmount;
  final String bookedAt;

  AppointmentData({
    required this.appointmentId,
    required this.patientName,
    required this.relationShip,
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
    required this.bookedAt,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      appointmentId: json['appointmentId'],
      patientName: json['patientName'],
      relationShip: json['relationShip'],
      patientNumber: json['patientNumber'],
      gender: json['gender'],
      emailId: json['emailId'],
      age: json['age'],
      customerNumber: json['customerNumber'],
      addressDto: AddressDto.fromJson(json['addressDto']),
      categoryName: json['categoryName'],
      servicesAdded: (json['servicesAdded'] as List)
          .map((item) => ServiceAdded.fromJson(item))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalDiscountAmount: (json['totalDiscountAmount'] as num).toDouble(),
      totalDiscountedAmount: (json['totalDiscountedAmount'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      payAmount: (json['payAmount'] as num).toDouble(),
      bookedAt: json['bookedAt'],
    );
  }
}

class AddressDto {
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
}

class ServiceAdded {
  final String status;
  final String serviceId;
  final String serviceName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final int numberOfDays;
  final String numberOfHours;
  final double price;
  final int discount;
  final double discountAmount;
  final double discountedCost;
  final int tax;
  final double taxAmount;
  final double finalCost;
  final String? startPin;
  final String? endPin;

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
    this.startPin,
    this.endPin,
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
      startPin: json['startPin'],
      endPin: json['endPin'],
    );
  }
}
// List<AppointmentData> appointments = (json['data'] as List)
//     .map((item) => AppointmentData.fromJson(item))
//     .toList();
