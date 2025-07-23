import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/routing/app_router.dart';

void showLogoutDialog(BuildContext context, dynamic logoutCubit) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.bottomSlide,
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: Colors.orange,
            size: 60,
          ),
          const SizedBox(height: 20),
          FittedBox(
            child: Text(
              'confirm_logout'.tr(),
              style: GoogleFonts.sura(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 15),
          FittedBox(
            child: Text(
              'are_you_sure_logout'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.mali(
                fontSize: 17.sp,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      'cancel'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    logoutCubit.logout();
                    await Future.delayed(const Duration(milliseconds: 500));
                    context.pushReplacement(AppRouter.signInView);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      'logout'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    headerAnimationLoop: false,
  ).show();
}
