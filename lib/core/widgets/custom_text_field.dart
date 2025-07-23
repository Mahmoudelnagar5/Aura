import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.obscureText = false,
    this.onIconPressed,
    this.onSaved,
    this.prefixIcon,
    this.suffixIcon,
    this.autofillHints,
    this.controller,
    this.validator,
    this.errorText,
  });
  final String? hintText;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onIconPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: TextFormField(
        controller: controller,
        autofillHints: autofillHints,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'please_fill_all_fields'.tr();
              }
              return null;
            },
        onSaved: onSaved,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          errorText: errorText,
          errorMaxLines: 4,
          labelText: hintText,
          labelStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon != null
              ? IconButton(
                  onPressed: onIconPressed,
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icon(
                    prefixIcon,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
