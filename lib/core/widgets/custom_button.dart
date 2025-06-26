import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.colorText,
  });
  final Color? color;
  final Color? colorText;
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: FadeInUp(
        duration: Duration(milliseconds: 300),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(360.w, 50.h),
            backgroundColor: color ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              side: BorderSide(
                color: Color(
                  0xff390050,
                ),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 15.sp,
              color: colorText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
