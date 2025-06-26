import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../manger/auth_cubit/auth_cubit.dart';
import 'dont_have_account.dart';
import 'signin_with_items.dart';

class SignInViewBody extends StatelessWidget {
  const SignInViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Form(
      key: authCubit.formKey,
      autovalidateMode: authCubit.validationMode,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                  duration: Duration(milliseconds: 300),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              FadeInLeft(
                duration: Duration(milliseconds: 300),
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
              ),
              SizedBox(
                height: 15.h,
              ),
              _buildPasswordField(authCubit),
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FadeInRight(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff390050),
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomButton(
                color: Color(0xff390050),
                text: 'Sign in',
                colorText: Colors.white,
                onPressed: () {
                  // Dimss  the keyboard
                  FocusManager.instance.primaryFocus?.unfocus();
                  authCubit.performLogin();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              FadeInUp(
                duration: Duration(milliseconds: 300),
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
                  duration: Duration(milliseconds: 300),
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
              SignInWithItems(),
              SizedBox(
                height: 40.h,
              ),
              DontHaveAccount(),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(AuthCubit authCubit) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is PasswordVisibilityUpdated,
      builder: (context, state) {
        return CustomTextField(
          hintText: 'Password',
          prefixIcon: Icons.lock,
          obscureText: authCubit.isPasswordObscured,
          onIconPressed: authCubit.togglePasswordVisibility,
          suffixIcon: authCubit.buildVisibilityToggleIcon(),
          onSaved: (value) => authCubit.passwordLogin = value,
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        );
      },
    );
  }
}
