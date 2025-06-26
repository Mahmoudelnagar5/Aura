import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../manger/auth_cubit/auth_cubit.dart';
import 'already_have_account.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({
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
            children: [
              SizedBox(
                height: 60.h,
              ),
              Align(
                alignment: Alignment.center,
                child: FadeInDown(
                  duration: Duration(milliseconds: 500),
                  child: Image.asset(
                    Assets.assetsLogo,
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              FadeInLeft(
                duration: Duration(milliseconds: 500),
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
              ),
              SizedBox(
                height: 15.h,
              ),
              _buildPasswordField(
                authCubit: authCubit,
                hintText: 'Password',
                onSaved: (value) => authCubit.password = value,
              ),
              SizedBox(
                height: 15.h,
              ),
              _buildPasswordField(
                authCubit: authCubit,
                hintText: 'Confirm Password',
                onSaved: (value) => authCubit.confirmPassword = value,
              ),

              SizedBox(
                height: 18.h,
              ),
              CustomButton(
                color: Color(0xff390050),
                text: 'Sign Up',
                colorText: Colors.white,
                onPressed: () {
                  // Dismiss the keyboard
                  FocusManager.instance.primaryFocus?.unfocus();
                  authCubit.performRegister();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              FadeInUp(
                duration: Duration(milliseconds: 500),
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
              AlreadyHaveAccount(),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required AuthCubit authCubit,
    required String hintText,
    required Function(String?)? onSaved,
  }) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is PasswordVisibilityUpdated,
      builder: (context, state) {
        return CustomTextField(
          hintText: hintText,
          prefixIcon: Icons.lock,
          obscureText: authCubit.isPasswordObscured,
          onIconPressed: authCubit.togglePasswordVisibility,
          suffixIcon: authCubit.buildVisibilityToggleIcon(),
          onSaved: onSaved,
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        );
      },
    );
  }
}
