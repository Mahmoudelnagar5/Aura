import 'package:animate_do/animate_do.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:aura/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';

class OnBoardingViewBody extends StatelessWidget {
  const OnBoardingViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                            'Your AI Study Buddy',
                            style: GoogleFonts.splineSans(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff0D141C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Upload your documents, get summaries, and take quizzes.',
                            style: GoogleFonts.splineSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
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
                    text: 'Create Account',
                    colorText: Colors.white,
                    color: const Color(0xff390050),
                    onPressed: () {
                      context.push(AppRouter.signUpView);
                    },
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    colorText: const Color(0xff390050),
                    text: 'Login',
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
    );
  }
}
