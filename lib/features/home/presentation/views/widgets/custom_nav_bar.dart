import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DotNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.secondary
            : const Color(0xff390050),
        enableFloatingNavBar: true,
        enablePaddingAnimation: true,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.white70,
        marginR: EdgeInsets.symmetric(horizontal: 20.w),
        paddingR: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        borderRadius: 30.r,
        // itemPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        items: [
          DotNavigationBarItem(
            icon: const Icon(IconlyLight.home),
            selectedColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
          DotNavigationBarItem(
            icon: const Icon(IconlyLight.paper),
            selectedColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
          DotNavigationBarItem(
            icon: const Icon(IconlyLight.profile),
            selectedColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
        ],
      ),
    );
  }
}
