import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          FadeInDown(
            duration: Duration(milliseconds: 300),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const AssetImage("assets/avatar.png"),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Mahmoud Elnagar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(65.0);
}
