import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      this.labelText,
      this.obscureText,
      this.onChanged,
      this.errorText});

  final TextEditingController? controller;
  final String? labelText;
  final bool? obscureText;
  final Function(String value)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        obscureText: obscureText ?? false,
        controller: controller,
        onChanged: onChanged != null ? (value) => onChanged!(value) : null,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 12, right: 12),
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            labelText: labelText,
            errorText: errorText),
      ),
    );
  }
}
