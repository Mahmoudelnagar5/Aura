import 'package:flutter/material.dart';

class EditTextField extends StatelessWidget {
  const EditTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon,
    this.errorText,
  });

  final TextEditingController controller;
  final String labelText;
  final IconData? icon;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        errorText: errorText,
        errorMaxLines: 3,
      ),
    );
  }
}
