import 'package:animate_do/animate_do.dart';
import 'package:aura/core/helpers/functions/show_snake_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../manger/auth_cubit/auth_cubit.dart';
import 'already_have_account.dart';

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
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showSnackBar(context, state.userModel.message, Colors.green);
          context.pushReplacement(AppRouter.signInView);
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
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
                      height: 40.h,
                    ),
                    FadeInLeft(
                      duration: const Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create your Account',
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // PickImageWidget(),
                    SizedBox(
                      height: 18.h,
                    ),
                    CustomTextField(
                      hintText: 'First Name',
                      prefixIcon: Icons.person,
                      onSaved: (value) => authCubit.firstName = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      errorText: fieldErrors['firstName'],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomTextField(
                      hintText: 'Last Name',
                      prefixIcon: Icons.person,
                      onSaved: (value) => authCubit.lastName = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      errorText: fieldErrors['lastName'],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      onSaved: (value) => authCubit.email = value,
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
                      onSaved: (value) => authCubit.password = value,
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
                      height: 15.h,
                    ),
                    CustomTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock,
                      obscureText: !isConfirmPasswordVisible,
                      onSaved: (value) => authCubit.confirmPassword = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      errorText: fieldErrors['password_confirmation'],
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
                      color: const Color(0xff390050),
                      text: 'Sign Up',
                      colorText: Colors.white,
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
                        color: Colors.black54,
                        thickness: 1,
                        indent: 40.w,
                        endIndent: 40.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const AlreadyHaveAccount(),
                    SizedBox(
                      height: 15.h,
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
