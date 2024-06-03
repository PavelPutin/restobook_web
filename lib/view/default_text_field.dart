import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.keyboardType = TextInputType.text,
      this.validator, this.onChange});

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: labelText),
      validator: validator,
      onChanged: onChange,
    );
  }
}
