import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key, required this.controller, this.validator, this.labelText = "Пароль"});

  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final String labelText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      validator: widget.validator,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(_passwordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          border: const OutlineInputBorder(),
          labelText: widget.labelText),
    );
  }
}