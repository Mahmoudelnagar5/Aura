import 'package:animate_do/animate_do.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/helpers/functions/show_snake_bar.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:aura/core/di/service_locator.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../manger/auth_cubit/auth_cubit.dart';
import 'dont_have_account.dart';
import 'signin_with_items.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({
    super.key,
  });

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  bool isPasswordVisible = false;
  Map<String, String> fieldErrors = {};

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showSnackBar(context, state.userModel.message, Colors.green);
          // Save user token and set logged in status
          final userCacheHelper = getIt<UserCacheHelper>();
          userCacheHelper.saveUserToken(state.userModel.userData.userToken);
          userCacheHelper.setLoggedIn(true);

          context.pushReplacement(AppRouter.homeView);
        } else if (state is AuthError) {
          if (state.errors != null) {
            setState(() {
              fieldErrors = Map.fromEntries(state.errors!.entries.map(
                (e) => MapEntry(e.key, e.value.join('\n')),
              ));
            });
          } else {
            showSnackBar(context, state.errMessage, Colors.red);
            setState(() {
              fieldErrors = {}; // Clear previous field-specific errors
            });
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AuthLoading,
          child: Form(
            key: authCubit.formKey,
            autovalidateMode: authCubit.validationMode,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: Image.asset(
                          Assets.assetsLogo,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    FadeInLeft(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        'Login to your Account',
                        style: GoogleFonts.inter(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    CustomTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      onSaved: (value) => authCubit.emailLogin = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      errorText: fieldErrors['email'],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomTextField(
                      hintText: 'password',
                      prefixIcon: Icons.lock,
                      obscureText: !isPasswordVisible,
                      onSaved: (value) => authCubit.passwordLogin = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      errorText: fieldErrors['password'],
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color.fromARGB(255, 177, 177, 177),
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FadeInRight(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff390050),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomButton(
                      color: const Color(0xff390050),
                      text: 'Sign in',
                      colorText: Colors.white,
                      onPressed: () {
                        setState(() => fieldErrors = {});
                        FocusManager.instance.primaryFocus?.unfocus();
                        authCubit.performLogin();
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Divider(
                        color: Colors.black54,
                        thickness: 1,
                        indent: 40.w,
                        endIndent: 40.w,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FadeInLeft(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          'Or Sign in with',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    const SignInWithItems(),
                    SizedBox(
                      height: 40.h,
                    ),
                    const DontHaveAccount(),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
