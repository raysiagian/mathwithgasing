
import 'package:flutter/material.dart';

class TextFieldRegisterWidget extends StatelessWidget {
  const TextFieldRegisterWidget({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (value) {
        if(value!.isEmpty){
          return 'field harus diisi';
        }
        return validator?.call(value);
      },
      decoration: InputDecoration(
        labelText: '$label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
