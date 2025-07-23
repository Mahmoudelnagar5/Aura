import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import 'package:aura/core/di/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';

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
            }
          },
          buildWhen: (previous, current) {
            return current is UpdateProfileLoading ||
                current is UpdateProfileSuccess ||
                current is UpdateProfileError ||
                current is PasswordVisibilityUpdated ||
                current is ConfirmPasswordVisibilityUpdated ||
                current is CurrentPasswordVisibilityUpdated;
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

  Map<String, String> fieldErrors = {};

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract field errors from state if available
    if (widget.state is UpdateProfileError) {
      final errors = (widget.state as UpdateProfileError).errors;
      if (errors != null) {
        fieldErrors = Map.fromEntries(errors.entries.map(
          (e) => MapEntry(e.key, e.value.join('\n')),
        ));
      } else {
        fieldErrors = {};
      }
    } else {
      fieldErrors = {};
    }

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
          'change_password'.tr(),
          style: GoogleFonts.sura(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildNewPasswordField() {
    final cubit = context.read<UpdateProfileCubit>();

    return TextFormField(
      controller: newPasswordController,
      obscureText: !cubit.isNewPasswordVisible,
      decoration: InputDecoration(
        labelText: 'new_password'.tr(),
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        prefixIcon: Icon(Icons.lock_outline,
            color: Theme.of(context).colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            cubit.isNewPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: cubit.toggleNewPasswordVisibility,
        ),
        errorText: fieldErrors['password'],
        errorMaxLines: 3,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'new_password_required'.tr();
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
        labelText: 'confirm_new_password'.tr(),
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        prefixIcon: Icon(Icons.lock_outline,
            color: Theme.of(context).colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            cubit.isConfirmPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: cubit.toggleConfirmPasswordVisibility,
        ),
        errorText: fieldErrors['password_confirmation'],
        errorMaxLines: 3,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'confirm_new_password_required'.tr();
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: widget.state is UpdateProfileLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'change_password'.tr(),
                style: GoogleFonts.mali(
                  color: Theme.of(context).colorScheme.onPrimary,
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
