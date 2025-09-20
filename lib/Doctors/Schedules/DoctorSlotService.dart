import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorSlotModel.dart';
import 'package:http/http.dart' as http;

class DoctorSlotService {
  static Future<List<DoctorSlot>> fetchDoctorSlots(
      String doctorId, String hospitalId, String branchId) async {
    final url = Uri.parse(
        '$clinicUrl/getDoctorslots/${hospitalId}/$doctorId'); //TODO:chnage api
    final curl = Uri.parse(
        '$clinicUrl/getDoctorSlots/${hospitalId}/$branchId/$doctorId'); //TODO:chnage api

    print('📡 Requesting slots from: $url');

    try {
      final response = await http.get(url);
      print('📥 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final List<dynamic> dataList = jsonMap['data'];

        final List<DoctorSlot> slots =
            dataList.map((e) => DoctorSlot.fromJson(e)).toList();

        print('✅ Parsed DoctorSlots Count: ${slots.map((e) => e.date)}');
        return slots;
      } else {
        print('❌ Failed: ${response.body}');
        throw Exception('Failed to load doctor slots');
      }
    } catch (e) {
      print('💥 Error fetching slots: $e');
      rethrow;
    }
  }
}
