import 'package:animate_do/animate_do.dart';
import 'package:aura/core/helpers/functions/show_snake_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../manger/auth_cubit/auth_cubit.dart';
import 'already_have_account.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

import 'signin_with_items.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({
    super.key,
  });

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Map<String, String> fieldErrors = {};

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return GradientBackground(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            showSnackBar(context, state.userModel.message, Colors.green);
            // context.pushReplacement(AppRouter.signInView);
            context
                .pushReplacement('/otp-verification?email=${authCubit.email!}');
          } else if (state is AuthError) {
            if (state.errors != null) {
              setState(() {
                showSnackBar(context, state.errMessage, Colors.red);
                fieldErrors = Map.fromEntries(state.errors!.entries.map(
                  (e) => MapEntry(e.key, e.value.join('\n')),
                ));
              });
            } else {
              showSnackBar(context, state.errMessage, Colors.red);
              setState(() {
                fieldErrors = {}; // Clear previous errors
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
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50.h,
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
                        height: 35.h,
                      ),
                      FadeInLeft(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          'create_account'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // PickImageWidget(),
                      SizedBox(
                        height: 18.h,
                      ),
                      CustomTextField(
                        hintText: 'first_name'.tr(),
                        prefixIcon: Icons.person,
                        onSaved: (value) => authCubit.firstName = value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'required'.tr()
                            : null,
                        errorText: fieldErrors['firstName'],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        hintText: 'last_name'.tr(),
                        prefixIcon: Icons.person,
                        onSaved: (value) => authCubit.lastName = value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'required'.tr()
                            : null,
                        errorText: fieldErrors['lastName'],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        hintText: 'email'.tr(),
                        prefixIcon: Icons.email,
                        onSaved: (value) => authCubit.email = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required'.tr();
                          }
                          // Email regex validation
                          final emailRegex =
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'The email field must be a valid email'.tr();
                          }
                          return null;
                        },
                        errorText: fieldErrors['email'],
                        onChanged: (value) {
                          if (fieldErrors['email'] != null) {
                            setState(() {
                              fieldErrors.remove('email');
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'password'.tr(),
                        prefixIcon: Icons.lock,
                        obscureText: !isPasswordVisible,
                        onSaved: (value) => authCubit.password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required'.tr();
                          }
                          if (value.length < 8) {
                            return 'password_min_length'.tr();
                          }
                          if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])')
                              .hasMatch(value)) {
                            return 'password_upper_lower'.tr();
                          }
                          if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                            return 'password_number'.tr();
                          }
                          return null;
                        },
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
                        onChanged: (value) {
                          if (fieldErrors['password'] != null) {
                            setState(() {
                              fieldErrors.remove('password');
                            });
                          }
                        },
                      ),

                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        controller: confirmPasswordController,
                        hintText: 'confirm_password'.tr(),
                        prefixIcon: Icons.lock,
                        obscureText: !isConfirmPasswordVisible,
                        onSaved: (value) => authCubit.confirmPassword = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required'.tr();
                          }
                          if (value != passwordController.text) {
                            return 'password_confirmation_not_match'.tr();
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color.fromARGB(255, 177, 177, 177),
                          ),
                          onPressed: toggleConfirmPasswordVisibility,
                        ),
                      ),

                      SizedBox(
                        height: 18.h,
                      ),
                      CustomButton(
                        color: Theme.of(context).colorScheme.primary,
                        text: 'sign_up'.tr(),
                        colorText: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () {
                          setState(() => fieldErrors = {});
                          FocusManager.instance.primaryFocus?.unfocus();
                          authCubit.performRegister();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                          thickness: 1,
                          indent: 40.w,
                          endIndent: 40.w,
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: FadeInLeft(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            'or_sign_in_with'.tr(),
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
                        height: 14.h,
                      ),
                      const AlreadyHaveAccount(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
