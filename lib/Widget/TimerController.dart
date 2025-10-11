import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

class TimerController extends GetxController {
  RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  void startTimer({int seconds = 120}) {
    _timer?.cancel();
    remainingSeconds.value = seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        t.cancel();
        Get.offAllNamed('/dashboard'); // ✅ navigate when finished
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
