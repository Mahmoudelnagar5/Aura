import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/database/user_cache_helper.dart';
import '../../../../../core/widgets/cached_profile_image.dart';
import '../../manager/user_profile_cubit/update_profile_cubit.dart';

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
    // if (imageUrl != null && imageUrl.isNotEmpty) {
    //   imageUrl = '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}';
    // }

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
