import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final String labelText;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final IconData? icon;
  final AutovalidateMode? autovalidateMode;

  const CustomDropdownField({
    Key? key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.validator,
    this.autovalidateMode,
    this.readOnly = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 15, vertical: 10), // ✅ Consistent padding
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // ✅ Adaptive background
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField<String>(
          value: value?.isNotEmpty == true
              ? value
              : null, // ✅ Ensure a non-null value
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 16), // ✅ Inner padding
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 16, color: Colors.grey.shade700),
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
            prefixIcon:
                icon != null ? Icon(icon, color: theme.primaryColor) : null,
          ),
          dropdownColor: theme.cardColor,
          icon: const Icon(Icons.arrow_drop_down,
              color: Colors.black, size: 28), // ✅ Match icon color
          style: const TextStyle(fontSize: 16, color: Colors.black),

          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black)),
                  ))
              .toList(),

          onChanged: readOnly ? null : onChanged, // ✅ Disable if read-only
          borderRadius: BorderRadius.circular(12), // ✅ Rounded dropdown menu
          menuMaxHeight: 300, // ✅ Restrict dropdown max height
          validator: validator,
        ),
      ),
    );
  }
}
