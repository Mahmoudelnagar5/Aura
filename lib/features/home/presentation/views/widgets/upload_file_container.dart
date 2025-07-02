import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'browse_file_button.dart';
import 'package:aura/core/utils/assets.dart';

class UploadFileContainer extends StatelessWidget {
  const UploadFileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10.r),
      color: const Color(0xffCFD9E8),
      strokeWidth: 2,
      dashPattern: const [8, 4],
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height * 0.4,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 14.h,
            ),
            FittedBox(
              child: Text(
                'Drag and drop your file here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'or',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff0D141C),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Image.asset(
              Assets.assetsRobot2,
              height: MediaQuery.sizeOf(context).height * 0.14,
              width: MediaQuery.sizeOf(context).width * 0.32,
            ),
            SizedBox(
              height: 10.h,
            ),
            const BrowseFileButtton(),
          ],
        ),
      ),
    );
  }
}
