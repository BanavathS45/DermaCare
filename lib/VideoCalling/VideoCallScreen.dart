import 'package:cutomer_app/VideoCalling/CallController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID, required this.username})
      : super(key: key);
  final String callID;
  final String username;

  @override
  Widget build(BuildContext context) {
    final callController = Get.find<CallController>();
    const appID = 1681219177;
    const appSign =
        "31514ace379e1a6c598b9f1751445c686263296006970354544b5ad259ad7cf4";

    return ZegoUIKitPrebuiltCall(
      appID: appID, // Replace with your Zego appID
      appSign: appSign, // Replace with your Zego appSign
      userID: callController.userID.value,
      userName: callController.userName.value,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (callEndEventData, defaultAction) {
          defaultAction.call();
          Get.back(); // return to previous screen
        },
      ),
    );
  }
}
