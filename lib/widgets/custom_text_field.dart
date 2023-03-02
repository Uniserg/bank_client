import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  double? width;
  String? errorText;

  CustomTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.obscureText = false,
      this.keyboardType,
      this.inputFormatters,
      this.validator,
      this.errorText,
      this.width = 300});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
          errorText: errorText,
        ),
      ),
    );
  }
}
