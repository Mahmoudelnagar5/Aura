import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback onTap;
  final IconData? icon;
  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: icon != null
          ? Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: const Color(0xffF5F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color ?? const Color(0xff390050),
                size: 17.sp,
              ),
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.mali(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: color ?? const Color(0xff0D141C),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18.sp,
        color: color ?? Colors.black54,
      ),
      onTap: onTap,
      minLeadingWidth: 0,
      dense: true,
    );
  }
}
