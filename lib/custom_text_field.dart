import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Color(0xffD8AC42)),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        labelText: labelText,
      ),
    );
  }
}