import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/database/user_cache_helper.dart';
import '../../../../../core/widgets/cached_profile_image.dart';
import '../../../../profile/presentation/manager/user_profile_cubit/get_user_cubit.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(84.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserCubit, GetUserState>(
      builder: (context, state) {
        final userCacheHelper = getIt<UserCacheHelper>();
        final userName = userCacheHelper.getUserName() ?? '';
        final userImage = userCacheHelper.getUserProfileImage();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  CachedProfileImage(
                    imageUrl: userImage,
                    radius: 40.r,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        FittedBox(
                          child: Text(
                            'Welcome back!',
                            style: GoogleFonts.mali(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff0D141C),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FittedBox(
                          child: Text(
                            userName,
                            style: GoogleFonts.sora(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff0D141C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
