import 'package:flutter/material.dart';

class CustomTextAera extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator; // ✅ Added validator
  final AutovalidateMode? autovalidateMode;

  const CustomTextAera({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ✅ Use TextFormField for validation
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      validator: validator, // ✅ Attach validator
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
