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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            duration: Duration(milliseconds: 500),
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  FadeInImage(
                    fadeInDuration: const Duration(milliseconds: 500),
                    image: AssetImage(Assets.assetsRobot),
                    placeholder: AssetImage(Assets.assetsRobot),
                  ),
                  Text(
                    'Your AI Study Buddy',
                    style: GoogleFonts.splineSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0D141C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
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
          ),
          SizedBox(
            height: 70.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: CustomButton(
              text: 'Create Account',
              colorText: Colors.white,
              color: Color(0xff390050),
              onPressed: () {
                context.pushReplacement(AppRouter.signUpView);
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: CustomButton(
              colorText: Color(0xff390050),
              text: 'Login',
              onPressed: () {
                context.pushReplacement(AppRouter.signInView);
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
