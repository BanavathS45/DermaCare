import 'package:cutomer_app/Widget/TimerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalTimerFAB extends StatelessWidget {
  const GlobalTimerFAB({super.key});

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();

    return Obx(() {
      if (timerController.remainingSeconds.value <= 0) {
        return const SizedBox.shrink();
      }
      return Positioned(
        bottom: 80,
        right: 16,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () {},
          icon: const Icon(Icons.timer),
          label: Text(
            formatTime(timerController.remainingSeconds.value),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    });
  }
}
