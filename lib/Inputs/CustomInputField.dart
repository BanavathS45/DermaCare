import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? suffixText;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? hintText;
  final bool obscureText;
  final void Function(String)? onSubmitted;

  // final bool isPassword; // ✅ Add this flag

  const CustomTextField({
    Key? key,
    required this.controller, // ✅ Ensure this is required
    required this.labelText,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.validator,
    this.readOnly = false,
    this.autovalidateMode,
    this.suffixIcon,
    this.suffixText,
    this.minLines,
    this.maxLines,
    this.prefixIcon,
    this.prefixText,
    this.obscureText = false,
    this.onSubmitted,
    this.hintText, // ✅ Added hint text parameter
    // this.isPassword = false, // ✅ Default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); // ✅ Theme-aware colors
//  bool _isObscured = true;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 15, vertical: 10), // ✅ Global padding
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor, // ✅ Adaptive background
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              // blurRadius: 5,
              // offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          readOnly: readOnly,
          obscureText: obscureText,
          autovalidateMode: autovalidateMode,
          minLines: minLines,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 16), // ✅ Inner padding
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: prefixIcon, // ✅
            prefixText: prefixText, // ✅
            suffixIcon: suffixIcon, // ✅
            suffixText: suffixText,
            suffixStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.primaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          onFieldSubmitted: onSubmitted,
        ),
      ),
    );
  }
}
