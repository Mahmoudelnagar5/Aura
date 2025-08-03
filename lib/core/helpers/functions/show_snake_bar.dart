import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
          child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: GoogleFonts.mali(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
          textAlign: TextAlign.center,
        ),
      )),
      backgroundColor: color,
    ),
  );
}
