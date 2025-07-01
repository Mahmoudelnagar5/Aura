import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/profile/data/models/user_profile_model.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aura/core/widgets/cached_profile_image.dart';

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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is UpdateProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            // Rebuild UI when image is picked or profile is updated
            return current is UpdateProfileLoading ||
                current is UpdateProfileSuccess ||
                current is UpdateProfileError ||
                current is FormValidationState;
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
                          'Edit Profile',
                          style: GoogleFonts.sura(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: const Color(0xff0D141C),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.close, color: Color(0xff390050)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Profile Image Section
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showImagePickerDialog(context, updateProfileCubit);
                        },
                        child: EditProfileImage(
                          updateProfileCubit: updateProfileCubit,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Form Fields
                    EditTextField(
                        controller: firstNameController,
                        labelText: 'First Name'),
                    SizedBox(height: 12.h),
                    EditTextField(
                        controller: lastNameController, labelText: 'Last Name'),
                    SizedBox(height: 12.h),
                    EditTextField(
                      controller: emailController,
                      labelText: 'Email',
                    ),
                    SizedBox(height: 30.h),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is UpdateProfileLoading
                            ? null
                            : () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await updateProfileCubit.updateProfile(
                                  firstName: firstNameController.text.isNotEmpty
                                      ? firstNameController.text
                                      : null,
                                  lastName: lastNameController.text.isNotEmpty
                                      ? lastNameController.text
                                      : null,
                                  email: emailController.text.isNotEmpty
                                      ? emailController.text
                                      : null,
                                  profilePic: updateProfileCubit.selectedImage,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff390050),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: state is UpdateProfileLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Update Profile',
                                style: GoogleFonts.mali(
                                  color: Colors.white,
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
        ),
      );
    },
  );
}

class EditTextField extends StatelessWidget {
  const EditTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff390050)),
        ),
      ),
    );
  }
}

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({
    super.key,
    required this.updateProfileCubit,
  });

  final UpdateProfileCubit updateProfileCubit;

  @override
  Widget build(BuildContext context) {
    String? imageUrl = getIt<UserCacheHelper>().getUserProfileImage();
    // Add a dummy parameter to force the cache to update, same as in ProfileView
    if (imageUrl != null && imageUrl.isNotEmpty) {
      imageUrl = '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}';
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xff390050),
                Color(0xff6A0DAD),
              ],
            ),
          ),
          child: updateProfileCubit.hasSelectedImage
              ? CircleAvatar(
                  radius: 60.r,
                  backgroundImage:
                      FileImage(File(updateProfileCubit.selectedImage!.path)),
                )
              : CachedProfileImage(
                  key: ValueKey(imageUrl),
                  imageUrl: imageUrl,
                  radius: 60.r,
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: const BoxDecoration(
              color: Color(0xff390050),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}

void _showImagePickerDialog(
    BuildContext context, UpdateProfileCubit updateProfileCubit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Choose Image Source',
          style: GoogleFonts.sura(
            fontWeight: FontWeight.bold,
            color: const Color(0xff0D141C),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xff390050)),
              title: Text(
                'Camera',
                style: GoogleFonts.mali(color: const Color(0xff0D141C)),
              ),
              onTap: () {
                Navigator.pop(context);
                updateProfileCubit.pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xff390050)),
              title: Text(
                'Gallery',
                style: GoogleFonts.mali(color: const Color(0xff0D141C)),
              ),
              onTap: () {
                Navigator.pop(context);
                updateProfileCubit.pickImage(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );
}
