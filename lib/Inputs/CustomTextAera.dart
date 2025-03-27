import 'package:flutter/material.dart';

class CustomTextAera extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextAera({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null, // 🔸 allows text to grow vertically
      keyboardType: TextInputType.multiline, // 🔸 shows multi-line input
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
