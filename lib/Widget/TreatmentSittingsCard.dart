import 'package:cutomer_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

class SittingDetailsCard extends StatelessWidget {
  final int totalSittings;
  final int takenSittings;
  final int currentSitting;
  final int pending;
  final VoidCallback? onTapDetails;

  const SittingDetailsCard({
    super.key,
    required this.totalSittings,
    required this.takenSittings,
    required this.currentSitting,
    required this.pending,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    double progress = takenSittings / totalSittings;
    progress = progress.isNaN ? 0 : progress;

    return Column(
      children: [
        const SizedBox(height: 16),

        // 🔹 Circular Progress with Left & Right Stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _sideStat("Taken", takenSittings.toString(), Colors.green),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: progress == 1 ? Colors.green : Colors.orangeAccent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Completed",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            _sideStat("Pending", pending.toString(), Colors.redAccent),
          ],
        ),

        const SizedBox(height: 20),

        // 🔹 Sitting Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _miniInfo("Total", "$totalSittings"),
            _miniInfo("Current", "$currentSitting"),
          ],
        ),

        const SizedBox(height: 20),

        // 🔹 Step Progress (Horizontal Scrollable)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(totalSittings, (index) {
              bool isCompleted = index < takenSittings;
              bool isCurrent = index + 1 == currentSitting;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? Colors.orange
                                : Colors.grey.shade300,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: (isCompleted || isCurrent)
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCompleted
                          ? "Done"
                          : isCurrent
                              ? "Now"
                              : "Next",
                      style: TextStyle(
                        fontSize: 11,
                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? Colors.orange
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _sideStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(title,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }

  Widget _miniInfo(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
