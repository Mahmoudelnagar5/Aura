import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import 'package:aura/core/di/service_locator.dart';

import '../../../../../core/helpers/functions/show_snake_bar.dart';

void showChangePasswordSheet(BuildContext context) {
  final updateProfileCubit = getIt<UpdateProfileCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: updateProfileCubit,
        child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              Navigator.pop(context);
              showSnackBar(
                  context, 'Password changed successfully', Colors.green);
            } else if (state is UpdateProfileError) {
              showSnackBar(context, state.errMessage, Colors.red);
            }
          },
          buildWhen: (previous, current) {
            return current is UpdateProfileLoading ||
                current is UpdateProfileSuccess ||
                current is UpdateProfileError ||
                current is PasswordVisibilityUpdated ||
                current is ConfirmPasswordVisibilityUpdated;
          },
          builder: (context, state) {
            return ChangePasswordSheet(state: state);
          },
        ),
      );
    },
  );
}

class ChangePasswordSheet extends StatefulWidget {
  final UpdateProfileState state;

  const ChangePasswordSheet({
    super.key,
    required this.state,
  });

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: context.read<UpdateProfileCubit>().formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildCurrentPasswordField(),
              SizedBox(height: 16.h),
              _buildNewPasswordField(),
              SizedBox(height: 16.h),
              _buildConfirmPasswordField(),
              SizedBox(height: 24.h),
              _buildChangeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Change Password',
          style: GoogleFonts.sura(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: const Color(0xff0D141C),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Color(0xff390050)),
        ),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return TextFormField(
      controller: currentPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Current Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff390050)),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff390050)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Current password is required';
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordField() {
    final cubit = context.read<UpdateProfileCubit>();

    return TextFormField(
      controller: newPasswordController,
      obscureText: !cubit.isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'New Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff390050)),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff390050)),
        suffixIcon: IconButton(
          icon: Icon(
            cubit.isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xff390050),
          ),
          onPressed: cubit.togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'New password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    final cubit = context.read<UpdateProfileCubit>();

    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !cubit.isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm New Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff390050)),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff390050)),
        suffixIcon: IconButton(
          icon: Icon(
            cubit.isConfirmPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xff390050),
          ),
          onPressed: cubit.toggleConfirmPasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your new password';
        }
        if (value != newPasswordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildChangeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            widget.state is UpdateProfileLoading ? null : _handleChangePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff390050),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: widget.state is UpdateProfileLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Change Password',
                style: GoogleFonts.mali(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _handleChangePassword() async {
    final cubit = context.read<UpdateProfileCubit>();

    if (cubit.formKey.currentState?.validate() ?? false) {
      await cubit.updateProfile(
        password: newPasswordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      );
    }
  }
}
