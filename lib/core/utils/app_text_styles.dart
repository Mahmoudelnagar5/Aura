import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Sura font styles
  static TextStyle sura({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.sura(
      fontSize: fontSize?.sp,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      height: height,
    );
  }

  // Mali font styles
  static TextStyle mali({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.mali(
      fontSize: fontSize?.sp,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      height: height,
    );
  }

  // Heading styles
  static TextStyle heading1({Color? color}) => sura(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle heading2({Color? color}) => sura(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle heading3({Color? color}) => sura(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle heading4({Color? color}) => sura(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Body text styles
  static TextStyle bodyLarge({Color? color}) => mali(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodyMedium({Color? color}) => mali(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySmall({Color? color}) => mali(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  // Button text styles
  static TextStyle buttonLarge({Color? color}) => mali(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  static TextStyle buttonMedium({Color? color}) => mali(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  static TextStyle buttonSmall({Color? color}) => mali(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  // Label styles
  static TextStyle label({Color? color}) => mali(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      );

  // Caption styles
  static TextStyle caption({Color? color}) => mali(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
      );
}
