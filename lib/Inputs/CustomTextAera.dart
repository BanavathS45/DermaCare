import 'package:cutomer_app/Utils/Constant.dart';
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
      maxLines: 2,
      keyboardType: TextInputType.multiline,
      validator: validator,
      onChanged: onChanged,
     
      decoration: InputDecoration(
        labelText: "Enter Your problem....",
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
