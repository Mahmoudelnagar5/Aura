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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ],
            ),
          ),
          child: updateProfileCubit.hasSelectedImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(60.r),
                  child: Image.file(
                    File(updateProfileCubit.selectedImage!.path),
                    fit: BoxFit.cover,
                    width: 120.r,
                    height: 120.r,
                    filterQuality: FilterQuality.high,
                  ),
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
