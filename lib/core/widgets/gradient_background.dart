import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: isDark
          ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 13, 13, 13),
                  Color.fromARGB(255, 0, 36, 73),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
          : null,
      child: child,
    );
  }
}
