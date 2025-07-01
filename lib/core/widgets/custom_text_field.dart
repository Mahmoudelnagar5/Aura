import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
                return 'Please fill all fields';
              }
              return null;
            },
        onSaved: onSaved,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          errorText: errorText,
          errorMaxLines: 4,
          // errorMaxLines: 2,
          hoverColor: const Color(0xffD9D9D9).withOpacity(0.3),
          fillColor: const Color(0xffD9D9D9).withOpacity(0.3),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon != null
              ? IconButton(
                  onPressed: onIconPressed,
                  color: const Color(0xffD9D9D9),
                  icon: Icon(
                    prefixIcon,
                    size: 18.sp,
                    color: const Color(0xffD9D9D9),
                  ),
                )
              : null,
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: const Color(0xffD9D9D9).withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: const Color(0xffD9D9D9).withOpacity(0.3),
            ),
          ),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
