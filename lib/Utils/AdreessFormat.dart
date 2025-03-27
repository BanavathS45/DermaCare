import 'dart:convert';

import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/ServiceSumarry/ServiceIDModal.dart';

// Import this at the top if you need to encode the map into a JSON string.

String formatAddress(AddressDto addressDto) {
  return '${addressDto.houseNo}, ${addressDto.apartment}, ${addressDto.street}, ${addressDto.city}, ${addressDto.state}, ${addressDto.country} - ${addressDto.postalCode}, ${addressDto.direction} ';
}

String formatAddressModel(AddressModel address) {
  List<String> parts = [];

  if (address.houseNo.isNotEmpty) parts.add(address.houseNo);
  if (address.apartment?.isNotEmpty ?? false) parts.add(address.apartment!);
  if (address.street.isNotEmpty) parts.add(address.street);
  if (address.city.isNotEmpty) parts.add(address.city);
  if (address.state.isNotEmpty) parts.add(address.state);
  if (address.country.isNotEmpty) parts.add(address.country);
  if (address.postalCode.isNotEmpty) parts.add("- ${address.postalCode}");
  if (address.direction?.isNotEmpty ?? false)
    parts.add("(${address.direction!})");

  return parts.join(", ");
}

String formataddress(dynamic address) {
  if (address is String) {
    return address;
  }

  List<String> parts = [];

  if (address.apartment?.isNotEmpty ?? false) {
    parts.add(address.apartment);
  }
  if (address.street?.isNotEmpty ?? false) {
    parts.add(address.street);
  }
  if (address.houseNo?.isNotEmpty ?? false) {
    parts.add(address.houseNo);
  }
  if (address.city?.isNotEmpty ?? false) {
    parts.add(address.city);
  }
  if (address.state?.isNotEmpty ?? false) {
    parts.add(address.state);
  }
  if (address.country?.isNotEmpty ?? false) {
    parts.add(address.country);
  }
  if (address.postalCode?.isNotEmpty ?? false) {
    parts.add('- ${address.postalCode}');
  }
  if (address.direction?.isNotEmpty ?? false) {
    parts.add(address.direction);
  }

  return parts.join(', ');
}
