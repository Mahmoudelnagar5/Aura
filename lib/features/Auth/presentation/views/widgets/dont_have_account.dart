import 'package:animate_do/animate_do.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'dont_have_account'.tr(),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              context.push(AppRouter.signUpView);
            },
            child: Text(
              'sign_up'.tr(),
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
