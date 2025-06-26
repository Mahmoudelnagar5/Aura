import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
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
    return CrystalNavigationBar(
      margin: EdgeInsets.zero,
      marginR: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      enablePaddingAnimation: true,
      currentIndex: currentIndex,
      onTap: onTap,
      borderRadius: 50.r,
      unselectedItemColor: Colors.white70,
      backgroundColor: const Color(0xff390050),
      outlineBorderColor: Colors.white,
      items: [
        CrystalNavigationBarItem(
          icon: IconlyBold.home,
          unselectedIcon: IconlyLight.home,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.paper,
          unselectedIcon: IconlyLight.paper,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.profile,
          unselectedIcon: IconlyLight.profile,
          selectedColor: Colors.white,
        ),
      ],
    );
  }
}
