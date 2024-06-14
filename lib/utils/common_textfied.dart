import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputType? textInputType;
  final InputDecoration? decoration;
  const CustomTextFormField({
    super.key,
    this.textInputType,
    required this.hintText,
    required this.controller,
    this.decoration,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration :decoration,
      keyboardType: textInputType,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
