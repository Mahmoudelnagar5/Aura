import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xff390050),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff390050),
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xff390050),
    secondary: const Color(0xff4A709C),
    surface: Colors.white,
    brightness: Brightness.light,
  ),
  cardColor: Colors.white,
  iconTheme: const IconThemeData(color: Color(0xff390050)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff390050),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  ),
);
