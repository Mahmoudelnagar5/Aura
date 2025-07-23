import 'package:flutter/material.dart';

const Color kDarkBgStart = Color(0xFF181A20);
const Color kDarkBgEnd = Color(0xFF23243B);
const Color kAccent = Color(0xff00E0FF);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kAccent,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: const ColorScheme.dark(
    primary: kAccent,
    secondary: kAccent,
    surface: kDarkBgEnd,
    brightness: Brightness.dark,
  ),
  cardColor: kDarkBgEnd,
  iconTheme: const IconThemeData(color: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: kDarkBgEnd,
    selectedColor: kAccent,
    labelStyle: TextStyle(color: Colors.white),
    secondaryLabelStyle: TextStyle(color: Colors.white),
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
);
