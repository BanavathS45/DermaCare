import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorSlotModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoctorSlotService {
  static Future<List<DoctorSlot>> fetchDoctorSlots(
      String doctorId, String hospitalId, String branchId) async {
    // final url = Uri.parse(
    //     '$clinicUrl/getDoctorslots/${hospitalId}/$doctorId'); //TODO:chnage api
    final curl = Uri.parse(
        '$registerUrl/getDoctorSlots/${hospitalId}/$branchId/$doctorId'); //TODO:chnage api

    print('📡 Requesting slots from: $curl');

    try {
      final response = await http.get(curl);
      print('📥 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final List<dynamic> dataList = jsonMap['data'];

        final List<DoctorSlot> slots =
            dataList.map((e) => DoctorSlot.fromJson(e)).toList();

        print(
            '✅ Parsed DoctorSlots Count: ${slots.map((e) => e.availableSlots.map((e) => e.slotbooked).toList()).toList()}');
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

static Future<bool> blockSlot({
  required String doctorId,
  required String date,
  required String slotTime,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final hospitalId = prefs.getString('hospitalId');
  final branchId = prefs.getString('branchId');

  if (hospitalId == null || branchId == null) {
    print('⚠️ Hospital or Branch ID not found in SharedPreferences');
    return false;
  }

  final url = Uri.parse("$registerUrl/block/slot/whileBooking");
  final payload = {
    "doctorId": doctorId,
    "serviceDate": date,
    "servicetime": slotTime,
    "status": true,
    "timeInMillis": DateTime.now().millisecondsSinceEpoch
  };

  print('📡 Blocking slot with payload: $payload');
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(payload),
  );

  print('📬 --- Block Slot API Response ---');
  print('🔗 URL: $url');
  print('📦 Request Payload: ${jsonEncode(payload)}');
  print('📥 Status Code: ${response.statusCode}');
  print('📩 Response Body: ${response.body}');
  print('🧾 Response Headers: ${response.headers}');
  print('📬 -------------------------------');

  // ✅ If response body is "true", skip JSON parsing
  if (response.statusCode == 200 && response.body.trim() == "true") {
    print('✅ Slot successfully blocked on server.');

    // 🌀 Now safely refresh slots list
    await fetchDoctorSlots(doctorId, hospitalId, branchId);
    return true;
  } else {
    print('❌ Slot block failed or invalid response.');
    return false;
  }
}
}
