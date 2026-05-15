import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomInput extends StatelessWidget {
  final String name;
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomInput({
    super.key,
    required this.name,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color.fromARGB(255, 21, 95, 192)),
        ),
      ),
    );
  }
}
