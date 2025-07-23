import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/profile/data/models/user_profile_model.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/helpers/functions/show_snake_bar.dart';
import '../widgets/edit_profile_image.dart';
import '../widgets/edit_text_field.dart';
import 'show_image_picker_dialog.dart';

void showEditProfileSheet(
  BuildContext context,
  UserProfileModel user,
  UpdateProfileCubit updateProfileCubit,
) {
  final firstName = user.firstName ?? '';
  final lastName = user.lastName ?? '';
  final email = user.email ?? '';

  final firstNameController = TextEditingController(text: firstName);
  final lastNameController = TextEditingController(text: lastName);
  final emailController = TextEditingController(text: email);

  // Add fieldErrors state
  Map<String, String> fieldErrors = {};

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: updateProfileCubit,
        child: StatefulBuilder(
          builder: (context, setState) {
            return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
              listener: (context, state) {
                if (state is UpdateProfileSuccess) {
                  Navigator.pop(context);
                  showSnackBar(
                      context, 'Profile updated successfully', Colors.green);
                } else if (state is UpdateProfileError) {
                  // Handle field errors
                  if (state.errors != null) {
                    setState(() {
                      fieldErrors = Map.fromEntries(
                        state.errors!.entries.map(
                          (e) => MapEntry(
                              e.key,
                              (e.value is List
                                  ? e.value.join('\n')
                                  : e.value.toString())),
                        ),
                      );
                    });
                  } else {
                    Navigator.of(context).pop();
                    showSnackBar(context, state.errMessage, Colors.red);
                    setState(() {
                      fieldErrors = {};
                    });
                  }
                }
              },
              buildWhen: (previous, current) {
                // Rebuild UI when image is picked or profile is updated
                return current is UpdateProfileLoading ||
                    current is UpdateProfileSuccess ||
                    current is UpdateProfileError ||
                    current is EditProfileImageChanged;
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'edit_profile'.tr(),
                              style: GoogleFonts.sura(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Profile Image Section
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showImagePickerDialog(
                                  context, updateProfileCubit);
                            },
                            child: EditProfileImage(
                              updateProfileCubit: updateProfileCubit,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Form Fields
                        EditTextField(
                          icon: Icons.person,
                          controller: firstNameController,
                          labelText: 'first_name'.tr(),
                          errorText: fieldErrors['first_name'] ??
                              fieldErrors['firstName'],
                        ),
                        SizedBox(height: 12.h),
                        EditTextField(
                          icon: Icons.person,
                          controller: lastNameController,
                          labelText: 'last_name'.tr(),
                          errorText: fieldErrors['last_name'] ??
                              fieldErrors['lastName'],
                        ),
                        SizedBox(height: 12.h),
                        EditTextField(
                          icon: Icons.email,
                          controller: emailController,
                          labelText: 'email'.tr(),
                          errorText: fieldErrors['email'],
                        ),
                        SizedBox(height: 30.h),

                        // Update Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is UpdateProfileLoading
                                ? null
                                : () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() => fieldErrors = {});
                                    await updateProfileCubit.updateProfile(
                                      firstName:
                                          firstNameController.text.isNotEmpty
                                              ? firstNameController.text
                                              : null,
                                      lastName:
                                          lastNameController.text.isNotEmpty
                                              ? lastNameController.text
                                              : null,
                                      email: emailController.text.isNotEmpty
                                          ? emailController.text
                                          : null,
                                      profilePic:
                                          updateProfileCubit.selectedImage,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: state is UpdateProfileLoading
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'update_profile'.tr(),
                                    style: GoogleFonts.mali(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}
