import 'package:animate_do/animate_do.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:aura/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBoardingViewBody extends StatelessWidget {
  const OnBoardingViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 60.h),
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            Image.asset(
                              Assets.assetsRobot,
                              height: 250.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'your_ai_study_buddy'.tr(),
                              style: GoogleFonts.splineSans(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'onboarding_subtitle'.tr(),
                              style: GoogleFonts.splineSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'create_account'.tr(),
                      colorText: Theme.of(context).colorScheme.onPrimary,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        context.push(AppRouter.signUpView);
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomButton(
                      colorText: Theme.of(context).colorScheme.primary,
                      text: 'login'.tr(),
                      onPressed: () {
                        context.push(AppRouter.signInView);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
