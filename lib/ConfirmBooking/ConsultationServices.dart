import 'dart:convert';

import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Utils/ShowSnackBar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Screens/CategoryAndServicesForm.dart';
import 'ConsultationController.dart';

Future<List<ConsultationModel>> getConsultationDetails() async {
  try {
    final url = Uri.parse(consultationUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody['success'] == true && responseBody['data'] != null) {
        final List<dynamic> dataList = responseBody['data'];

        final List<ConsultationModel> consultations = dataList
            .map((jsonItem) => ConsultationModel.fromJson(jsonItem))
            .toList();

        return consultations;
      } else {
        showSnackbar("Error", "No consultation data found", "error");
        return [];
      }
    } else {
      showSnackbar("Error", "API Failed: ${response.statusCode}", "error");
      return [];
    }
  } catch (e) {
    print("API Error: $e");
    showSnackbar("Error", "Something went wrong", "error");
    return [];
  }
}

class ConsultationModel {
  final String consultationType;
  final String consultationId;

  ConsultationModel({
    required this.consultationType,
    required this.consultationId,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      consultationType: json['consultationType'],
      consultationId: json['consultationId'],
    );
  }
}
