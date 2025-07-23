import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'browse_file_button.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:easy_localization/easy_localization.dart';

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
        height: MediaQuery.sizeOf(context).height * 0.34,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadiusDirectional.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 8,
            ),
            FittedBox(
              child: Text(
                'drag_and_drop_file'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'or'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.titleSmall?.color,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              Assets.assetsRobot,
              height: MediaQuery.sizeOf(context).height * 0.11,
              width: MediaQuery.sizeOf(context).width * 0.32,
            ),
            const SizedBox(
              height: 10,
            ),
            const BrowseFileButtton(),
          ],
        ),
      ),
    );
  }
}
