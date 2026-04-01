import 'package:flutter/material.dart';

class CustomTextAera extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  const CustomTextAera({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.autovalidateMode,
    this.onChanged, // <-- add this
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ✅ Use TextFormField for validation
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      validator: validator,
      onChanged: onChanged,
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
