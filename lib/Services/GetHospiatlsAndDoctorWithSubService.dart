import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import '../Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:http/http.dart' as http;

Future<List<HospitalDoctorModel>> fetchHospitalDoctorBySubServiceId(
    String subServiceId) async {
  final url = Uri.parse(
      '${clinicUrl}/getHospitalAndDoctorUsingSubServiceId/$subServiceId');
  print('API URL: $url');

  final response = await http.get(url);
  print('Status Code: ${response.statusCode}');

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    print('Response Body: $body');

    if (body['success'] == true && body['data'] is List) {
      final List<dynamic> dataList = body['data'];
      print('Total Hospitals Found: ${dataList.length}');

      List<HospitalDoctorModel> result = [];

      for (var item in dataList) {
        print('Parsing Hospital: ${item['name']}');
        Hospital hospital = Hospital.fromJson(item);

        // The "doctors" list inside the hospital
        if (item['doctors'] is List) {
          print('Doctors Found: ${item['doctors'].length}');
          for (var doctorJson in item['doctors']) {
            print('Parsing Doctor: ${doctorJson['doctorName']}');
            Doctor doctor = Doctor.fromJson(doctorJson);

            result.add(HospitalDoctorModel(
              doctor: doctor,
              hospital: hospital,
            ));
          }
        } else {
          print('No doctors found for hospital: ${item['name']}');
        }
      }

      print('Total Hospital-Doctor pairs parsed: ${result.length}');
      return result;
    } else {
      print('Invalid data format or success is false');
      throw Exception('Invalid data format');
    }
  } else {
    print('Failed to load data. Status: ${response.statusCode}');
    throw Exception('Failed to load data');
  }
}
