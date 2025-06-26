import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentItem extends StatelessWidget {
  const RecentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40.w,
        height: 60.h,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Color(0xffE8EDF5),
        ),
        child: Icon(
          IconlyLight.document,
          color: Colors.grey,
          size: 25.sp,
        ),
      ),
      title: Text(
        'Document.pdf',
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Uploaded 12/12/2023',
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          color: Color(0xff4A709C),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
