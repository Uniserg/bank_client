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
  Color? color;

  CustomTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.obscureText = false,
      this.keyboardType,
      this.inputFormatters,
      this.validator,
      this.errorText,
      this.width = 300,
        this.color
      });

  @override
  Widget build(BuildContext context) {

    color ??= Theme.of(context).primaryColor;

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
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: color!),
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          ),
          labelText: labelText,
          errorText: errorText,
        ),
      ),
    );
  }
}
