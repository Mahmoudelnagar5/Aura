import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? trailing;
  const ProfileMenuItem({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: icon != null
          ? Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.surface
                    : const Color(0xffF3F5FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color ?? Theme.of(context).colorScheme.primary,
                size: 17.sp,
              ),
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.mali(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 18.sp,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
      onTap: onTap,
      minLeadingWidth: 0,
      dense: true,
    );
  }
}
