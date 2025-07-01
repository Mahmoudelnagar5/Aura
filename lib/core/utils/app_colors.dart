import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xff390050);
  static const Color primaryLight = Color(0xff6A0DAD);

  // Text colors
  static const Color textPrimary = Color(0xff0D141C);
  static const Color textSecondary = Color(0xff6B7280);

  // Background colors
  static const Color background = Colors.white;
  static const Color surface = Color(0xffF9FAFB);

  // Status colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;

  // Border colors
  static const Color border = Color(0xffE5E7EB);
  static const Color borderFocused = Color(0xff390050);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xff390050),
    Color(0xff6A0DAD),
  ];

  // Shadow colors
  static Color shadow = Colors.black.withOpacity(0.1);
  static Color shadowLight = Colors.black.withOpacity(0.05);
}
